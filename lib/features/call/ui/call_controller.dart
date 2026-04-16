import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../service/call_socket.dart';

class CallController extends ChangeNotifier {
  final CallSocket _socket = CallSocket();

  final String targetUserId;
  final bool isVideoCall;
  final bool isIncoming;
  final String fullname;
  final String avatarUrl;

  String status; // 'connecting', 'ringing', 'accepted', 'rejected', 'ended'
  int callDuration = 0;
  Timer? _durationTimer;

  bool isMicOn = true;
  bool isCamOn = true;
  bool isFrontCam = true;
  bool isSpeakerOn;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  bool _hasEmittedCall = false;
  List<RTCIceCandidate> _pendingCandidates = [];

  CallController({
    required this.targetUserId,
    required this.isVideoCall,
    required this.isIncoming,
    required this.fullname,
    required this.avatarUrl,
  })  : status = isIncoming ? 'ringing' : 'connecting',
        isSpeakerOn = isVideoCall {
    _initWebrtc();
    _initSocketListeners();
  }

  Future<void> _initWebrtc() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    try {
      final Map<String, dynamic> mediaConstraints = {
        'audio': {
          'echoCancellation': true,
          'googNoiseSuppression': true,
          'googAutoGainControl': true,
        },
        'video': isVideoCall
            ? {'facingMode': isFrontCam ? 'user' : 'environment'}
            : false,
      };

      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      localRenderer.srcObject = _localStream;

      final configuration = {
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
          {'urls': 'stun:stun1.l.google.com:19302'},
        ],
      };

      _peerConnection = await createPeerConnection(configuration);

      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      _peerConnection?.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          remoteRenderer.srcObject = event.streams[0];
          notifyListeners();
        }
      };

      _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        _socket.emitWebrtcIceCandidate(
            targetUserId: targetUserId, candidate: candidate.toMap());
      };

      Helper.setSpeakerphoneOn(isSpeakerOn);

      if (!isIncoming && status == 'connecting' && !_hasEmittedCall) {
        _hasEmittedCall = true;
        _socket.emitCallUser(targetUserId: targetUserId, isVideoCall: isVideoCall);
        status = 'ringing';
        notifyListeners();
      }
    } catch (e) {
      print('Lỗi thiết lập thiết bị Webrtc: $e');
    }
  }

  void _initSocketListeners() {
    _socket.listenToCallEvents(
      onCallResponseReceived: (data) async {
        if (data['accepted'] == true) {
          status = 'accepted';
          _startTimer();
          notifyListeners();

          try {
            if (_peerConnection != null) {
              final offer = await _peerConnection!.createOffer({});
              await _peerConnection!.setLocalDescription(offer);
              _socket.emitWebrtcOffer(
                  targetUserId: targetUserId, sdp: offer.toMap());
            }
          } catch (e) {
            print('Lỗi tạo Offer: $e');
          }
        } else {
          status = 'rejected';
          notifyListeners();
        }
      },
      onWebrtcOfferReceived: (data) async {
        if (data['senderId'] != targetUserId) return;
        try {
          if (_peerConnection != null) {
            final Map<String, dynamic> sdpMap =
                Map<String, dynamic>.from(data['sdp']);
            final sdp =
                RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
            await _peerConnection!.setRemoteDescription(sdp);

            final answer = await _peerConnection!.createAnswer({});
            await _peerConnection!.setLocalDescription(answer);
            _socket.emitWebrtcAnswer(
                targetUserId: targetUserId, sdp: answer.toMap());

            for (var candidate in _pendingCandidates) {
              await _peerConnection!.addCandidate(candidate);
            }
            _pendingCandidates.clear();
          }
        } catch (e) {
          print('Lỗi xử lý Offer: $e');
        }
      },
      onWebrtcAnswerReceived: (data) async {
        if (data['senderId'] != targetUserId) return;
        try {
          if (_peerConnection != null) {
            final Map<String, dynamic> sdpMap =
                Map<String, dynamic>.from(data['sdp']);
            final sdp =
                RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
            await _peerConnection!.setRemoteDescription(sdp);

            for (var candidate in _pendingCandidates) {
              await _peerConnection!.addCandidate(candidate);
            }
            _pendingCandidates.clear();
          }
        } catch (e) {
          print('Lỗi xử lý Answer: $e');
        }
      },
      onWebrtcIceCandidateReceived: (data) async {
        if (data['senderId'] != targetUserId) return;
        try {
          if (_peerConnection != null) {
            final Map<String, dynamic> candidateMap =
                Map<String, dynamic>.from(data['candidate']);
            final candidate = RTCIceCandidate(
              candidateMap['candidate'],
              candidateMap['sdpMid'],
              candidateMap['sdpMLineIndex'],
            );
            
            final rState = await _peerConnection!.getRemoteDescription();
            if (rState != null) {
              await _peerConnection!.addCandidate(candidate);
            } else {
              _pendingCandidates.add(candidate);
            }
          }
        } catch (e) {
          print('Lỗi nhận ice candidate: $e');
        }
      },
      onCallEnded: (data) {
        status = 'ended';
        _stopTimer();
        notifyListeners();
      },
      onCallError: (data) {
        status = 'ended';
        _stopTimer();
        notifyListeners();
      },
    );
  }

  void _startTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _durationTimer?.cancel();
  }

  String get formattedDuration {
    final minutes = (callDuration / 60).floor().toString().padLeft(2, '0');
    final seconds = (callDuration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // --- ACTIONS ---
  void toggleMic() {
    if (_localStream != null) {
      for (var track in _localStream!.getAudioTracks()) {
        track.enabled = !isMicOn;
      }
    }
    isMicOn = !isMicOn;
    notifyListeners();
  }

  void toggleCam() {
    if (_localStream != null) {
      for (var track in _localStream!.getVideoTracks()) {
        track.enabled = !isCamOn;
      }
    }
    isCamOn = !isCamOn;
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (_localStream != null) {
      for (var track in _localStream!.getVideoTracks()) {
        await Helper.switchCamera(track);
      }
    }
    isFrontCam = !isFrontCam;
    notifyListeners();
  }

  void toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
    Helper.setSpeakerphoneOn(isSpeakerOn);
    notifyListeners();
  }

  void acceptCall() {
    status = 'accepted';
    _startTimer();
    _socket.emitCallResponse(targetUserId: targetUserId, accepted: true);
    notifyListeners();
  }

  void rejectCall() {
    status = 'rejected';
    _socket.emitCallResponse(targetUserId: targetUserId, accepted: false);
    notifyListeners();
  }

  void endCall() {
    status = 'ended';
    _stopTimer();
    _socket.emitEndCall(targetUserId: targetUserId);
    notifyListeners();
  }

  @override
  void dispose() {
    _socket.removeListeners();
    _stopTimer();
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _peerConnection?.close();
    _peerConnection?.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }
}
