class PollModel {
  String id;
  Creator creator;
  String title;
  String category;
  String region;
  String description;
  List<Option> options;
  String createdAt;
  int totalVotes;

  PollModel({
    this.id = '',
    Creator? creator,
    this.title = '',
    this.category = '',
    this.region = '',
    this.description = '',
    List<Option>? options,
    this.createdAt = '',
    this.totalVotes = 0,
  })  : creator = creator ?? Creator(),
        options = options ?? [];

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      id: json['_id'] ?? '',
      creator: Creator.fromJson(json['creator'] ?? {}),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      region: json['region'] ?? '',
      description: json['description'] ?? '',
      options: (json['options'] as List? ?? [])
          .map((e) => Option.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      totalVotes: json['totalVotes'] ?? 0,
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
      'options': options.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'totalVotes': totalVotes,
    };
  }
}

class Creator {
  String id;
  String name;
  String profileImage;

  Creator({
    this.id = '',
    this.name = '',
    this.profileImage = '',
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
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

class Option {
  String text;
  int voteCount;
  int percentage;
  bool isVoted;

  Option({
    this.text = '',
    this.voteCount = 0,
    this.percentage = 0,
    this.isVoted = false,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'] ?? '',
      voteCount: json['voteCount'] ?? 0,
      percentage: json['percentage'] ?? 0,
      isVoted: json['isVoted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'voteCount': voteCount,
      'percentage': percentage,
      'isVoted': isVoted,
    };
  }
}
