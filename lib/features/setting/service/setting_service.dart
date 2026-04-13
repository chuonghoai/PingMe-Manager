import 'package:dio/dio.dart';
import 'package:pingme_manager/core/storage/local_storage.dart';
import 'package:pingme_manager/features/setting/repository/setting_repository.dart';

class SettingService {
  final SettingRepository _settingRepository = SettingRepository();

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      // Get refresh token
      final String? refreshToken = await LocalStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return {'success': false, 'error': 'Phiên đăng nhập đã hết hạn.'};
      }

      // Call API
      final response = await _settingRepository.logout(refreshToken);
      
      if (response.success) {
        return {
          'success': true,
          'message': 'Đăng xuất thành công',
          'error': null,
        };
      } else {
        return {
          'success': false,
          'message': 'Đăng xuất thất bại',
          'error': response.message,
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['error']['message'] ?? "Lỗi kết nối máy chủ.",
      };
    } catch (e) {
      return {'success': false, 'error': "Lỗi hệ thống: $e"};
    } finally {
      await LocalStorage.clearToken();
      await LocalStorage.clearRefreshToken();
      await LocalStorage.clearUser();
    }
  }
}
