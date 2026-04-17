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

  Future<ApiResponse> getConversationMedia(
    String conversationId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.client.get(
      '/messages/$conversationId/media',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> blockUser(String conversationId) async {
    final response = await _apiClient.client.post(
      '/conversations/$conversationId/block',
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> unblockUser(String conversationId) async {
    final response = await _apiClient.client.post(
      '/conversations/$conversationId/unblock',
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> clearHistory(String conversationId) async {
    final response = await _apiClient.client.post(
      '/conversations/$conversationId/clear-history',
    );
    return response.data as ApiResponse;
  }
}
