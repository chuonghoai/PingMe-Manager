import 'package:dio/dio.dart';
import '../../../core/storage/local_storage.dart';
import 'dto/response/login_response_model.dart';
import '../repository/auth_repository.dart';

class AuthService {
  final AuthRepository _repository = AuthRepository();

  Future<String?> processLogin(
    String email,
    String password,
    bool rememberMe,
  ) async {
    try {
      final apiResponse = await _repository.login(email, password, rememberMe);

      if (apiResponse.success && apiResponse.data != null) {
        final loginData = LoginResponseModel.fromJson(apiResponse.data);

        await LocalStorage.setToken(loginData.tempToken);

        return null;
      } else {
        return apiResponse.message ?? "Lỗi không xác định từ máy chủ.";
      }
    } on DioException catch (e) {
      return e.error?.toString() ?? "Lỗi kết nối máy chủ.";
    } catch (e) {
      return "Đã xảy ra lỗi hệ thống: $e";
    }
  }
}
