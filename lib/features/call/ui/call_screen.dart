// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'call_controller.dart';

class CallScreen extends StatefulWidget {
  final String targetUserId;
  final bool isVideoCall;
  final bool isIncoming;
  final String fullname;
  final String avatarUrl;

  const CallScreen({
    super.key,
    required this.targetUserId,
    required this.isVideoCall,
    required this.isIncoming,
    required this.fullname,
    required this.avatarUrl,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late CallController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CallController(
      targetUserId: widget.targetUserId,
      isVideoCall: widget.isVideoCall,
      isIncoming: widget.isIncoming,
      fullname: widget.fullname,
      avatarUrl: widget.avatarUrl,
    );

    _controller.addListener(() {
      setState(() {});
      if (_controller.status == 'rejected' || _controller.status == 'ended') {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.status == 'connecting' || _controller.status == 'ringing') {
      return _buildRingingScreen();
    }

    if (_controller.status == 'accepted') {
      return _buildInCallScreen();
    }

    return _buildEndedScreen();
  }

  Widget _buildRingingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(widget.avatarUrl),
                onBackgroundImageError: (_, __) {},
                child: widget.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.fullname,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.isIncoming
                  ? (widget.isVideoCall
                        ? 'Cuộc gọi video đến...'
                        : 'Cuộc gọi thoại đến...')
                  : 'Đang kết nối...',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPressed: () => _controller.rejectCall(),
                ),
                if (widget.isIncoming)
                  _buildActionButton(
                    icon: widget.isVideoCall ? Icons.videocam : Icons.call,
                    color: Colors.green,
                    onPressed: () => _controller.acceptCall(),
                  ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInCallScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (widget.isVideoCall) ...[
              // Remote video (full screen)
              Positioned.fill(
                child: RTCVideoView(
                  _controller.remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              // Local video (pip)
              Positioned(
                top: 20,
                right: 20,
                width: 100,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey[900],
                    child: RTCVideoView(
                      _controller.localRenderer,
                      mirror: _controller.isFrontCam,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Audio only placeholder
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(widget.avatarUrl),
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.fullname,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _controller.formattedDuration,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],

            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: _controller.isMicOn ? Icons.mic : Icons.mic_off,
                    color: _controller.isMicOn ? Colors.white24 : Colors.white,
                    iconColor: _controller.isMicOn
                        ? Colors.white
                        : Colors.black,
                    onPressed: _controller.toggleMic,
                  ),
                  if (widget.isVideoCall) ...[
                    _buildActionButton(
                      icon: _controller.isCamOn
                          ? Icons.videocam
                          : Icons.videocam_off,
                      color: _controller.isCamOn
                          ? Colors.white24
                          : Colors.white,
                      iconColor: _controller.isCamOn
                          ? Colors.white
                          : Colors.black,
                      onPressed: _controller.toggleCam,
                    ),
                    _buildActionButton(
                      icon: Icons.flip_camera_ios,
                      color: Colors.white24,
                      iconColor: Colors.white,
                      onPressed: _controller.switchCamera,
                    ),
                  ],
                  _buildActionButton(
                    icon: _controller.isSpeakerOn
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: _controller.isSpeakerOn
                        ? Colors.white
                        : Colors.white24,
                    iconColor: _controller.isSpeakerOn
                        ? Colors.black
                        : Colors.white,
                    onPressed: _controller.toggleSpeaker,
                  ),
                  _buildActionButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onPressed: _controller.endCall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndedScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call_end, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(
              _controller.status == 'rejected'
                  ? 'Cuộc gọi bị từ chối'
                  : 'Cuộc gọi kết thúc',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Thời lượng: ${_controller.formattedDuration}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    Color iconColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}
