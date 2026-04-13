import 'package:dio/dio.dart';
import 'package:pingme_manager/features/home/models/admin.dart';
import '../../../core/storage/local_storage.dart';
import '../repository/user_repository.dart';
import '../repository/stat_repository.dart';
import '../models/users.dart';
import '../models/stats.dart';

class HomeService {
  final UserRepository _userRepo = UserRepository();
  final StatRepository _statRepo = StatRepository();

  Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      // Get stats
      final statRes = await _statRepo.getStats();
      StatModel? stats;
      if (statRes.success && statRes.data != null) {
        stats = StatModel.fromJson(statRes.data);
      }

      // Get users
      final userRes = await _userRepo.getAllUsers();
      List<UserModel> users = [];
      if (userRes.success && userRes.data != null) {
        final List<dynamic> list = userRes.data;
        users = list.map((e) => UserModel.fromJson(e)).toList();
      }

      // Get admin info and save local storage
      final meRes = await _userRepo.getMe();
      AdminModel? myProfile;
      if (meRes.success && meRes.data != null) {
        myProfile = AdminModel.fromJson(meRes.data);
        await LocalStorage.setUser(myProfile.toJson());
      } else {
        final cachedUser = await LocalStorage.getUser();
        if (cachedUser != null) {
          myProfile = AdminModel.fromJson(cachedUser);
        }
      }

      return {
        'stats': stats,
        'users': users,
        'myProfile': myProfile,
        'error': null,
      };
    } on DioException catch (e) {
      return {'error': e.error?.toString() ?? "Lỗi kết nối máy chủ."};
    } catch (e) {
      return {'error': "Lỗi hệ thống: $e"};
    }
  }
}
