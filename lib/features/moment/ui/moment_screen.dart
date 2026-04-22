// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MomentScreen extends StatelessWidget {
  const MomentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Moment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text(
              'Đây là màn hình Quản lý Moment\n(Test điều hướng Slider)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Quay lại Home'),
            ),
          ],
        ),
      ),
    );
  }
}
