import 'package:pingme_manager/features/conversation/ui/conversation_controller.dart';

import '../../../shared/websocket/websocket_gateway.dart';

class ConversationSocket {
  final WebsocketGateway _wsGateway = WebsocketGateway();

  void removeWebsocketListeners() {
    _wsGateway.socket?.off('new_message');
    _wsGateway.socket?.off('user_online');
    _wsGateway.socket?.off('user_offline');
  }

  void initSocketListeners(ConversationController controller) {
    _wsGateway.socket?.on('user_online', (data) {
      final userId = data['userId'];
      if (userId != null) controller.updateUserOnlineStatus(userId, true);
    });

    _wsGateway.socket?.on('user_offline', (data) {
      final userId = data['userId'];
      if (userId != null) controller.updateUserOnlineStatus(userId, false);
    });
  }
}