class NotificationModel {
  final String id;
  final String userId;
  final String receiverId;
  final String type;
  final bool isRead;
  final String createdAt;
  final String updatedAt;
  final int version;
  final Message message;

  NotificationModel({
    this.id = '',
    this.userId = '',
    this.receiverId = '',
    this.type = '',
    this.isRead = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.version = 0,
    this.message = const Message(),
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v'] ?? 0,
      message: Message.fromJson(json['message'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'receiverId': receiverId,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'message': message.toJson(),
    };
  }
}

class Message {
  final String fullName;
  final String image;
  final String text;
  final String name;
  final String types;
  final String notificationFor;
  final String id;

  const Message({
    this.fullName = '',
    this.image = '',
    this.text = '',
    this.name = '',
    this.types = '',
    this.notificationFor = '',
    this.id = '',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      fullName: json['fullName'] ?? '',
      image: json['image'] ?? '',
      text: json['text'] ?? '',
      name: json['name'] ?? '',
      types: json['types'] ?? '',
      notificationFor: json['notificationFor'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'image': image,
      'text': text,
      'name': name,
      'types': types,
      'notificationFor': notificationFor,
      '_id': id,
    };
  }
}
