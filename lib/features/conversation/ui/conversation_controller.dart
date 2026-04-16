// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/home/ui/widget/chat_bubble_widget.dart';
import '../services/conversation_service.dart';
import '../models/conversation_model.dart';

class ConversationController extends ChangeNotifier {
  static ConversationController? activeInstance;

  final ConversationService _service = ConversationService();

  List<ConversationModel> conversations = [];
  bool isLoading = true;
  String? errorMessage;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  ConversationController() {
    activeInstance = this;
  }

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchConversations();

    if (result['success'] == true) {
      conversations = result['data'];
      print('conversations: ${conversations.map((e) => e.toJson()).toList()}');
      ChatBubbleWidget.unreadCounter.value = result['totalUnreadCount'];
    } else {
      errorMessage = result['error'];
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    activeInstance = null;
    super.dispose();
  }

  /// Called by WebsocketGateway when a new_message event arrives
  void handleIncomingMessage(Map<String, dynamic> data) {
    final result = _service.processIncomingMessage(conversations, data);

    ChatBubbleWidget.unreadCounter.value = result.totalUnreadCount;

    if (result.updatedConv != null) {
      if (result.isExisting) {
        _animateAndMoveToTop(result.oldIndex, result.updatedConv!);
      } else {
        _animateAndInsertNew(result.updatedConv!);
      }
    }
  }

  // Animate: Remove old item and insert new item at top
  void _animateAndMoveToTop(int oldIndex, ConversationModel updatedConv) {
    if (oldIndex == 0) {
      conversations[0] = updatedConv;
      notifyListeners();
      return;
    }

    conversations.removeAt(oldIndex);
    listKey.currentState?.removeItem(
      oldIndex,
      (context, animation) => const SizedBox.shrink(),
      duration: const Duration(milliseconds: 100),
    );

    conversations.insert(0, updatedConv);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );

    notifyListeners();
  }

  // Animate: Insert new item at top
  void _animateAndInsertNew(ConversationModel newConv) {
    conversations.insert(0, newConv);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );
    notifyListeners();
  }

  // Update last message dynamically locally
  void updateLastMessageLocally(
    String conversationId,
    String type,
    String? content,
  ) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      String snippet = content ?? '';
      if (type == 'IMAGE') snippet = '[Hình ảnh]';
      if (type == 'VIDEO') snippet = '[Video]';
      if (type == 'AUDIO') snippet = '[Âm thanh]';

      final updatedConv = conversations[index].copyWith(
        lastMessageSnippet: snippet,
        lastMessageAt: DateTime.now(),
      );
      _animateAndMoveToTop(index, updatedConv);
    }
  }

  // Remove badge unread count in UI (local)
  void markAsReadLocally(String conversationId) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && conversations[index].myUnreadCount > 0) {
      int currentTotal = ChatBubbleWidget.unreadCounter.value;
      ChatBubbleWidget.unreadCounter.value =
          currentTotal - conversations[index].myUnreadCount;

      conversations[index] = conversations[index].copyWith(myUnreadCount: 0);
      notifyListeners();
    }
  }
}
