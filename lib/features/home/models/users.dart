class UserModel {
  final String id;
  final String? fullname;
  final bool isOnline;
  final String? avatarUrl;
  final String status;

  UserModel({
    required this.id,
    this.fullname,
    required this.isOnline,
    this.avatarUrl,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullname: json['fullname'],
      isOnline: json['isOnline'] ?? false,
      avatarUrl: json['avatarUrl'],
      status: json['status'] ?? 'PENDING',
    );
  }
}