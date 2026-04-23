import 'package:pingme_manager/core/network/api_client.dart';
import 'package:pingme_manager/core/network/api_response.dart';

class MomentRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getAllMoments({
    String page = '1',
    String limit = '40',
  }) async {
    final response = await _apiClient.client.get(
      '/admin/moments?page=$page&limit=$limit',
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> getReportedMoments({
    String page = '1',
    String limit = '40',
  }) async {
    final response = await _apiClient.client.get(
      '/admin/moments/reported?page=$page&limit=$limit',
    );
    return response.data as ApiResponse;
  }

  Future<ApiResponse> deleteMoment({required String momentId}) async {
    final response = await _apiClient.client.delete('/admin/moments/$momentId');
    return response.data as ApiResponse;
  }

  Future<ApiResponse> getReportDetail({required String momentId}) async {
    final response = await _apiClient.client.get(
      '/admin/moments/reported/$momentId',
    );
    return response.data as ApiResponse;
  }
}
