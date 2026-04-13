import 'package:flutter/material.dart';
import 'package:pingme_manager/features/home/models/admin.dart';
import '../service/home_service.dart';
import '../models/users.dart';
import '../models/stats.dart';

class HomeController extends ChangeNotifier {
  final HomeService _service = HomeService();

  bool isLoading = true;
  String? errorMessage;

  StatModel? stats;
  List<UserModel> users = [];
  AdminModel? myProfile;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchHomeData();

    if (result['error'] != null) {
      errorMessage = result['error'];
    } else {
      stats = result['stats'];
      users = result['users'];
      myProfile = result['myProfile'];
    }

    isLoading = false;
    notifyListeners();
  }
}