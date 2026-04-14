import 'package:dio/dio.dart';
import '../repository/conversation_repository.dart';
import '../models/conversation_model.dart';
import 'dto/message_result.dart';

class ConversationService {
  final ConversationRepository _repository = ConversationRepository();

  // Get list conversations
  Future<Map<String, dynamic>> fetchConversations() async {
    try {
      final res = await _repository.getConversations();
      if (res.success && res.data != null) {
        final List<dynamic> list = res.data;
        final conversations = list.map((e) => ConversationModel.fromJson(e)).toList();
        return {'success': true, 'data': conversations, 'error': null};
      }
      return {'success': false, 'error': res.message ?? 'Lỗi tải dữ liệu'};
    } on DioException catch (e) {
      return {'success': false, 'error': e.response?.data['error']['message'] ?? 'Lỗi mạng.'};
    } catch (e) {
      return {'success': false, 'error': 'Lỗi hệ thống: $e'};
    }
  }

  // Helper: format message snippet
  String _formatMessageSnippet(Map<String, dynamic> messageInfo) {
    String snippet = messageInfo['content'] ?? '';
    if (messageInfo['type'] == 'IMAGE') snippet = '[Hình ảnh]';
    if (messageInfo['type'] == 'VIDEO') snippet = '[Video]';
    return snippet;
  }

  // Process incoming message
  ProcessedMessageResult processIncomingMessage(List<ConversationModel> currentList, Map<String, dynamic> socketData) {
    final String conversationId = socketData['conversationId'];
    final Map<String, dynamic> messageInfo = socketData['message'];

    final int index = currentList.indexWhere((c) => c.id == conversationId);

    if (index != -1) {
      final existingConv = currentList[index];
      final updatedConv = existingConv.copyWith(
        lastMessageSnippet: _formatMessageSnippet(messageInfo),
        lastMessageAt: DateTime.now(),
        unreadCount: existingConv.unreadCount + 1,
      );

      return ProcessedMessageResult(
        isExisting: true,
        oldIndex: index,
        updatedConv: updatedConv,
      );
    } else {
      final Map<String, dynamic>? convData = socketData['conversation'];
      ConversationModel newConv;

      if (convData != null) {
        newConv = ConversationModel.fromJson(convData).copyWith(
          lastMessageSnippet: _formatMessageSnippet(messageInfo),
          lastMessageAt: DateTime.now(),
          unreadCount: 1,
        );
      } else {
        // Fallback
        newConv = ConversationModel(
          id: conversationId,
          fullname: 'Cuộc trò chuyện mới',
          lastMessageSnippet: _formatMessageSnippet(messageInfo),
          lastMessageAt: DateTime.now(),
          unreadCount: 1,
        );
      }
      
      return ProcessedMessageResult(
        isExisting: false, 
        updatedConv: newConv,
      );
    }
  }
}