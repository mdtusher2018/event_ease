// class NotificationResponse {
//   bool success;
//   int statusCode;
//   String message;
//   List<NotificationData> data;

//   NotificationResponse({
//     required this.success,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });

//   factory NotificationResponse.fromJson(Map<String, dynamic> json) {
//     return NotificationResponse(
//       success: json['success'],
//       statusCode: json['statusCode'],
//       message: json['message'],
//       data: List<NotificationData>.from(
//           json['data'].map((x) => NotificationData.fromJson(x))),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'success': success,
//         'statusCode': statusCode,
//         'message': message,
//         'data': data.map((x) => x.toJson()).toList(),
//       };
// }

class NotificationData {
  String id;
  String userId;
  String receiverId;
  Message message;
  String type;
  String channel;
  String status;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int sentCount;

  NotificationData({
    required this.id,
    required this.userId,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.channel,
    required this.status,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.sentCount,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id']??"",
      userId: json['userId']??"",
      receiverId: json['receiverId']??"",
      message: Message.fromJson(json['message']??{}),
      type: json['type']??"",
      channel: json['channel']??"",
      status: json['status']??"",
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      sentCount: json['sentCount']??"",
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'receiverId': receiverId,
        'message': message.toJson(),
        'type': type,
        'channel': channel,
        'status': status,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'sentCount': sentCount,
      };
}

class Message {
  String fullName;
  String image;
  String text;
  String types;
  String notificationFor;
  String id;
  String name;

  Message({
    required this.fullName,
    required this.image,
    required this.text,
    required this.types,
    required this.notificationFor,
    required this.id,
    required this.name,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      fullName: json['fullName']??"",
      image: json['image']??"",
      text: json['text']??"",
      types: json['types']??"",
      notificationFor: json['notificationFor'] ?? '',
      id: json['_id']??"",
      name: json['name'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'image': image,
        'text': text,
        'types': types,
        'notificationFor': notificationFor,
        '_id': id,
        'name': name,
      };
}
