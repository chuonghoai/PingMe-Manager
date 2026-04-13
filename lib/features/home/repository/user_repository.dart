import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

class UserRepository {
  final ApiClient _apiClient = ApiClient();

  // Get all users
  Future<ApiResponse> getAllUsers() async {
    final response = await _apiClient.client.get('/admin/users');
    return response.data as ApiResponse;
  }

  // Get admin info
  Future<ApiResponse> getMe() async {
    final response = await _apiClient.client.get('/users/me');
    return response.data as ApiResponse;
  }
}