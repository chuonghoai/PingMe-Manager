import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';

class ConversationRepository {
  final ApiClient _apiClient = ApiClient();

  // Get list conversation
  Future<ApiResponse> getConversations() async {
    final response = await _apiClient.client.get('/conversations');
    return response.data as ApiResponse;
  }
}