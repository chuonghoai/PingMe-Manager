import 'package:flutter/material.dart';
import 'package:pingme_manager/features/conversation/services/conversation_service.dart';
import '../service/user_profile_service.dart';
import '../models/user_profile_model.dart';

class UserProfileController extends ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();
  final ConversationService _conversationService = ConversationService();

  bool isLoading = true;
  String? errorMessage;
  UserProfileModel? userProfile;

  Future<void> loadProfile(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _userProfileService.fetchUserProfile(userId);

    if (result['success'] == true) {
      userProfile = result['data'];
    } else {
      errorMessage = result['error'];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> startConversation(String targetUserId) async {
    final result = await _conversationService.startConversation(targetUserId);

    if (result['success'] == true) {
      return result['conversationId'];
    } else {
      throw Exception(result['error']);
    }
  }
}
