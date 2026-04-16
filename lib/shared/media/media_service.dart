import 'package:pingme_manager/shared/media/dto/cloud_signature.dart';
import 'media_repository.dart';

class MediaService {
  final MediaRepository _repository = MediaRepository();

  // 1. Lấy thông tin signature từ backend để upload lên Cloudinary an toàn
  Future<CloudinarySignature> getSignature() async {
    final response = await _repository.getSignature();

    if (response.success && response.data != null) {
      return CloudinarySignature.fromJson(response.data);
    }
    throw Exception(response.message ?? 'Không thể lấy signature từ server');
  }

  // 2. Upload trực tiếp media lên Cloudinary qua FormData
  Future<Map<String, dynamic>> uploadToCloudinary({
    required String fileUri,
    required CloudinarySignature signatureData,
    String? resourceType = 'auto',
    String? mimeType,
  }) async {
    return await _repository.uploadToCloudinary(
      fileUri: fileUri,
      signatureData: signatureData,
      resourceType: resourceType ?? 'auto',
      mimeType: mimeType,
    );
  }

  // 3. Lưu thông tin media xuống Database backend
  Future<Map<String, dynamic>> createMediaRecord(
    Map<String, dynamic> cloudinaryResponse,
  ) async {
    final dto = {
      'public_id': cloudinaryResponse['public_id'],
      'secure_url': cloudinaryResponse['secure_url'],
      'resource_type': cloudinaryResponse['resource_type'],
      'format': cloudinaryResponse['format'],
      'width': cloudinaryResponse['width'],
      'height': cloudinaryResponse['height'],
      'bytes': cloudinaryResponse['bytes'],
      'duration': cloudinaryResponse['duration'],
      'is_audio':
          cloudinaryResponse['resource_type'] == 'video' &&
          cloudinaryResponse['width'] == null,
    };

    final response = await _repository.createMediaRecord(dto);

    if (response.success && response.data != null) {
      return response.data as Map<String, dynamic>;
    }

    if (response.data is Map && (response.data as Map)['id'] != null) {
      return response.data as Map<String, dynamic>;
    }

    throw Exception(
      response.message ?? 'Không thể lưu thông tin media vào hệ thống máy chủ',
    );
  }
}
