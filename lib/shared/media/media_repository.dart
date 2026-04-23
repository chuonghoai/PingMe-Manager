import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pingme_manager/core/network/api_client.dart';
import 'package:pingme_manager/core/network/api_response.dart';
import 'package:pingme_manager/shared/media/dto/cloud_signature.dart';

class MediaRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getSignature() async {
    final response = await _apiClient.client.get('/media/signature');
    return response.data as ApiResponse;
  }

  Future<Map<String, dynamic>> uploadToCloudinary({
    required String fileUri,
    required CloudinarySignature signatureData,
    String resourceType = 'auto',
    String? mimeType,
  }) async {
    try {
      final fileName = fileUri.split('/').last.isNotEmpty
          ? fileUri.split('/').last
          : 'upload_${DateTime.now().millisecondsSinceEpoch}';

      MediaType? contentType;
      if (mimeType != null) {
        final split = mimeType.split('/');
        if (split.length == 2) {
          contentType = MediaType(split[0], split[1]);
        }
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          fileUri,
          filename: fileName,
          contentType: contentType,
        ),
        'timestamp': signatureData.timestamp.toString(),
        'signature': signatureData.signature,
        'api_key': signatureData.apiKey,
        if (signatureData.folder != null) 'folder': signatureData.folder,
        if (signatureData.tags != null) 'tags': signatureData.tags,
      });

      final uploadUrl =
          'https://api.cloudinary.com/v1_1/${signatureData.cloudName}/$resourceType/upload';

      final directDio = Dio();
      final response = await directDio.post(
        uploadUrl,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        'Upload thất bại: ${e.response?.statusCode} - ${e.response?.data}',
      );
    } catch (e) {
      throw Exception('Upload thất bại: $e');
    }
  }

  Future<ApiResponse> createMediaRecord(Map<String, dynamic> dto) async {
    final response = await _apiClient.client.post('/media', data: dto);
    return response.data as ApiResponse;
  }
}
