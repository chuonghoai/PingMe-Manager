class StatModel {
  final int totalUsers;
  final int totalOnlines;
  final int totalLocks;
  final int totalUnreadCount;

  StatModel({
    required this.totalUsers,
    required this.totalOnlines,
    required this.totalLocks,
    required this.totalUnreadCount,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) {
    return StatModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalOnlines: json['totalOnlines'] ?? 0,
      totalLocks: json['totalLocks'] ?? 0,
      totalUnreadCount: json['totalUnreadCount'] ?? 0,
    );
  }
}
