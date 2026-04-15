// ignore_for_file: use_null_aware_elements

import '../../../shared/websocket/websocket_gateway.dart';
import '../../conversation/ui/conversation_controller.dart';

class MessageSocket {
  final WebsocketGateway _wsGateway = WebsocketGateway();

  /// Emit: Send message
  void sendMessage({
    required String conversationId,
    required String content,
    required String type,
    String? temporaryId,
    String? mediaId,
    String? replyToId,
  }) {
    _wsGateway.socket?.emit('send_message', {
      'conversationId': conversationId,
      'content': content,
      'type': type,
      if (temporaryId != null) 'temporaryId': temporaryId,
      if (mediaId != null) 'mediaId': mediaId,
      if (replyToId != null) 'replyToId': replyToId,
    });
  }

  /// Emit: send typing
  void sendTyping(String conversationId, bool isTyping) {
    _wsGateway.socket?.emit('typing', {
      'conversationId': conversationId,
      'isTyping': isTyping,
    });
  }

  /// Emit: mark as read
  void markAsRead(String conversationId) {
    _wsGateway.socket?.emit('mark_read', {'conversationId': conversationId});
    ConversationController.activeInstance?.markAsReadLocally(conversationId);
  }

  /// Listen:
  void listenToMessageEvents({
    required Function(Map<String, dynamic>) onTyping,
    required Function(Map<String, dynamic>) onMessageSentSuccess,
    required Function(Map<String, dynamic>) onMessageError,
    required Function(Map<String, dynamic>) onUserOnline,
    required Function(Map<String, dynamic>) onUserOffline,
    required Function(Map<String, dynamic>) onMessagesRead,
  }) {
    final socket = _wsGateway.socket;
    if (socket == null) return;

    socket.on('is_typing', (data) => onTyping(Map<String, dynamic>.from(data)));

    socket.on(
      'message_sent_success',
      (data) => onMessageSentSuccess(Map<String, dynamic>.from(data)),
    );

    socket.on(
      'message_error',
      (data) => onMessageError(Map<String, dynamic>.from(data)),
    );

    socket.on(
      'user_online',
      (data) => onUserOnline(Map<String, dynamic>.from(data)),
    );

    socket.on(
      'user_offline',
      (data) => onUserOffline(Map<String, dynamic>.from(data)),
    );

    socket.on(
      'messages_read',
      (data) => onMessagesRead(Map<String, dynamic>.from(data)),
    );
  }

  /// Clear listeners
  void removeListeners() {
    final socket = _wsGateway.socket;
    if (socket == null) return;

    socket.off('is_typing');
    socket.off('message_sent_success');
    socket.off('message_error');
    socket.off('user_online');
    socket.off('user_offline');
    socket.off('messages_read');
  }
}
