import 'package:pingme_manager/core/network/api_client.dart';
import 'package:pingme_manager/core/network/api_response.dart';

class MessageRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.client.get(
      '/messages/$conversationId',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data as ApiResponse;
  }
}
