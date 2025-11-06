

import 'package:event_ease/engagment%20handle/comment_model.dart';

class PostDetailsModel {
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
  List<EventComment> comments;
  List<String> galleryImagePath = [];

  PostDetailsModel({
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
    this.galleryImagePath = const [],
    List<EventComment>? comments,
  })  : creator = creator ?? Creator(),
        comments = comments ?? [];

  factory PostDetailsModel.fromJson(Map<String, dynamic> json) {
    return PostDetailsModel(
      id: json['_id'] ?? '',
      creator: Creator.fromJson(json['creator'] ?? {}),
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
      galleryImagePath: (json['gallery'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      isLiked: json['isLiked'] ?? false,
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => EventComment.fromJson(e))
          .toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'creator': creator.toJson(),
  //     'title': title,
  //     'category': category,
  //     'region': region,
  //     'description': description,
  //     'image': image,
  //     'createdAt': createdAt,
  //     'updatedAt': updatedAt,
  //     '__v': v,
  //     'totalLikes': totalLikes,
  //     'totalComments': totalComments,
  //     'isLiked': isLiked,
  //     // 'comments': comments.map((e) => e.toJson()).toList(),
  //   };
  // }
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

class Comment {
  String text;
  CommentUser user;

  Comment({
    this.text = '',
    CommentUser? user,
  }) : user = user ?? CommentUser();

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'user': user.toJson(),
    };
  }
}

class CommentUser {
  String id;
  String name;
  String profileImage;

  CommentUser({
    this.id = '',
    this.name = '',
    this.profileImage = '',
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
    };
  }
}
