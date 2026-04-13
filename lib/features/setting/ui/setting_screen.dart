// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'setting_controller.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingController _controller = SettingController();

  @override
  void initState() {
    super.initState();
    _controller.loadFeatures();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIconFromString(String iconStr) {
    switch (iconStr) {
      case 'person_outline':
        return Icons.person_outline;
      case 'notifications_none':
        return Icons.notifications_none;
      case 'lock_outline':
        return Icons.lock_outline;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.settings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5A623)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: _controller.features.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final feature = _controller.features[index];
              final bool isDestructive = feature['isDestructive'] ?? false;
              final Color itemColor = isDestructive
                  ? Colors.red
                  : const Color(0xFF1C1E21);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Icon(
                    _getIconFromString(feature['icon']),
                    color: itemColor,
                  ),
                  title: Text(
                    feature['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: itemColor,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, feature['route']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
