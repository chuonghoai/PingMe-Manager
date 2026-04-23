class Sender {
  final String id;
  final String fullname;
  final String? avatarUrl;

  Sender({required this.id, required this.fullname, this.avatarUrl});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullname': fullname, 'avatarUrl': avatarUrl};
  }
}

class Media {
  final String id;
  final String secureUrl;
  final String resourceType;

  Media({required this.id, required this.secureUrl, required this.resourceType});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? '',
      secureUrl: json['secureUrl'] ?? '',
      resourceType: json['resourceType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'secureUrl': secureUrl,
    'resourceType': resourceType,
  };
}

class ReplyTo {
  final String id;
  final String? content;
  final String type;
  final Sender? sender;

  ReplyTo({
    required this.id,
    this.content,
    required this.type,
    this.sender,
  });

  factory ReplyTo.fromJson(Map<String, dynamic> json) {
    return ReplyTo(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'sender': sender?.toJson(),
    };
  }
}

class MessageItem {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  final String type;
  final bool isRevoked;
  final bool isRead;
  final DateTime? createdAt;
  final Sender sender;
  final ReplyTo? replyTo;
  final Media? media;

  MessageItem({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    required this.type,
    required this.isRevoked,
    required this.isRead,
    this.createdAt,
    required this.sender,
    this.replyTo,
    this.media,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'],
      type: json['type'] ?? 'TEXT',
      isRevoked: json['isRevoked'] ?? false,
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      sender: Sender.fromJson(json['sender'] ?? {}),
      replyTo: json['replyTo'] != null ? ReplyTo.fromJson(json['replyTo']) : null,
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'isRevoked': isRevoked,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'sender': sender.toJson(),
      'replyTo': replyTo?.toJson(),
      'media': media?.toJson(),
    };
  }
}

class Meta {
  final int totalItems;
  final int itemCount;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  Meta({
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      totalItems: json['totalItems'] ?? 0,
      itemCount: json['itemCount'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'itemCount': itemCount,
      'itemsPerPage': itemsPerPage,
      'totalPages': totalPages,
      'currentPage': currentPage,
    };
  }
}

class MessageModel {
  final List<MessageItem> messages;
  final Meta meta;

  MessageModel({required this.messages, required this.meta});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messages: (json['messages'] as List?)?.map((e) => MessageItem.fromJson(e)).toList() ?? [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'messages': messages.map((e) => e.toJson()).toList(), 'meta': meta.toJson()};
  }
}
