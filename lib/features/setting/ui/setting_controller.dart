import 'package:flutter/material.dart';
import '../repository/setting_repository.dart';

class SettingController extends ChangeNotifier {
  final SettingRepository _repository = SettingRepository();

  List<Map<String, dynamic>> features = [];
  bool isLoading = true;

  Future<void> loadFeatures() async {
    isLoading = true;
    notifyListeners();

    features = await _repository.loadSettingFeatures();

    isLoading = false;
    notifyListeners();
  }
}