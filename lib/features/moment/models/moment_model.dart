import 'package:pingme_manager/features/home/models/users.dart';

class MomentModel {
  final String id;
  final String imageUrl;
  final String? caption;
  final DateTime createdAt;
  final UserModel user;
  final int? reportCount;
  final bool? isReported;
  final int? unhandledReportCount;

  MomentModel({
    required this.id,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
    required this.user,
    this.reportCount,
    this.isReported,
    this.unhandledReportCount,
  });

  factory MomentModel.fromJson(Map<String, dynamic> json) {
    return MomentModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      caption: json['caption'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']),
      reportCount: json['reportCount'] ?? 0,
      isReported: json['isReported'] ?? false,
      unhandledReportCount: json['unhandledReportCount'] ?? 0,
    );
  }
}
