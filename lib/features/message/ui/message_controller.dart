// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/message/service/message_socket.dart';
import 'package:pingme_manager/shared/websocket/websocket_gateway.dart';
import 'package:uuid/uuid.dart';
import '../models/message_model.dart';
import '../service/message_service.dart';
import '../../../shared/media/media_service.dart';
import '../../../shared/media/dto/pending_media_upload.dart';
import '../../conversation/ui/conversation_controller.dart';

class MessageController extends ChangeNotifier {
  static MessageController? activeInstance;
  final MessageService _messageService;
  final MediaService _mediaService = MediaService();
  final MessageSocket _messageSocket = MessageSocket();

  List<PendingMediaUpload> uploadQueue = [];
  bool isUploadingQueue = false;

  final String conversationId;
  final String currentUserId;
  final String partnerId;

  bool isLoading = true;
  String? errorMessage;
  List<MessageItem> messages = [];

  bool isPartnerTyping = false;
  bool isPartnerOnline = false;

  Timer? _typingTimer;
  bool _isTypingLocal = false;

  int _currentPage = 1;
  bool hasMore = true;

  final TextEditingController textController = TextEditingController();

  MessageController({
    MessageService? service,
    required this.conversationId,
    required this.currentUserId,
    required this.partnerId,
  }) : _messageService = service ?? MessageService() {
    activeInstance = this;
    isPartnerOnline = WebsocketGateway().isUserOnline(partnerId);
    _initSocketListeners();
    _setupTypingListener();
    fetchMessages();
  }

