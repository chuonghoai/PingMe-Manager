// ignore_for_file: library_prefixes, avoid_print

import 'package:pingme_manager/features/home/ui/widget/chat_bubble_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../core/storage/local_storage.dart';
import '../../features/message/ui/message_controller.dart';

class WebsocketGateway {
  // Singleton pattern
  static final WebsocketGateway _instance = WebsocketGateway._internal();
  factory WebsocketGateway() => _instance;
  WebsocketGateway._internal();

  IO.Socket? socket;
  final String _socketUrl = 'http://10.0.2.2:3000';

  // Start connect websocket
  Future<void> connect() async {
    if (socket != null && socket!.connected) return;

    final token = await LocalStorage.getToken();
    if (token == null) return;

    socket = IO.io(
      _socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('🌐 [WebSocket] Đã kết nối thành công: ${socket!.id}');
    });
    socket!.onConnectError((err) {
      print('❌ [WebSocket] Lỗi kết nối: $err');
    });
    socket!.onDisconnect((_) {
      print('🔌 [WebSocket] Đã ngắt kết nối');
    });

    // Listen global events
    _registerGlobalListeners();
  }

  // Listen global events
  void _registerGlobalListeners() {
    if (socket == null) return;

    socket!.on('new_message', (data) {
      print('[WebSocket Global] Có tin nhắn mới: $data');
      final messageData = Map<String, dynamic>.from(data);
      final activeController = MessageController.activeInstance;

      if (activeController != null &&
          activeController.conversationId == messageData['conversationId']) {
        activeController.handleIncomingMessage(messageData);
      } else {
        ChatBubbleWidget.unreadCounter.value += 1;
        // TODO
      }
    });

    socket!.on('incoming_call', (data) {
      print('[WebSocket Global] Cuộc gọi đến: $data');
      // TODO
    });

    socket!.on('new_notification', (data) {
      print('[WebSocket Global] Thông báo mới: $data');
      // TODO
    });

    socket!.on('call_error', (data) {
      print('[WebSocket Global] Lỗi cuộc gọi: $data');
    });
  }

  // Disconnect websocket
  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
      print('🔌 [WebSocket] Đã dọn dẹp và đóng Socket an toàn');
    }
  }
}
