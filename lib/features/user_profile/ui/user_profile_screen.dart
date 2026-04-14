// ignore_for_file: use_super_parameters, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/user_profile/ui/widget/action_icon_widget.dart';
import 'user_profile_controller.dart';
import 'package:intl/intl.dart';
import 'widget/info_row_widget.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController _controller = UserProfileController();

  @override
  void initState() {
    super.initState();
    _controller.loadProfile(widget.userId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Header app bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Hồ sơ người dùng',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
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

          final user = _controller.userProfile;
          if (user == null)
            return const Center(child: Text('Không có dữ liệu'));

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Avatar - name
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    user.avatarUrl ??
                        'https://ui-avatars.com/api/?name=${user.fullname ?? 'U'}',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullname ?? 'Người dùng ẩn danh',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Status Online/Offline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: user.isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.isOnline ? 'Đang hoạt động' : 'Ngoại tuyến',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                // status message
                if (user.statusMessage != null &&
                    user.statusMessage!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '"${user.statusMessage!}"',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionIconWidget(
                      icon: Icons.phone,
                      color: Colors.green,
                      onTap: () {
                        // TODO: Gọi thoại
                      },
                    ),
                    const SizedBox(width: 24),
                    ActionIconWidget(
                      icon: Icons.videocam,
                      color: Colors.blue,
                      onTap: () {
                        // TODO: Gọi Video
                      },
                    ),
                    const SizedBox(width: 24),
                    ActionIconWidget(
                      icon: Icons.message,
                      color: Color(0xFFF5A623),
                      onTap: () {
                        // TODO: Nhắn tin
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Card info detail
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InfoRowWidget(
                        icon: Icons.star_rounded,
                        title: 'Cấp độ',
                        value: 'Level ${user.level} (${user.currentExp} EXP)',
                      ),
                      const Divider(height: 30),
                      InfoRowWidget(
                        icon: Icons.cake_outlined,
                        title: 'Ngày sinh',
                        value: user.dob != null
                            ? DateFormat('dd/MM/yyyy').format(user.dob!)
                            : 'Chưa cập nhật',
                      ),
                      const Divider(height: 30),
                      InfoRowWidget(
                        icon: user.gender == 'MALE'
                            ? Icons.male
                            : (user.gender == 'FEMALE'
                                  ? Icons.female
                                  : Icons.person_outline),
                        title: 'Giới tính',
                        value: user.gender == 'MALE'
                            ? 'Nam'
                            : (user.gender == 'FEMALE'
                                  ? 'Nữ'
                                  : 'Chưa cập nhật'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
