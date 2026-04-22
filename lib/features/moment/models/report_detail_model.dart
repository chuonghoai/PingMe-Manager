import 'package:pingme_manager/features/home/models/users.dart';

class MomentInfo {
  final String id;
  final String imageUrl;
  final String? caption;
  final DateTime createdAt;
  final UserModel user;

  MomentInfo({
    required this.id,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
    required this.user,
  });

  factory MomentInfo.fromJson(Map<String, dynamic> json) {
    return MomentInfo(
      id: json['id'],
      imageUrl: json['imageUrl'],
      caption: json['caption'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']),
    );
  }
}

class Reports {
  final String id;
  final String reason;
  final String? description;
  final bool isHandled;
  final DateTime createdAt;
  final UserModel reporter;

  Reports({
    required this.id,
    required this.reason,
    this.description,
    required this.isHandled,
    required this.createdAt,
    required this.reporter,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      id: json['id'],
      reason: json['reason'],
      description: json['description'] ?? "",
      isHandled: json['isHandled'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      reporter: UserModel.fromJson(json['reporter']),
    );
  }
}

class ReportDetailModel {
  final MomentInfo momentInfo;
  final List<Reports> reports;

  ReportDetailModel({required this.momentInfo, required this.reports});

  factory ReportDetailModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailModel(
      momentInfo: MomentInfo.fromJson(json['momentInfo']),
      reports: (json['reports'] as List<dynamic>)
          .map((e) => Reports.fromJson(e))
          .toList(),
    );
  }
}
