import 'package:pingme_manager/core/network/api_client.dart';
import 'package:pingme_manager/core/network/api_response.dart';

class MapEventRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getAllEvents() async {
    final response = await _apiClient.client.get('/map/events/admin/all');
    return response.data as ApiResponse;
  }

  Future<ApiResponse> createEvent(Map<String, dynamic> data) async {
    final response = await _apiClient.client.post(
      '/map/events/admin/create',
      data: data,
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> deleteEvent(String eventId) async {
    final response = await _apiClient.client.delete(
      '/map/events/admin/delete/$eventId',
    );
    return response.data as ApiResponse;
  }
}
