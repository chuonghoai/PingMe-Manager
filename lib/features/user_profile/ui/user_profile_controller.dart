import 'package:flutter/material.dart';
import 'package:pingme_manager/features/conversation/services/conversation_service.dart';
import 'package:pingme_manager/features/user_profile/models/inventory_item_model.dart';
import '../service/user_profile_service.dart';
import '../models/user_profile_model.dart';

class UserProfileController extends ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();
  final ConversationService _conversationService = ConversationService();

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;
  UserProfileModel? userProfile;

  List<InventoryItemModel> originalInventory = [];
  List<InventoryItemModel> editedInventory = [];
  bool isEditingInventory = false;

  Future<void> loadProfile(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final results = await Future.wait([
      _userProfileService.fetchUserProfile(userId),
      _userProfileService.fetchUserInventory(userId),
    ]);

    final profileResult = results[0];
    final invResult = results[1];

    if (profileResult['success'] == true) {
      userProfile = profileResult['data'];
    } else {
      errorMessage = profileResult['error'];
    }

    if (invResult['success'] == true) {
      final List rawList = invResult['data'] ?? [];
      originalInventory = rawList
          .map((e) => InventoryItemModel.fromJson(e))
          .toList();
      _cloneInventoryForEdit();
    }

    isLoading = false;
    notifyListeners();
  }

  void _cloneInventoryForEdit() {
    editedInventory = originalInventory.map((e) => e.clone()).toList();
  }

  void toggleEditInventory() {
    isEditingInventory = !isEditingInventory;
    if (!isEditingInventory) {
      _cloneInventoryForEdit();
    }
    notifyListeners();
  }

  void updateItemQuantity(String itemType, int delta) {
    final index = editedInventory.indexWhere((e) => e.itemType == itemType);
    if (index >= 0) {
      editedInventory[index].quantity += delta;
      if (editedInventory[index].quantity < 0) {
        editedInventory[index].quantity = 0;
      }
      notifyListeners();
    }
  }

  void addNewItemToInventory(String itemType, String name, String emoji) {
    final exists = editedInventory.any((e) => e.itemType == itemType);
    if (!exists) {
      editedInventory.add(
        InventoryItemModel(
          itemType: itemType,
          name: name,
          emoji: emoji,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> saveInventoryChanges(String userId) async {
    isSaving = true;
    notifyListeners();

    bool hasChanges = false;
    List<Future> updateTasks = [];

    for (var editedItem in editedInventory) {
      final originalItem = originalInventory.firstWhere(
        (e) => e.itemType == editedItem.itemType,
        orElse: () =>
            InventoryItemModel(itemType: editedItem.itemType, quantity: 0),
      );

      if (originalItem.quantity != editedItem.quantity) {
        hasChanges = true;
        updateTasks.add(
          _userProfileService.updateUserInventory(
            userId,
            editedItem.itemType,
            editedItem.quantity,
            'SET',
          ),
        );
      }
    }

    if (!hasChanges) {
      isSaving = false;
      isEditingInventory = false;
      notifyListeners();
      return;
    }

    await Future.wait(updateTasks);

    await loadProfile(userId);

    isSaving = false;
    isEditingInventory = false;
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
