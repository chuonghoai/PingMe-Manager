import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

class UserProfileRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getUserProfile(String userId) async {
    final response = await _apiClient.client.get('/users/$userId');
    return response.data as ApiResponse;
  }

  Future<ApiResponse> getUserInventory(String userId) async {
    final response = await _apiClient.client.get(
      '/admin/users/$userId/inventory',
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> updateUserInventory(
    String userId,
    String itemType,
    int amount,
    String action,
  ) async {
    final response = await _apiClient.client.post(
      '/admin/users/$userId/inventory',
      data: {'itemType': itemType, 'amount': amount, 'action': action},
    );
    return response.data as ApiResponse;
  }
}
