// ignore_for_file: use_super_parameters, deprecated_member_use, curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pingme_manager/core/storage/local_storage.dart';
import 'package:pingme_manager/features/call/ui/call_screen.dart';
import 'package:pingme_manager/features/map/models/reward_model.dart';
import 'package:pingme_manager/features/message/ui/message_screen.dart';
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

  void _showAddItemModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final availableItems = RewardDefinitions.items.values.where((reward) {
          final existing = _controller.editedInventory
              .where((e) => e.itemType == reward.type.name)
              .toList();
          return existing.isEmpty || existing.first.quantity == 0;
        }).toList();

        if (availableItems.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text('Người dùng đã sở hữu tất cả các loại vật phẩm.'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: availableItems.length,
          itemBuilder: (context, index) {
            final item = availableItems[index];
            return ListTile(
              leading: Text(item.emoji, style: const TextStyle(fontSize: 24)),
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.add_circle, color: Colors.blue),
              onTap: () {
                _controller.addNewItemToInventory(
                  item.type.name,
                  item.name,
                  item.emoji,
                );
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallScreen(
                              targetUserId: widget.userId,
                              isVideoCall: false,
                              isIncoming: false,
                              fullname: user.fullname ?? 'Người dùng ẩn danh',
                              avatarUrl: user.avatarUrl ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 24),
                    ActionIconWidget(
                      icon: Icons.videocam,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallScreen(
                              targetUserId: widget.userId,
                              isVideoCall: true,
                              isIncoming: false,
                              fullname: user.fullname ?? 'Người dùng ẩn danh',
                              avatarUrl: user.avatarUrl ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 24),
                    ActionIconWidget(
                      icon: Icons.message,
                      color: Color(0xFFF5A623),
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

                          final conversationId = await _controller
                              .startConversation(widget.userId);

                          if (context.mounted) Navigator.pop(context);

                          if (conversationId != null && context.mounted) {
                            final currentUser = await LocalStorage.getUser();
                            final currentUserId = currentUser?['id'] ?? '';

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageScreen(
                                  conversationId: conversationId,
                                  partnerName:
                                      user.fullname ?? 'Người dùng ẩn danh',
                                  partnerAvatarUrl: user.avatarUrl ?? '',
                                  currentUserId: currentUserId,
                                  partnerId: widget.userId,
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

                // User inventory
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kho đồ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _controller.toggleEditInventory,
                        icon: Icon(
                          _controller.isEditingInventory
                              ? Icons.close
                              : Icons.edit,
                          size: 18,
                        ),
                        label: Text(
                          _controller.isEditingInventory ? 'Hủy' : 'Chỉnh sửa',
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: _controller.isEditingInventory
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: _controller.isEditingInventory
                        ? _controller.editedInventory.length
                        : _controller.originalInventory.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _controller.isEditingInventory
                          ? _controller.editedInventory[index]
                          : _controller.originalInventory[index];

                      if (!_controller.isEditingInventory && item.quantity <= 0)
                        return const SizedBox.shrink();

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: Text(
                            item.emoji ?? '🎁',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          item.name ?? item.itemType,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: _controller.isEditingInventory
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _controller
                                        .updateItemQuantity(item.itemType, -1),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: Text(
                                      '${item.quantity}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => _controller
                                        .updateItemQuantity(item.itemType, 1),
                                  ),
                                ],
                              )
                            : Text(
                                'x${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                      );
                    },
                  ),
                ),

                if (_controller.isEditingInventory)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: OutlinedButton.icon(
                      onPressed: _showAddItemModal,
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm phần quà mới'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                if (_controller.isEditingInventory)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _controller.isSaving
                            ? null
                            : () => _controller.saveInventoryChanges(
                                widget.userId,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _controller.isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'LƯU THAY ĐỔI',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
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
