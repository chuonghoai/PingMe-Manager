class AdminModel {
  final String id;
  final String email;
  final String? fullname;
  final String? avatarUrl;
  final String status;
  final String role;

  AdminModel({
    required this.id,
    required this.email,
    this.fullname,
    this.avatarUrl,
    required this.status,
    required this.role,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullname'],
      avatarUrl: json['avatarUrl'],
      status: json['status'] ?? 'ACTIVE',
      role: json['role'] ?? 'ADMIN',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
      'status': status,
      'role': role,
    };
  }
}
