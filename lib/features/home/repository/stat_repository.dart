import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

class StatRepository {
  final ApiClient _apiClient = ApiClient();

  // Get stats
  Future<ApiResponse> getStats() async {
    final response = await _apiClient.client.get('/admin/stats');
    return response.data as ApiResponse;
  }
}