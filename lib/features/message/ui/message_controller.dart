import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../service/message_service.dart';

class MessageController extends ChangeNotifier {
  final MessageService _messageService;
  final String conversationId;

  bool isLoading = true;
  bool isSending = false;
  String? errorMessage;
  List<MessageItem> messages = [];
  
  int _currentPage = 1;
  bool hasMore = true;

  final TextEditingController textController = TextEditingController();

  MessageController({
    MessageService? service, 
    required this.conversationId,
  }) : _messageService = service ?? MessageService() {
    fetchMessages();
  }

  // Get API: messages history
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
    } catch (e) {
      errorMessage = e.toString();
      if (isLoadMore) _currentPage--;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Socket: Send message
  Future<void> sendMessage(String senderId) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    textController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}