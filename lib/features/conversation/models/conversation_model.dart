class ParticipantModel {
  final String userId;
  final String? fullname;
  final String? avatarUrl;
  final bool isOnline;

  ParticipantModel({
    required this.userId,
    this.fullname,
    this.avatarUrl,
    this.isOnline = false,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      userId: json['userId'] ?? json['id'] ?? '',
      fullname: json['fullname'] ?? json['name'],
      avatarUrl: json['avatarUrl'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  ParticipantModel copyWith({
    String? userId,
    String? fullname,
    String? avatarUrl,
    bool? isOnline,
  }) {
    return ParticipantModel(
      userId: userId ?? this.userId,
      fullname: fullname ?? this.fullname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullname': fullname,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
    };
  }
}

class ConversationModel {
  final String id;
  final String type;
  final String? name;
  final String? avatarUrl;
  final String? lastMessageSnippet;
  final DateTime? lastMessageAt;
  final String? blockedById;
  final int unreadCount;
  final bool hasMuted;
  final List<ParticipantModel> participants;

  String? displayFullName;
  String? displayAvatarUrl;
  int myUnreadCount;

  ConversationModel({
    required this.id,
    required this.type,
    this.name,
    this.avatarUrl,
    this.lastMessageSnippet,
    this.lastMessageAt,
    this.blockedById,
    this.unreadCount = 0,
    this.hasMuted = false,
    required this.participants,
    this.displayFullName,
    this.displayAvatarUrl,
    this.myUnreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'ONE_TO_ONE',
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      lastMessageSnippet: json['lastMessageSnippet'],
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'])?.toLocal()
          : null,
      blockedById: json['blockedById'],
      unreadCount: json['unreadCount'] ?? 0,
      hasMuted: json['hasMuted'] ?? false,
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((e) => ParticipantModel.fromJson(e))
              .toList()
          : [],
    );
  }

  ConversationModel copyWith({
    String? lastMessageSnippet,
    DateTime? lastMessageAt,
    int? unreadCount,
    int? myUnreadCount,
    String? displayFullName,
    String? displayAvatarUrl,
  }) {
    return ConversationModel(
      id: id,
      type: type,
      name: name,
      avatarUrl: avatarUrl,
      lastMessageSnippet: lastMessageSnippet ?? this.lastMessageSnippet,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      blockedById: blockedById,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMuted: hasMuted,
      participants: participants,
      displayFullName: displayFullName ?? this.displayFullName,
      displayAvatarUrl: displayAvatarUrl ?? this.displayAvatarUrl,
      myUnreadCount: myUnreadCount ?? this.myUnreadCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'avatarUrl': avatarUrl,
      'lastMessageSnippet': lastMessageSnippet,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'blockedById': blockedById,
      'unreadCount': unreadCount,
      'hasMuted': hasMuted,
      'participants': participants.map((e) => e.toJson()).toList(),
      'displayFullName': displayFullName,
      'displayAvatarUrl': displayAvatarUrl,
      'myUnreadCount': myUnreadCount,
    };
  }
}
