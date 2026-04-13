import 'package:flutter/material.dart';
import 'package:pingme_manager/features/setting/ui/component/logout/logout_controller.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final LogoutController _controller = LogoutController();

  @override
  void initState() {
    super.initState();
    _controller.handleLogout();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF5A623),
            ),
            SizedBox(height: 24),
            Text(
              'Đang đăng xuất...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}