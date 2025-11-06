class BusinessLikeData {
  final String id;
  final String businessId;
  final int v;
  final List<dynamic> comments;
  final DateTime createdAt;
  final List<String> followers;
  final List<String> likes;
  final DateTime updatedAt;

  BusinessLikeData({
    required this.id,
    required this.businessId,
    required this.v,
    required this.comments,
    required this.createdAt,
    required this.followers,
    required this.likes,
    required this.updatedAt,
  });

  factory BusinessLikeData.fromJson(Map<String, dynamic> json) {
    return BusinessLikeData(
      id: json['_id'],
      businessId: json['businessId'],
      v: json['__v'],
      comments: List<dynamic>.from(json['comments']),
      createdAt: DateTime.parse(json['createdAt']),
      followers: List<String>.from(json['followers']),
      likes: List<String>.from(json['likes']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'businessId': businessId,
        '__v': v,
        'comments': comments,
        'createdAt': createdAt.toIso8601String(),
        'followers': followers,
        'likes': likes,
        'updatedAt': updatedAt.toIso8601String(),
      };
}
