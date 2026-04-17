import 'package:flutter/material.dart';
import '../../../../message/service/message_service.dart';
import '../../../../message/models/message_model.dart';

class ConversationMediasController extends ChangeNotifier {
  final MessageService _messageService = MessageService();

  List<MessageItem> mediaList = [];
  String? errorMessage;

  int _currentPage = 1;
  final int _limit = 31;

  bool isLoadingInitial = false;
  bool isFetchingMore = false;
  bool hasMore = true;

  Future<void> loadInitialMedia(String conversationId) async {
    isLoadingInitial = true;
    errorMessage = null;
    _currentPage = 1;
    hasMore = true;
    mediaList.clear();
    notifyListeners();

    try {
      final result = await _messageService.getConversationMedia(
        conversationId,
        page: _currentPage,
        limit: _limit,
      );

      mediaList = result.messages;

      if (result.messages.length < _limit) {
        hasMore = false;
      }
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoadingInitial = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMedia(String conversationId) async {
    if (isFetchingMore || !hasMore || isLoadingInitial) return;

    isFetchingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final result = await _messageService.getConversationMedia(
        conversationId,
        page: _currentPage,
        limit: _limit,
      );

      if (result.messages.isEmpty) {
        hasMore = false;
      } else {
        mediaList.addAll(result.messages);
        if (result.messages.length < _limit) {
          hasMore = false;
        }
      }
    } catch (e) {
      debugPrint("Lỗi khi tải thêm media: $e");
      _currentPage--;
    } finally {
      isFetchingMore = false;
      notifyListeners();
    }
  }
}
