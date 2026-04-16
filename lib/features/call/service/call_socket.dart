import '../../../shared/websocket/websocket_gateway.dart';

class CallSocket {
  final _wsGateway = WebsocketGateway();

  void emitCallUser({required String targetUserId, required bool isVideoCall}) {
    _wsGateway.socket?.emit('call_user', {
      'targetUserId': targetUserId,
      'isVideoCall': isVideoCall,
    });
  }

  void emitCallResponse({required String targetUserId, required bool accepted}) {
    _wsGateway.socket?.emit('call_response', {
      'targetUserId': targetUserId,
      'accepted': accepted,
    });
  }

  void emitWebrtcOffer({required String targetUserId, required Map<String, dynamic> sdp}) {
    _wsGateway.socket?.emit('webrtc_offer', {
      'targetUserId': targetUserId,
      'sdp': sdp,
    });
  }

  void emitWebrtcAnswer({required String targetUserId, required Map<String, dynamic> sdp}) {
    _wsGateway.socket?.emit('webrtc_answer', {
      'targetUserId': targetUserId,
      'sdp': sdp,
    });
  }

  void emitWebrtcIceCandidate({required String targetUserId, required Map<String, dynamic> candidate}) {
    _wsGateway.socket?.emit('webrtc_ice_candidate', {
      'targetUserId': targetUserId,
      'candidate': candidate,
    });
  }

  void emitEndCall({required String targetUserId}) {
    _wsGateway.socket?.emit('end_call', {
      'targetUserId': targetUserId,
    });
  }

  // Lắng nghe sự kiện
  void listenToCallEvents({
    required Function(Map<String, dynamic>) onCallResponseReceived,
    required Function(Map<String, dynamic>) onWebrtcOfferReceived,
    required Function(Map<String, dynamic>) onWebrtcAnswerReceived,
    required Function(Map<String, dynamic>) onWebrtcIceCandidateReceived,
    required Function(Map<String, dynamic>) onCallEnded,
    required Function(Map<String, dynamic>) onCallError,
  }) {
    final socket = _wsGateway.socket;
    if (socket == null) return;

    socket.on('call_response_received', (data) => onCallResponseReceived(Map<String, dynamic>.from(data)));
    socket.on('webrtc_offer_received', (data) => onWebrtcOfferReceived(Map<String, dynamic>.from(data)));
    socket.on('webrtc_answer_received', (data) => onWebrtcAnswerReceived(Map<String, dynamic>.from(data)));
    socket.on('webrtc_ice_candidate_received', (data) => onWebrtcIceCandidateReceived(Map<String, dynamic>.from(data)));
    socket.on('call_ended', (data) => onCallEnded(Map<String, dynamic>.from(data)));
    socket.on('call_error', (data) => onCallError(Map<String, dynamic>.from(data)));
  }

  void removeListeners() {
    final socket = _wsGateway.socket;
    if (socket == null) return;

    socket.off('call_response_received');
    socket.off('webrtc_offer_received');
    socket.off('webrtc_answer_received');
    socket.off('webrtc_ice_candidate_received');
    socket.off('call_ended');
    socket.off('call_error');
  }
}
