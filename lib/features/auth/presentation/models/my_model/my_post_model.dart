class MyPostModel {
  String id;
  Creator creator;
  String title;
  String category;
  String region;
  String description;
  String image;
  String createdAt;
  String updatedAt;
  int v;
  int totalLikes;
  int totalComments;
  bool isLiked;
  EngagementStats engagementStats;

  MyPostModel({
    this.id = '',
    Creator? creator,
    this.title = '',
    this.category = '',
    this.region = '',
    this.description = '',
    this.image = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.v = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    EngagementStats? engagementStats,
  })  : creator = creator ?? Creator(),
        engagementStats = engagementStats ?? EngagementStats();

  factory MyPostModel.fromJson(Map<String, dynamic> json) {
    return MyPostModel(
      id: json['_id'] ?? '',
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : Creator(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      region: json['region'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      engagementStats: json['engagementStats'] != null
          ? EngagementStats.fromJson(json['engagementStats'])
          : EngagementStats(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'creator': creator.toJson(),
      'title': title,
      'category': category,
      'region': region,
      'description': description,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'isLiked': isLiked,
      'engagementStats': engagementStats.toJson(),
    };
  }
}

class Creator {
  String id;
  String sureName;
  String name;
  String profileImage;

  Creator({
    this.id = '',
    this.sureName = '',
    this.name = '',
    this.profileImage = '',
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['_id'] ?? '',
      sureName: json['sureName'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sureName': sureName,
      'name': name,
      'profileImage': profileImage,
    };
  }
}

class EngagementStats {
  String id;
  String postId;
  int v;
  String createdAt;
  String updatedAt;
  List<String> likes;
  List<Comment> comments;

  EngagementStats({
    this.id = '',
    this.postId = '',
    this.v = 0,
    this.createdAt = '',
    this.updatedAt = '',
    List<String>? likes,
    List<Comment>? comments,
  })  : likes = likes ?? [],
        comments = comments ?? [];

  factory EngagementStats.fromJson(Map<String, dynamic> json) {
    return EngagementStats(
      id: json['_id'] ?? '',
      postId: json['postId'] ?? '',
      v: json['__v'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List? ?? [])
          .map((e) => Comment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'postId': postId,
      '__v': v,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likes': likes,
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }
}

class Comment {
  String user;
  String text;

  Comment({
    this.user = '',
    this.text = '',
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'text': text,
    };
  }
}
