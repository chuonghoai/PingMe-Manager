import '../../../shared/websocket/websocket_gateway.dart';

class ConversationSocket {
  final WebsocketGateway _wsGateway = WebsocketGateway();

  void listenToNewMessages(Function(Map<String, dynamic>) onNewMessageReceived) {
    if (_wsGateway.socket == null) return;
    
    _wsGateway.socket!.on('new_message', (data) {
      final messageData = Map<String, dynamic>.from(data);
      onNewMessageReceived(messageData);
    });
  }

  void removeWebsocketListeners() {
    _wsGateway.socket?.off('new_message');
  }
}