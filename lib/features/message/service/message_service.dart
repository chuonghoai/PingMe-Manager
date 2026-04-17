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

  // Get conversation media
  Future<MessageModel> getConversationMedia(
    String conversationId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (conversationId.isEmpty) {
        throw Exception('Mã cuộc trò chuyện không hợp lệ.');
      }

      final apiResponse = await _messageRepository.getConversationMedia(
        conversationId,
        page: page,
        limit: limit,
      );

      if (apiResponse.success == true) {
        return MessageModel.fromJson(apiResponse.data);
      } else {
        throw Exception(
          apiResponse.message ?? 'Đã xảy ra lỗi khi tải phương tiện.',
        );
      }
    } catch (e) {
      throw Exception('Không thể lấy phương tiện: ${e.toString()}');
    }
  }

  // Block user
  Future<bool> blockUser(String conversationId) async {
    try {
      if (conversationId.isEmpty) {
        throw Exception('Mã cuộc trò chuyện không hợp lệ.');
      }

      final apiResponse = await _messageRepository.blockUser(conversationId);

      if (apiResponse.success == true) {
        return true;
      } else {
        throw Exception(
          apiResponse.message ?? 'Đã xảy ra lỗi khi chặn người dùng.',
        );
      }
    } catch (e) {
      throw Exception('Không thể chặn người dùng: ${e.toString()}');
    }
  }

  // Clear history
  Future<bool> clearHistory(String conversationId) async {
    try {
      if (conversationId.isEmpty) {
        throw Exception('Mã cuộc trò chuyện không hợp lệ.');
      }

      final apiResponse = await _messageRepository.clearHistory(conversationId);

      if (apiResponse.success == true) {
        return true;
      } else {
        throw Exception(
          apiResponse.message ?? 'Đã xảy ra lỗi khi xóa lịch sử.',
        );
      }
    } catch (e) {
      throw Exception('Không thể xóa lịch sử: ${e.toString()}');
    }
  }
}
