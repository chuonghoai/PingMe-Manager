import 'package:dio/dio.dart';
import '../../../core/storage/local_storage.dart';
import '../repository/conversation_repository.dart';
import '../models/conversation_model.dart';
import 'dto/message_result.dart';

class ConversationService {
  final ConversationRepository _repository = ConversationRepository();
  String? _currentUserId;

  Future<Map<String, dynamic>> fetchConversations() async {
    try {
      final currentUser = await LocalStorage.getUser();
      _currentUserId = currentUser?['id'];

      final res = await _repository.getConversations();
      if (res.success && res.data != null) {
        final List<dynamic> list = res.data;

        final conversations = list.map((e) {
          final conv = ConversationModel.fromJson(e);
          return _enrichConversation(conv, _currentUserId);
        }).toList();

        int totalUnread = 0;
        for (var conv in conversations) {
          totalUnread += conv.myUnreadCount;
        }

        return {
          'success': true,
          'data': conversations,
          'error': null,
          'totalUnreadCount': totalUnread,
        };
      }
      return {'success': false, 'error': res.message ?? 'Lỗi tải dữ liệu'};
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error']['message'] ?? 'Lỗi mạng.',
      };
    } catch (e) {
      return {'success': false, 'error': 'Lỗi hệ thống: $e'};
    }
  }

  ConversationModel _enrichConversation(
    ConversationModel conv,
    String? currentUserId,
  ) {
    int unreadCount = conv.unreadCount;
    String? displayName = conv.name;
    String? displayAvatar = conv.avatarUrl;

    if (currentUserId != null) {
      if (conv.type == 'ONE_TO_ONE') {
        try {
          final opponent = conv.participants.firstWhere(
            (p) => p.userId != currentUserId,
          );
          displayName = opponent.fullname;
          displayAvatar = opponent.avatarUrl;
        } catch (e) {}
      }
    }

    displayName ??= 'Cuộc trò chuyện';

    return conv.copyWith(
      myUnreadCount: unreadCount,
      displayFullName: displayName,
      displayAvatarUrl: displayAvatar,
    );
  }

  String _formatMessageSnippet(Map<String, dynamic> messageInfo) {
    String snippet = messageInfo['content'] ?? '';
    if (messageInfo['type'] == 'IMAGE') snippet = '[Hình ảnh]';
    if (messageInfo['type'] == 'VIDEO') snippet = '[Video]';
    return snippet;
  }

  ProcessedMessageResult processIncomingMessage(
    List<ConversationModel> currentList,
    Map<String, dynamic> socketData,
  ) {
    final String conversationId = socketData['conversationId'];
    final Map<String, dynamic> messageInfo = socketData['message'];

    final int index = currentList.indexWhere((c) => c.id == conversationId);

    int currentTotalUnread = 0;
    for (var conv in currentList) {
      currentTotalUnread += conv.myUnreadCount;
    }
    final int newTotalUnread = currentTotalUnread + 1;

    if (index != -1) {
      final existingConv = currentList[index];
      final updatedConv = existingConv.copyWith(
        lastMessageSnippet: _formatMessageSnippet(messageInfo),
        lastMessageAt: DateTime.now(),
        myUnreadCount: existingConv.myUnreadCount + 1,
      );

      return ProcessedMessageResult(
        isExisting: true,
        oldIndex: index,
        updatedConv: updatedConv,
        totalUnreadCount: newTotalUnread,
      );
    } else {
      final Map<String, dynamic>? convData = socketData['conversation'];
      ConversationModel newConv;

      if (convData != null) {
        final parsedConv = ConversationModel.fromJson(convData);
        newConv = _enrichConversation(parsedConv, _currentUserId).copyWith(
          lastMessageSnippet: _formatMessageSnippet(messageInfo),
          lastMessageAt: DateTime.now(),
          myUnreadCount: 1,
        );
      } else {
        newConv = ConversationModel(
          id: conversationId,
          type: 'ONE_TO_ONE',
          participants: [],
          displayFullName: 'Cuộc trò chuyện mới',
          lastMessageSnippet: _formatMessageSnippet(messageInfo),
          lastMessageAt: DateTime.now(),
          myUnreadCount: 1,
        );
      }

      return ProcessedMessageResult(
        isExisting: false,
        updatedConv: newConv,
        totalUnreadCount: newTotalUnread,
      );
    }
  }
}
