// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'core/network/api_client.dart';
import 'core/network/api_response.dart';
import 'core/storage/local_storage.dart';
import 'features/auth/ui/login/login_screen.dart';
import 'main.dart';

// Dummy home screen tmp
class DummyHomeScreen extends StatelessWidget {
  const DummyHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang chủ Admin')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Đăng xuất thử
            await LocalStorage.clearAll();
            navigatorKey.currentState?.pushReplacementNamed('/login');
          },
          child: const Text('Đăng xuất'),
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await LocalStorage.getToken();
  String initialRoute = '/login';

  if (token != null && token.isNotEmpty) {
    try {
      final response = await ApiClient().client.get('/users/me');
      final apiResponse = response.data as ApiResponse;

      if (apiResponse.success) {
        initialRoute = '/home';

        if (apiResponse.data != null) {
          await LocalStorage.setUser(apiResponse.data);
        }
      }
    } catch (e) {
      await LocalStorage.clearAll();
      initialRoute = '/login';
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoGo Admin',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5A623)),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const DummyHomeScreen(), // Dummy home tmp
      },
    );
  }
}
