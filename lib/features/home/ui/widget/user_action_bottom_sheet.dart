// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pingme_manager/core/storage/local_storage.dart';
import 'package:pingme_manager/features/message/ui/message_screen.dart';
import 'package:pingme_manager/features/user_profile/ui/user_profile_controller.dart';

class UserActionBottomSheet extends StatelessWidget {
  final String userId;
  final String fullname;
  final String avatarUrl;
  final UserProfileController userProfileController;

  const UserActionBottomSheet({
    Key? key,
    required this.userId,
    required this.fullname,
    required this.avatarUrl,
    required this.userProfileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Detail
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Colors.blue),
              ),
              title: const Text(
                'Xem thông tin',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/user-profile',
                  arguments: userId,
                );
              },
            ),

            // Message
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.message_outlined, color: Colors.green),
              ),
              title: const Text(
                'Nhắn tin',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5A623),
                      ),
                    ),
                  );

                  final conversationId = await userProfileController
                      .startConversation(userId);

                  if (context.mounted) Navigator.pop(context);

                  if (conversationId != null && context.mounted) {
                    final currentUser = await LocalStorage.getUser();
                    final currentUserId = currentUser?['id'] ?? '';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          conversationId: conversationId,
                          partnerName: fullname,
                          partnerAvatarUrl: avatarUrl,
                          currentUserId: currentUserId,
                          partnerId: userId,
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) Navigator.pop(context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString().replaceAll('Exception: ', ''),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),

            const Divider(height: 24, thickness: 1),

            // Lock user
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline, color: Colors.red),
              ),
              title: const Text(
                'Khóa người dùng',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}
