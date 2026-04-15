import '../../../shared/websocket/websocket_gateway.dart';

class ConversationSocket {
  final WebsocketGateway _wsGateway = WebsocketGateway();

  void removeWebsocketListeners() {
    _wsGateway.socket?.off('new_message');
  }
}