import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'message_controller.dart';
import '../models/message_model.dart';
import 'widgets/message_media_bubble.dart';

class MessageScreen extends StatefulWidget {
  final String conversationId;
  final String partnerName;
  final String? partnerAvatarUrl;
  final String currentUserId;
  final String partnerId;

  const MessageScreen({
    super.key,
    required this.conversationId,
    required this.partnerName,
    this.partnerAvatarUrl,
    required this.currentUserId,
    required this.partnerId,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late MessageController _controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = MessageController(
      conversationId: widget.conversationId,
      currentUserId: widget.currentUserId,
      partnerId: widget.partnerId,
    );

    _controller.textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFF5A623)),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Color(0xFFF5A623)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam, color: Color(0xFFF5A623)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Color(0xFFF5A623)),
          onPressed: () {},
        ),
      ],
      title: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        widget.partnerAvatarUrl != null &&
                            widget.partnerAvatarUrl!.isNotEmpty
                        ? NetworkImage(widget.partnerAvatarUrl!)
                        : null,
                    onBackgroundImageError: (e, s) {},
                    child:
                        widget.partnerAvatarUrl == null ||
                            widget.partnerAvatarUrl!.isEmpty
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  if (_controller.isPartnerOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.partnerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _controller.isPartnerOnline
                          ? 'Đang hoạt động'
                          : 'Ngoại tuyến',
                      style: TextStyle(
                        fontSize: 12,
                        color: _controller.isPartnerOnline
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Message List
  Widget _buildMessageList() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading && _controller.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF5A623)),
          );
        }

        final lastMyMessageIndex = _controller.messages.indexWhere(
          (m) => m.senderId == widget.currentUserId,
        );

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _controller.messages.length,
                itemBuilder: (context, index) {
                  final message = _controller.messages[index];
                  final isMe = message.senderId == widget.currentUserId;
                  final isLastMyMessage = isMe && index == lastMyMessageIndex;
                  return _buildMessageBubble(message, isMe, isLastMyMessage);
                },
              ),
            ),
            if (_controller.isPartnerTyping)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '${widget.partnerName} đang nhập...',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  /// Message item
  Widget _buildMessageBubble(
    MessageItem message,
    bool isMe,
    bool isLastMyMessage,
  ) {
    Widget bubbleContent;

    if (message.type == 'TEXT') {
      bubbleContent = Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFF5A623) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.content ?? '',
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      );
    } else {
      bubbleContent = MessageMediaBubble(message: message, isMe: isMe);
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          bubbleContent,

          if (isMe && isLastMyMessage)
            Text(
              message.isRead ? 'Đã xem' : 'Đã gửi',
              style: TextStyle(
                fontSize: 11,
                color: message.isRead ? const Color(0xFFF5A623) : Colors.grey,
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Input Bar
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFF5A623),
            ),
            onPressed: () {
              _showMediaPickerBottomSheet();
            },
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller.textController,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          _controller.textController.text.trim().isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFF5A623)),
                  onPressed: () =>
                      _controller.sendMessage(widget.currentUserId),
                )
              : IconButton(
                  icon: const Icon(Icons.mic, color: Color(0xFFF5A623)),
                  onPressed: () {
                    // TODO:
                  },
                ),
        ],
      ),
    );
  }

  /// Show bottom sheet select media from gallery
  void _showMediaPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFFF5A623),
                ),
                title: const Text('Chọn ảnh/video từ thư viện'),
                onTap: () async {
                  Navigator.pop(context);

                  final List<XFile> medias = await _picker.pickMultipleMedia();

                  if (medias.isNotEmpty) {
                    List<String> imagePaths = [];
                    List<String> videoPaths = [];

                    for (var media in medias) {
                      final path = media.path.toLowerCase();
                      if (path.endsWith('.mp4') ||
                          path.endsWith('.mov') ||
                          path.endsWith('.avi') ||
                          path.endsWith('.mkv')) {
                        videoPaths.add(media.path);
                      } else {
                        imagePaths.add(media.path);
                      }
                    }

                    if (imagePaths.isNotEmpty) {
                      _controller.enqueueMediaFiles(imagePaths, 'IMAGE');
                    }
                    if (videoPaths.isNotEmpty) {
                      _controller.enqueueMediaFiles(videoPaths, 'VIDEO');
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFF5A623)),
                title: const Text('Chụp ảnh mới'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    _controller.enqueueMediaFiles([photo.path], 'IMAGE');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
