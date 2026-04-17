import 'package:flutter/material.dart';
import '../../service/message_service.dart';
import '../../models/message_model.dart';

class ConversationProfileController extends ChangeNotifier {
  final MessageService _messageService = MessageService();

  bool isLoadingMedia = true;
  String? errorMessage;
  List<MessageItem> mediaMessages = [];

  Future<void> loadMedia(String conversationId) async {
    isLoadingMedia = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _messageService.getConversationMedia(
        conversationId,
        page: 1,
        limit: 10,
      );
      
      mediaMessages = result.messages;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoadingMedia = false;
      notifyListeners();
    }
  }

  Future<void> blockUser(String conversationId) async {
    try {
      await _messageService.blockUser(conversationId);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> clearHistory(String conversationId) async {
    try {
      await _messageService.clearHistory(conversationId);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}