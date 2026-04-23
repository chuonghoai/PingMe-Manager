class UserProfileModel {
  final String id;
  final String? fullname;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dob;
  final bool isOnline;
  final DateTime? lastActiveAt;
  final String? statusMessage;
  final int level;
  final int currentExp;
  final String? checkInLocation;
  final String? storyUrl;

  UserProfileModel({
    required this.id,
    this.fullname,
    this.avatarUrl,
    this.gender,
    this.dob,
    required this.isOnline,
    this.lastActiveAt,
    this.statusMessage,
    required this.level,
    required this.currentExp,
    this.checkInLocation,
    this.storyUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      fullname: json['fullname'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      isOnline: json['isOnline'] ?? false,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'])
          : null,
      statusMessage: json['statusMessage'],
      level: json['level'] ?? 1,
      currentExp: json['currentExp'] ?? 0,
      checkInLocation: json['checkInLocation'],
      storyUrl: json['storyUrl'],
    );
  }
}
