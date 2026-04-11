import 'package:flutter/material.dart';
import '../../service/auth_service.dart';

class LoginController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  bool rememberMe = false;

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Vui lòng nhập đầy đủ email và mật khẩu.";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final error = await _authService.processLogin(email, password, rememberMe);

    isLoading = false;
    if (error == null) {
      notifyListeners();
      return true;
    } else {
      errorMessage = error;
      notifyListeners();
      return false;
    }
  }
}