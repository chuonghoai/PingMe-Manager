import 'package:dio/dio.dart';
import '../repository/user_profile_repository.dart';
import '../models/user_profile_model.dart';

class UserProfileService {
  final UserProfileRepository _repository = UserProfileRepository();

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    try {
      final res = await _repository.getUserProfile(userId);

      if (res.success && res.data != null) {
        final userProfile = UserProfileModel.fromJson(res.data);
        return {'success': true, 'data': userProfile, 'error': null};
      }
      return {
        'success': false,
        'error': res.message ?? 'Không thể lấy thông tin người dùng',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error']['message'] ?? 'Lỗi kết nối mạng.',
      };
    } catch (e) {
      return {'success': false, 'error': 'Lỗi hệ thống: $e'};
    }
  }

  Future<Map<String, dynamic>> fetchUserInventory(String userId) async {
    try {
      final res = await _repository.getUserInventory(userId);
      if (res.success && res.data != null) {
        return {'success': true, 'data': res.data, 'error': null};
      }
      return {'success': false, 'error': res.message};
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error']['message'] ?? 'Lỗi kết nối mạng.',
      };
    } catch (e) {
      return {'success': false, 'error': 'Lỗi hệ thống: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUserInventory(
    String userId,
    String itemType,
    int amount,
    String action,
  ) async {
    try {
      final res = await _repository.updateUserInventory(
        userId,
        itemType,
        amount,
        action,
      );
      return {
        'success': res.success,
        'error': res.success ? null : res.message,
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error']['message'] ?? 'Lỗi kết nối mạng.',
      };
    } catch (e) {
      return {'success': false, 'error': 'Lỗi hệ thống: $e'};
    }
  }
}
