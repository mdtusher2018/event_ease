
class BusinessLikeModel {
  final String id;
  final String businessId;
  final List<Comment> comments;
  final List<String> followers;
  final List<String> likes;
  final String createdAt;
  final String updatedAt;

  BusinessLikeModel({
    required this.id,
    required this.businessId,
    required this.comments,
    required this.followers,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessLikeModel.fromJson(Map<String, dynamic> json) {
    return BusinessLikeModel(
      id: json['_id'] ?? '',
      businessId: json['businessId'] ?? '',
      comments: (json['comments'] as List?)
              ?.map((e) => Comment.fromJson(e))
              .toList() ??
          [],
      followers: (json['followers'] as List?)?.map((e) => e.toString()).toList() ?? [],
      likes: (json['likes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Comment {
  final String user;
  final String text;

  Comment({
    required this.user,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] ?? '',
      text: json['text'] ?? '',
    );
  }
}
