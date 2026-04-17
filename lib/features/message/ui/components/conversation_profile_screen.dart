// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/call/ui/call_screen.dart';
import 'package:pingme_manager/features/conversation/ui/conversation_controller.dart';
import 'conversation_profile_controller.dart';

class ConversationProfileScreen extends StatefulWidget {
  final String conversationId;
  final String partnerId;
  final String partnerName;
  final String? partnerAvatarUrl;

  const ConversationProfileScreen({
    Key? key,
    required this.conversationId,
    required this.partnerId,
    required this.partnerName,
    this.partnerAvatarUrl,
  }) : super(key: key);

  @override
  State<ConversationProfileScreen> createState() =>
      _ConversationProfileScreenState();
}

class _ConversationProfileScreenState extends State<ConversationProfileScreen> {
  final ConversationProfileController _controller =
      ConversationProfileController();
  final Color amberGold = const Color(0xFFF5A623);

  @override
  void initState() {
    super.initState();
    _controller.loadMedia(widget.conversationId);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: amberGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tùy chọn',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHeaderInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade200, thickness: 8),
            _buildMediaSection(),
            Divider(color: Colors.grey.shade200, thickness: 8),
            _buildOptionsSection(),
          ],
        ),
      ),
    );
  }

  // Header: name and avatar
  Widget _buildHeaderInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          backgroundImage:
              widget.partnerAvatarUrl != null &&
                  widget.partnerAvatarUrl!.isNotEmpty
              ? NetworkImage(widget.partnerAvatarUrl!)
              : null,
          child:
              widget.partnerAvatarUrl == null ||
                  widget.partnerAvatarUrl!.isEmpty
              ? Text(
                  widget.partnerName.isNotEmpty
                      ? widget.partnerName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          widget.partnerName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Action button
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircularButton(
          icon: Icons.call_outlined,
          label: 'Gọi thoại',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallScreen(
                  targetUserId: widget.partnerId,
                  isVideoCall: false,
                  isIncoming: false,
                  fullname: widget.partnerName,
                  avatarUrl: widget.partnerAvatarUrl ?? '',
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 32),
        _buildCircularButton(
          icon: Icons.videocam_outlined,
          label: 'Gọi video',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallScreen(
                  targetUserId: widget.partnerId,
                  isVideoCall: true,
                  isIncoming: false,
                  fullname: widget.partnerName,
                  avatarUrl: widget.partnerAvatarUrl ?? '',
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 32),
        _buildCircularButton(
          icon: Icons.person_outline,
          label: 'Hồ sơ',
          onTap: () {
            Navigator.pushNamed(
              context,
              '/user-profile',
              arguments: widget.partnerId,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Icon(icon, size: 28, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // List medias
  Widget _buildMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Phương tiện, file và liên kết',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    // TODO
                  },
                  child: Text(
                    'Tất cả',
                    style: TextStyle(
                      color: amberGold,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                if (_controller.isLoadingMedia) {
                  return Center(
                    child: CircularProgressIndicator(color: amberGold),
                  );
                }

                if (_controller.mediaMessages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có phương tiện nào được chia sẻ.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _controller.mediaMessages.length,
                  itemBuilder: (context, index) {
                    final mediaUrl =
                        _controller.mediaMessages[index].media?.secureUrl ?? '';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: mediaUrl.isNotEmpty
                            ? Image.network(
                                mediaUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                              )
                            : const Icon(Icons.image, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBlockConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn chặn ${widget.partnerName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _controller.blockUser(widget.conversationId);
                  ConversationController.activeInstance?.loadData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã chặn người dùng')),
                    );
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lỗi khi chặn người dùng')),
                    );
                  }
                }
              },
              child: const Text('Chặn', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showClearHistoryConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Xóa toàn bộ lịch sử trò chuyện phía bạn?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Đang xóa...')));
                try {
                  await _controller.clearHistory(widget.conversationId);
                  ConversationController.activeInstance?.loadData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã xóa lịch sử trò chuyện'),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lỗi khi xóa lịch sử')),
                    );
                  }
                }
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Custom action
  Widget _buildOptionsSection() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.search,
          title: 'Tìm kiếm trong cuộc trò chuyện',
          onTap: () {
            // TODO
          },
        ),
        _buildOptionTile(
          icon: Icons.notifications_off_outlined,
          title: 'Tắt thông báo',
          onTap: () {
            // TODO
          },
        ),
        Divider(color: Colors.grey.shade200, height: 1),
        _buildOptionTile(
          icon: Icons.block,
          title: 'Chặn người dùng',
          isDanger: true,
          onTap: () => _showBlockConfirmationDialog(context),
        ),
        Divider(color: Colors.grey.shade200, height: 1),
        _buildOptionTile(
          icon: Icons.delete_outline,
          title: 'Xóa lịch sử trò chuyện',
          isDanger: true,
          onTap: () => _showClearHistoryConfirmationDialog(context),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    final color = isDanger ? Colors.red : Colors.black87;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: isDanger
          ? null
          : const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
