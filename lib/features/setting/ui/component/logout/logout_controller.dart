import 'package:flutter/material.dart';
import 'package:pingme_manager/features/setting/service/setting_service.dart';

class LogoutController extends ChangeNotifier {
  final SettingService _settingService = SettingService();

  Future<bool> processLogout() async {
    await _settingService.logout();
    return true;
  }
}
