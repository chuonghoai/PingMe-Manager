import '../models/message_model.dart';
import '../repository/message_repository.dart';

class MessageService {
  final MessageRepository _messageRepository;

  MessageService({MessageRepository? repository})
    : _messageRepository = repository ?? MessageRepository();

  // Get list messages history
  Future<MessageModel> fetchMessages(
    String conversationId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (conversationId.isEmpty) {
        throw Exception('Mã cuộc trò chuyện không hợp lệ.');
      }

      final apiResponse = await _messageRepository.getMessages(
        conversationId,
        page: page,
        limit: limit,
      );

      if (apiResponse.success == true) {
        return MessageModel.fromJson(apiResponse.data);
      } else {
        throw Exception(
          apiResponse.message ?? 'Đã xảy ra lỗi khi tải tin nhắn.',
        );
      }
    } catch (e) {
      throw Exception('Không thể lấy lịch sử tin nhắn: ${e.toString()}');
    }
  }

  // Mark conversation as read
}
