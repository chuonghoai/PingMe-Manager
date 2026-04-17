// ignore_for_file: unused_import, use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:pingme_manager/features/auth/ui/forgotPassword/verify_email_screen.dart';
import 'package:pingme_manager/features/conversation/ui/conversation_screen.dart';
import 'package:pingme_manager/features/message/ui/message_screen.dart';
import 'package:pingme_manager/features/setting/ui/component/change_password/change_password_screen.dart';
import 'package:pingme_manager/features/setting/ui/component/logout/logout_screen.dart';
import 'package:pingme_manager/features/setting/ui/component/profile_setting/profile_setting_screen.dart';
import 'package:pingme_manager/features/setting/ui/setting_screen.dart';
import 'package:pingme_manager/features/user_profile/ui/user_profile_screen.dart';
import 'core/network/api_client.dart';
import 'core/network/api_response.dart';
import 'core/storage/local_storage.dart';
import 'features/auth/ui/login/login_screen.dart';
import 'package:pingme_manager/features/call/ui/call_screen.dart';
import 'features/home/ui/home_screen.dart';
import 'main.dart';
import 'shared/websocket/websocket_gateway.dart';

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

        await WebsocketGateway().connect();
      }
    } catch (e) {
      await LocalStorage.clearAll();
      initialRoute = '/login';
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        print('[App Lifecycle] App Detached -> Đang ngắt Websocket...');
        WebsocketGateway().disconnect();
        break;
      case AppLifecycleState.resumed:
        WebsocketGateway().connect();
        break;
      default:
        break;
    }
  }

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
      initialRoute: widget.initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),

        // Setting
        '/setting': (context) => const SettingScreen(),
        '/setting/profile': (context) => const ProfileSettingScreen(),
        '/setting/change_password': (context) => const ChangePasswordScreen(),
        '/logout': (context) => const LogoutScreen(),
        '/conversation': (context) => const ConversationScreen(),
      },
      onGenerateRoute: (settings) {
        // User profile
        if (settings.name == '/user-profile') {
          final String userId = settings.arguments as String;

          return MaterialPageRoute(
            builder: (context) => UserProfileScreen(userId: userId),
          );
        }

        // Call screen
        if (settings.name == '/call') {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          
          return MaterialPageRoute(
            builder: (context) => CallScreen(
              targetUserId: args['targetUserId'],
              isVideoCall: args['isVideoCall'],
              isIncoming: args['isIncoming'],
              fullname: args['fullname'],
              avatarUrl: args['avatarUrl'],
            ),
          );
        }

        // Message screen
        if (settings.name == '/message') {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          final String conversationId = args['conversationId'];
          final String partnerName = args['partnerName'];
          final String? partnerAvatarUrl = args['partnerAvatarUrl'];
          final String currentUserId = args['currentUserId'];
          final String partnerId = args['partnerId'];

          return MaterialPageRoute(
            builder: (context) => MessageScreen(
              conversationId: conversationId,
              partnerName: partnerName,
              partnerAvatarUrl: partnerAvatarUrl ?? '',
              currentUserId: currentUserId,
              partnerId: partnerId,
            ),
          );
        }
        return null;
      },
    );
  }
}
