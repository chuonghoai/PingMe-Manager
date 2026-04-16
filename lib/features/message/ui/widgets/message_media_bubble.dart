import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import 'video_bubble.dart';
import 'audio_bubble.dart';

class MessageMediaBubble extends StatelessWidget {
  final MessageItem message;
  final bool isMe;

  const MessageMediaBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final mediaUrl = message.media?.secureUrl ?? '';

    if (mediaUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    if (message.type == 'IMAGE') {
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: 250,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            mediaUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder(
                200,
                200,
                const CircularProgressIndicator(color: Color(0xFFF5A623)),
              );
            },
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(
              200,
              200,
              const Icon(Icons.broken_image, color: Colors.grey, size: 40),
            ),
          ),
        ),
      );
    } else if (message.type == 'VIDEO') {
      return VideoBubble(videoUrl: mediaUrl);
    } else if (message.type == 'AUDIO') {
      return AudioBubble(audioUrl: mediaUrl, isMe: isMe);
    }

    return const SizedBox.shrink();
  }

  Widget _buildPlaceholder(double width, double height, Widget child) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(child: child),
    );
  }
}
