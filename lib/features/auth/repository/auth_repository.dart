import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> login(String email, String password, bool rememberMe) async {
    final response = await _apiClient.client.post(
      '/admin/auth/login',
      data: {
        'email': email,
        'password': password,
        'rememberMe': rememberMe,
      },
    );
    
    return response.data as ApiResponse;
  }
}