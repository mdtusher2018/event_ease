class JobDetailModel {
  final String id;
  final JobAuthor author;
  final String title;
  final String description;
  final String logo;
  final String coverImage;
  final List<String> gallery;
  final String phoneNumber;
  final String email;
  final String category;
  final String address;
  final String role;
  final String contractType;
  final int salery;
  final String experience;
  final String availability;
  final int workHour;
  final bool isSubscription;
  final String subscriptionType;
  final String? expireSubscriptionTime;
  final bool isActive;
  final bool isDeleted;
  final List<String> subscriptionList;
  final String createdAt;
  final String updatedAt;
  final int averageRating;
  final int totalReviews;
  final int totalComments;
  final List<JobComment> comments;
  final List<JobFaq> faq;
  final List<RelatedJobModel> relatedJobs;
  final double latitude;
  final double longitude;

  JobDetailModel({
    this.id = '',
    required this.author,
    this.title = '',
    this.description = '',
    this.logo = '',
    this.coverImage = '',
    this.gallery = const [],
    this.phoneNumber = '',
    this.email = '',
    this.category = '',
    this.address = '',
    this.role = '',
    this.contractType = '',
    this.salery = 0,
    this.experience = '',
    this.availability = '',
    this.workHour = 0,
    this.isSubscription = false,
    this.subscriptionType = '',
    this.expireSubscriptionTime,
    this.isActive = false,
    this.isDeleted = false,
    this.subscriptionList = const [],
    this.createdAt = '',
    this.updatedAt = '',
    this.averageRating = 0,
    this.totalReviews = 0,
    this.totalComments = 0,
    this.comments = const [],
    this.faq = const [],
    this.relatedJobs = const [],
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory JobDetailModel.fromJson(Map<String, dynamic> json) {
    final location = json['location']?['coordinates'] ?? [0.0, 0.0];

    return JobDetailModel(
      id: json['_id'] ?? '',
      author: JobAuthor.fromJson(json['author'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['coverImage'] ?? '',
      gallery: List<String>.from(json['gallery'] ?? []),
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? '',
      contractType: json['contractType'] ?? '',
      salery: json['salery'] ?? 0,
      experience: json['experience'] ?? '',
      availability: json['availability'] ?? '',
      workHour: json['workHour'] ?? 0,
      isSubscription: json['isSubscription'] ?? false,
      subscriptionType: json['subscriptionType'] ?? '',
      expireSubscriptionTime: json['expireSubscriptionTime'],
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      subscriptionList: List<String>.from(json['subscriptionList'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => JobComment.fromJson(e))
          .toList(),
      faq: (json['faq'] as List<dynamic>? ?? [])
          .map((e) => JobFaq.fromJson(e))
          .toList(),
      relatedJobs: (json['relatedJobs'] as List<dynamic>? ?? [])
          .map((e) => RelatedJobModel.fromJson(e))
          .toList(),
      longitude: (location.isNotEmpty && location[0] is num) ? location[0].toDouble() : 0.0,
      latitude: (location.length > 1 && location[1] is num) ? location[1].toDouble() : 0.0,
    );
  }
}

class JobAuthor {
  final String id;
  final String name;
  final String sureName;

  JobAuthor({
    this.id = '',
    this.name = '',
    this.sureName = '',
  });

  factory JobAuthor.fromJson(Map<String, dynamic> json) {
    return JobAuthor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      sureName: json['sureName'] ?? '',
    );
  }
}

class JobFaq {
  final String id;
  final String question;
  final String answer;

  JobFaq({
    this.id = '',
    this.question = '',
    this.answer = '',
  });

  factory JobFaq.fromJson(Map<String, dynamic> json) {
    return JobFaq(
      id: json['_id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class JobComment {
  final String text;
  final String? createdAt;
  final JobUser user;

  JobComment({
    required this.text,
    this.createdAt,
    required this.user,
  });

  factory JobComment.fromJson(Map<String, dynamic> json) {
    return JobComment(
      text: json['text'] ?? '',
      createdAt: json['createdAt'],
      user: JobUser.fromJson(json['user'] ?? {}),
    );
  }
}

class JobUser {
  final String id;
  final String name;
  final String profileImage;

  JobUser({
    this.id = '',
    this.name = '',
    this.profileImage = '',
  });

  factory JobUser.fromJson(Map<String, dynamic> json) {
    return JobUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class RelatedJobModel {
  final String id;
  final String title;
  final String logo;
  final String coverImage;
  final String category;
  final String address;

  RelatedJobModel({
    this.id = '',
    this.title = '',
    this.logo = '',
    this.coverImage = '',
    this.category = '',
    this.address = '',
  });

  factory RelatedJobModel.fromJson(Map<String, dynamic> json) {
    return RelatedJobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['coverImage'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
