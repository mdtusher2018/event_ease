class CommentModel {
  final String text;
  final CommentUser user;

  CommentModel({
    this.text = '',
    CommentUser? user,
  }) : user = user ?? CommentUser();

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
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

  @override
  String toString() {
    return 'CommentModel(text: $text, user: $user)';
  }
}

class CommentUser {
  final String id;
  final String name;
  final String profileImage;

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

  @override
  String toString() {
    return 'CommentUser(id: $id, name: $name, profileImage: $profileImage)';
  }
}
