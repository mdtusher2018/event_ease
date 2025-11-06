// class EventCommentsResponse {
//   final bool success;
//   final int statusCode;
//   final String message;
//   final List<EventComment> data;
//   EventCommentsResponse({
//     required this.success,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });
//   factory EventCommentsResponse.fromJson(Map<String, dynamic> json) {
//     return EventCommentsResponse(
//       success: json['success'] ?? false,
//       statusCode: json['statusCode'] ?? 0,
//       message: json['message'] ?? '',
//       data: (json['data'] as List<dynamic>?)
//               ?.map((e) => EventComment.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
// }
// class EventComment {
//   final CommentUser user;
//   final String text;
//   EventComment({required this.user, required this.text});
//   factory EventComment.fromJson(Map<String, dynamic> json) {
//     return EventComment(
//       user: CommentUser.fromJson(json['user']),
//       text: json['text'] ?? '',
//     );
//   }
// }
// class CommentUser {
//   final String id;
//   final String name;
//   final String profileImage;
//   CommentUser({
//     required this.id,
//     required this.name,
//     required this.profileImage,
//   });
//   factory CommentUser.fromJson(Map<String, dynamic> json) {
//     return CommentUser(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       profileImage: json['profileImage'] ?? '',
//     );
//   }
// }



class EventComment {
  final String id;
  final String text;
  final User user;
  final String createdAt;
  final List<EventComment> replies; // Recursive replies

  EventComment({
    required this.id,
    required this.text,
    required this.user,
    required this.createdAt,
    required this.replies,
  });

  factory EventComment.fromJson(Map<String, dynamic> json) {
    return EventComment(
      id: json['_id'] ?? "",
      text: json['text'] ?? "",
      user: User.fromJson(json['user'] ?? {}),
      createdAt: json['createdAt'] ?? "",
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((e) => EventComment.fromJson(e)) // Recursive parsing
          .toList(),
    );
  }
}

class User {
  final String id;
  final String name;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      profileImage: json['profileImage'] ?? "",
    );
  }
}
