// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'conversation_controller.dart';
import '../../../shared/ui/widget/custom_avatar_widget.dart';
import '../../../core/storage/local_storage.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationController _controller = ConversationController();

  @override
  void initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper: Format time
  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0 && now.day == time.day) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1 ||
        (difference.inDays == 0 && now.day != time.day)) {
      return 'Hôm qua';
    } else {
      return DateFormat('dd/MM').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tin nhắn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading && _controller.conversations.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5A623)),
            );
          }

          if (_controller.errorMessage != null) {
            return Center(
              child: Text(
                _controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFF5A623),
            onRefresh: () async {
              await _controller.loadData();
            },
            child: _controller.conversations.isEmpty
                ? const Center(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Text(
                        'Chưa có tin nhắn nào',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : AnimatedList(
                    key: _controller.listKey,
                    physics: const AlwaysScrollableScrollPhysics(),
                    initialItemCount: _controller.conversations.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index, animation) {
                      final conv = _controller.conversations[index];

                      return SizeTransition(
                        sizeFactor: animation,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: CustomAvatarWidget(
                            avatarUrl: conv.displayAvatarUrl,
                            fullname: conv.displayFullName,
                            radius: 26,
                          ),
                          title: Text(
                            conv.displayFullName ?? 'Người dùng',
                            style: TextStyle(
                              fontWeight: conv.myUnreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            conv.lastMessageSnippet ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: conv.myUnreadCount > 0
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                              fontWeight: conv.myUnreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTime(conv.lastMessageAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: conv.myUnreadCount > 0
                                      ? const Color(0xFFF5A623)
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Unread count badge
                              if (conv.myUnreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF5A623),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    conv.myUnreadCount > 99
                                        ? '99+'
                                        : conv.myUnreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () async {
                            _controller.markAsReadLocally(conv.id);

                            final currentUser = await LocalStorage.getUser();
                            final currentUserId = currentUser?['id'] ?? '';

                            String partnerId = '';
                            if (conv.type == 'ONE_TO_ONE') {
                              try {
                                final opponent = conv.participants.firstWhere(
                                  (p) => p.userId != currentUserId,
                                );
                                partnerId = opponent.userId;
                              } catch (_) {}
                            }

                            if (!context.mounted) return;

                            Navigator.pushNamed(
                              context,
                              '/message',
                              arguments: {
                                'conversationId': conv.id,
                                'partnerName':
                                    conv.displayFullName ?? 'Người dùng',
                                'partnerAvatarUrl': conv.displayAvatarUrl,
                                'currentUserId': currentUserId,
                                'partnerId': partnerId,
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
