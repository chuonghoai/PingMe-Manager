class ConversationModel {
  final String id;
  final String? fullname;
  final String? avatarUrl;
  final String? lastMessageSnippet;
  final DateTime? lastMessageAt;
  int unreadCount;

  ConversationModel({
    required this.id,
    this.fullname,
    this.avatarUrl,
    this.lastMessageSnippet,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      fullname: json['name'] ?? json['fullname'] ?? 'Cuộc trò chuyện',
      avatarUrl: json['avatarUrl'],
      lastMessageSnippet: json['lastMessage']?['content'] ?? 'Chưa có tin nhắn',
      lastMessageAt: json['lastMessageAt'] != null 
          ? DateTime.tryParse(json['lastMessageAt'])?.toLocal()
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  ConversationModel copyWith({
    String? lastMessageSnippet,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ConversationModel(
      id: id,
      fullname: fullname,
      avatarUrl: avatarUrl,
      lastMessageSnippet: lastMessageSnippet ?? this.lastMessageSnippet,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}