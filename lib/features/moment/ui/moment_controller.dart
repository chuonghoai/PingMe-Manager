import 'package:flutter/material.dart';
import '../services/moment_service.dart';
import '../models/moment_model.dart';
import '../models/report_detail_model.dart';

class MomentController extends ChangeNotifier {
  final MomentService _service = MomentService();

  // List all moments
  List<MomentModel> allMoments = [];
  bool isLoadingAll = false;
  int _allPage = 1;
  bool _hasMoreAll = true;

  // List reported moments
  List<MomentModel> reportedMoments = [];
  bool isLoadingReported = false;
  int _reportedPage = 1;
  bool _hasMoreReported = true;

  // Moment detail
  ReportDetailModel? reportDetail;
  bool isLoadingDetail = false;

  String? errorMessage;

  // Get list all moments
  Future<void> fetchAllMoments({bool isRefresh = false}) async {
    if (isRefresh) {
      _allPage = 1;
      _hasMoreAll = true;
      allMoments = [];
      notifyListeners();
    }

    if (!_hasMoreAll || isLoadingAll) return;

    try {
      isLoadingAll = true;
      errorMessage = null;
      notifyListeners();

      final result = await _service.getAllMoments(page: _allPage);

      final List<MomentModel> newMoments = result['moments'];
      final int total = result['total'];

      allMoments.addAll(newMoments);

      if (allMoments.length >= total || newMoments.isEmpty) {
        _hasMoreAll = false;
      } else {
        _allPage++;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingAll = false;
      notifyListeners();
    }
  }

  // Get list reported moments
  Future<void> fetchReportedMoments({bool isRefresh = false}) async {
    if (isRefresh) {
      _reportedPage = 1;
      _hasMoreReported = true;
      reportedMoments = [];
      notifyListeners();
    }

    if (!_hasMoreReported || isLoadingReported) return;

    try {
      isLoadingReported = true;
      errorMessage = null;
      notifyListeners();

      final result = await _service.getReportedMoments(page: _reportedPage);

      final List<MomentModel> newMoments = result['moments'];
      final int total = result['total'];

      reportedMoments.addAll(newMoments);

      if (reportedMoments.length >= total || newMoments.isEmpty) {
        _hasMoreReported = false;
      } else {
        _reportedPage++;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingReported = false;
      notifyListeners();
    }
  }

  // Get report detail
  Future<void> fetchReportDetail(String momentId) async {
    try {
      isLoadingDetail = true;
      errorMessage = null;
      notifyListeners();

      final detail = await _service.getReportDetail(momentId);
      reportDetail = detail;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Delete moment
  Future<bool> deleteMoment(String momentId) async {
    try {
      final success = await _service.deleteMoment(momentId);
      if (success) {
        allMoments.removeWhere((m) => m.id == momentId);
        reportedMoments.removeWhere((m) => m.id == momentId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
