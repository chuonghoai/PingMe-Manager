import 'package:flutter/material.dart';
import 'package:pingme_manager/features/home/ui/widget/chat_bubble_widget.dart';
import '../services/conversation_service.dart';
import '../services/conversation_socket.dart';
import '../models/conversation_model.dart';

class ConversationController extends ChangeNotifier {
  final ConversationService _service = ConversationService();
  final ConversationSocket _socket = ConversationSocket();

  List<ConversationModel> conversations = [];
  bool isLoading = true;
  String? errorMessage;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchConversations();

    if (result['success'] == true) {
      conversations = result['data'];
      ChatBubbleWidget.unreadCounter.value = result['totalUnreadCount'];
      _setupWebsocket();
    } else {
      errorMessage = result['error'];
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _socket.removeWebsocketListeners();
    super.dispose();
  }

  // Listen websocket
  void _setupWebsocket() {
    _socket.listenToNewMessages((data) {
      final result = _service.processIncomingMessage(conversations, data);

      ChatBubbleWidget.unreadCounter.value = result.totalUnreadCount;

      if (result.updatedConv != null) {
        if (result.isExisting) {
          // Conversation existed
          _animateAndMoveToTop(result.oldIndex, result.updatedConv!);
        } else {
          // New conversation
          _animateAndInsertNew(result.updatedConv!);
        }
      }
    });
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

  // Remove badge unread count in UI (local)
  void markAsReadLocally(String conversationId) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && conversations[index].unreadCount > 0) {
      int currentTotal = ChatBubbleWidget.unreadCounter.value;
      ChatBubbleWidget.unreadCounter.value = currentTotal - conversations[index].unreadCount;
      
      conversations[index] = conversations[index].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }
}
