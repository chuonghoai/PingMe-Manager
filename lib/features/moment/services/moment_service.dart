import '../repository/moment_repository.dart';
import '../models/moment_model.dart';
import '../models/report_detail_model.dart';

class MomentService {
  final MomentRepository _repository = MomentRepository();

  Future<Map<String, dynamic>> getAllMoments({
    int page = 1,
    int limit = 40,
  }) async {
    try {
      final response = await _repository.getAllMoments(
        page: page.toString(),
        limit: limit.toString(),
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> momentsList = data['moments'] ?? [];

        return {
          'moments': momentsList.map((e) => MomentModel.fromJson(e)).toList(),
          'total': data['total'] ?? 0,
        };
      }
      throw Exception(response.message ?? 'Lỗi khi lấy danh sách Moment');
    } catch (e) {
      throw Exception('Lỗi Service: $e');
    }
  }

  Future<Map<String, dynamic>> getReportedMoments({
    int page = 1,
    int limit = 40,
  }) async {
    try {
      final response = await _repository.getReportedMoments(
        page: page.toString(),
        limit: limit.toString(),
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> momentsList = data['moments'] ?? [];

        return {
          'moments': momentsList.map((e) => MomentModel.fromJson(e)).toList(),
          'total': data['total'] ?? 0,
        };
      }
      throw Exception(response.message ?? 'Lỗi khi lấy danh sách bị báo cáo');
    } catch (e) {
      throw Exception('Lỗi Service: $e');
    }
  }

  Future<ReportDetailModel> getReportDetail(String momentId) async {
    try {
      final response = await _repository.getReportDetail(momentId: momentId);

      if (response.success && response.data != null) {
        return ReportDetailModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      throw Exception(response.message ?? 'Lỗi khi lấy chi tiết báo cáo');
    } catch (e) {
      throw Exception('Lỗi Service: $e');
    }
  }

  Future<bool> deleteMoment(String momentId) async {
    try {
      final response = await _repository.deleteMoment(momentId: momentId);
      return response.success;
    } catch (e) {
      throw Exception('Lỗi Service khi xóa: $e');
    }
  }
}
