import 'package:flutter/material.dart';
import '../service/user_profile_service.dart';
import '../models/user_profile_model.dart';

class UserProfileController extends ChangeNotifier {
  final UserProfileService _service = UserProfileService();

  bool isLoading = true;
  String? errorMessage;
  UserProfileModel? userProfile;

  Future<void> loadProfile(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchUserProfile(userId);

    if (result['success'] == true) {
      userProfile = result['data'];
    } else {
      errorMessage = result['error'];
    }

    isLoading = false;
    notifyListeners();
  }
}