  /// Init socket listen event
  void _initSocketListeners() {
    _messageSocket.listenToMessageEvents(
      onTyping: (data) {
        if (data['conversationId'] == conversationId &&
            data['userId'] == partnerId) {
          isPartnerTyping = data['isTyping'] ?? false;
          notifyListeners();
        }
      },
      onMessageSentSuccess: (data) {
        final tempId = data['temporaryId'];
        final realMessage = MessageItem.fromJson(data['message']);

        final index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messages[index] = realMessage;
          notifyListeners();
        }
      },
      onMessageError: (data) {
        final tempId = data['temporaryId'];
        messages.removeWhere((m) => m.id == tempId);
        errorMessage = data['message'] ?? 'Lỗi gửi tin nhắn';
        notifyListeners();
      },
      onUserOnline: (data) {
        if (data['userId'] == partnerId) {
          isPartnerOnline = true;
          notifyListeners();
        }
      },
      onUserOffline: (data) {
        if (data['userId'] == partnerId) {
          isPartnerOnline = false;
          notifyListeners();
        }
      },
      onMessagesRead: (data) {
        if (data['conversationId'] == conversationId &&
            data['userId'] == partnerId) {
          bool changed = false;
          for (int i = 0; i < messages.length; i++) {
            if (messages[i].senderId == currentUserId && !messages[i].isRead) {
              final m = messages[i];
              messages[i] = MessageItem(
                id: m.id,
                conversationId: m.conversationId,
                senderId: m.senderId,
                content: m.content,
                type: m.type,
                isRevoked: m.isRevoked,
                isRead: true,
                createdAt: m.createdAt,
                sender: m.sender,
                replyTo: m.replyTo,
                media: m.media,
              );
              changed = true;
            }
          }
          if (changed) notifyListeners();
        }
      },
    );
  }

  void _setupTypingListener() {
    textController.addListener(() {
      final text = textController.text;
      if (text.isNotEmpty && !_isTypingLocal) {
        _isTypingLocal = true;
        _messageSocket.sendTyping(conversationId, true);
      } else if (text.isEmpty && _isTypingLocal) {
        _isTypingLocal = false;
        _messageSocket.sendTyping(conversationId, false);
      }

      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (_isTypingLocal) {
          _isTypingLocal = false;
          _messageSocket.sendTyping(conversationId, false);
        }
      });
    });
  }

  /// Helper: Update partner online status
  void updatePartnerOnlineStatus(String userId, bool isOnline) {
    if (userId == partnerId && isPartnerOnline != isOnline) {
      isPartnerOnline = isOnline;
      notifyListeners();
    }
  }

  /// API: Get messages history
  Future<void> fetchMessages({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!hasMore) return;
      _currentPage++;
    } else {
      isLoading = true;
      _currentPage = 1;
      errorMessage = null;
      notifyListeners();
    }

    try {
      final responseData = await _messageService.fetchMessages(
        conversationId,
        page: _currentPage,
      );

      if (isLoadMore) {
        messages.addAll(responseData.messages);
      } else {
        messages = responseData.messages;
      }

      hasMore = _currentPage < responseData.meta.totalPages;
      errorMessage = null;
      _messageSocket.markAsRead(conversationId);
    } catch (e) {
      errorMessage = e.toString();
      if (isLoadMore) _currentPage--;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Socket: emit event send message
  Future<void> sendMessage(String senderId) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final temporaryId = const Uuid().v4();

    final tempMessage = MessageItem(
      id: temporaryId,
      conversationId: conversationId,
      senderId: currentUserId,
      content: text,
      type: 'TEXT',
      isRevoked: false,
      isRead: false,
      createdAt: DateTime.now(),
      sender: Sender(id: currentUserId, fullname: 'Tôi'),
    );
    messages.insert(0, tempMessage);
    ConversationController.activeInstance?.updateLastMessageLocally(conversationId, 'TEXT', text);

    textController.clear();
    _isTypingLocal = false;
    _messageSocket.sendTyping(conversationId, false);
    _typingTimer?.cancel();
    notifyListeners();

    _messageSocket.sendMessage(
      conversationId: conversationId,
      content: text,
      type: 'TEXT',
      temporaryId: temporaryId,
    );
  }

  /// Socket: listen event receive new message
  void handleIncomingMessage(Map<String, dynamic> data) {
    try {
      if (data['conversationId'] == conversationId) {
        final newMsg = MessageItem.fromJson(data['message']);
        messages.insert(0, newMsg);
        _messageSocket.markAsRead(conversationId);
        notifyListeners();
      }
    } catch (e) {
      print('Lỗi parse tin nhắn mới: $e');
    }
  }

  /// Queue background media files
  Future<void> enqueueMediaFiles(List<String> filePaths, String type) async {
    for (var path in filePaths) {
      final tempId = const Uuid().v4();

      final tempMessage = MessageItem(
        id: tempId,
        conversationId: conversationId,
        senderId: currentUserId,
        content: path,
        type: type,
        isRevoked: false,
        isRead: false,
        createdAt: DateTime.now(),
        sender: Sender(id: currentUserId, fullname: 'Tôi'),
      );
      messages.insert(0, tempMessage);
      ConversationController.activeInstance?.updateLastMessageLocally(conversationId, type, path);

      uploadQueue.add(
        PendingMediaUpload(id: tempId, filePath: path, type: type),
      );
    }

    notifyListeners();
    _processUploadQueue();
  }

  /// Helper: Upload media file
  Future<void> _processUploadQueue() async {
    if (isUploadingQueue) return;
    isUploadingQueue = true;

    try {
      while (uploadQueue.isNotEmpty) {
        final current = uploadQueue.first;

        try {
          final signature = await _mediaService.getSignature();
          final cloudinaryRes = await _mediaService.uploadToCloudinary(
            fileUri: current.filePath,
            signatureData: signature,
            resourceType: current.type.toLowerCase() == 'video'
                ? 'video'
                : 'image',
          );

          final dbRes = await _mediaService.createMediaRecord(cloudinaryRes);
          final mediaId = dbRes['id'];

          _messageSocket.sendMessage(
            conversationId: conversationId,
            content: '',
            type: current.type,
            temporaryId: current.id,
            mediaId: mediaId,
          );

          uploadQueue.removeAt(0);
        } catch (e) {
          print('Lỗi upload file ${current.filePath}: $e');

          uploadQueue.removeAt(0);
          messages.removeWhere((m) => m.id == current.id);
          errorMessage = 'Lỗi upload media!';
          notifyListeners();
        }
      }
    } finally {
      isUploadingQueue = false;
    }
  }

  @override
  void dispose() {
    activeInstance = null;
    _typingTimer?.cancel();
    _messageSocket.removeListeners();
    textController.dispose();
    super.dispose();
  }
}
