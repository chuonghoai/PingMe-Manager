import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

class UserProfileRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getUserProfile(String userId) async {
    final response = await _apiClient.client.get('/users/$userId');
    return response.data as ApiResponse;
  }
}
