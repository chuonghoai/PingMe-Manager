import 'package:flutter/material.dart';
import '../../../core/storage/local_storage.dart';
import '../../../main.dart'; // Import để sử dụng navigatorKey

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang chủ Admin')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Đăng xuất thử: Xóa token và điều hướng về trang Login
            await LocalStorage.clearAll();
            navigatorKey.currentState?.pushReplacementNamed('/login');
          },
          child: const Text('Đăng xuất'),
        ),
      ),
    );
  }
}