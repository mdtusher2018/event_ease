class ExtraEventData {
  final ExtraAuthor author;
  final List<Comment> comments;
  final List<ExtraEventModel> currentEvents;
  final List<ExtraEventModel> relatedEvents;
  bool  isInterested ;

  ExtraEventData({
    required this.author,
    required this.comments,
    required this.currentEvents,
    required this.relatedEvents,
    required this.isInterested
  });

  factory ExtraEventData.fromJson(Map<String, dynamic> json) {
    return ExtraEventData(
      author: ExtraAuthor.fromJson(json['author']),
      comments: List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x))),
      currentEvents: List<ExtraEventModel>.from(json['currentEvents'].map((x) => ExtraEventModel.fromJson(x))),
      relatedEvents: List<ExtraEventModel>.from(json['relatedEvents'].map((x) => ExtraEventModel.fromJson(x))),
      isInterested: json['isInterested']
    );
  }
}
class ExtraAuthor {
  final String name;
  final String surename;

  ExtraAuthor({
    required this.name,
    required this.surename,
  });

  factory ExtraAuthor.fromJson(Map<String, dynamic> json) {
    return ExtraAuthor(
      name: json['name'] ?? '',
      surename: json['surename'] ?? '',
    );
  }
}
class Comment {
  final ExtraCommentUser user;
  final String text;

  Comment({
    required this.user,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: ExtraCommentUser.fromJson(json['user']),
      text: json['text'] ?? '',
    );
  }
}
class ExtraCommentUser {
  final String id;
  final String name;
  final String profileImage;

  ExtraCommentUser({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory ExtraCommentUser.fromJson(Map<String, dynamic> json) {
    return ExtraCommentUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
class ExtraEventModel {
  final String id;
  final String author;
  final String name;
  final String description;
  final String detailDescription;
  final String logo;
  final String coverImage;
  final List<String> gallery;
  final String phoneNumber;
  final String email;
  final String bookingAndPaymentLink;
  final String address;
  final String category;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final List<String> supportedServices;
  final List<String> additionalServices;
  final int maxParticipants;
  final int entranceFee;
  final String additionalNotes;
  final List<ExtraFaq> faq;
  final List<String> promotions;
  final bool isSubscription;
  final String subscriptionType;
  final DateTime? expireSubscriptionTime;
  final bool isActive;
  final bool isDeleted;
  final List<dynamic> subscriptionList;
  final String createdAt;
  final String updatedAt;
  final num averageRating;
   int totalReviews;
   int totalLikes;
   int totalComments;
   bool isLiked;
   bool isWishlisted;
  final bool blueVerifiedBadge;
  final List<dynamic> reviews;

  ExtraEventModel({
    required this.id,
    required this.author,
    required this.name,
    required this.description,
    required this.detailDescription,
    required this.logo,
    required this.coverImage,
    required this.gallery,
    required this.phoneNumber,
    required this.email,
    required this.bookingAndPaymentLink,
    required this.address,
    required this.category,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.supportedServices,
    required this.additionalServices,
    required this.maxParticipants,
    required this.entranceFee,
    required this.additionalNotes,
    required this.faq,
    required this.promotions,
    required this.isSubscription,
    required this.subscriptionType,
    required this.expireSubscriptionTime,
    required this.isActive,
    required this.isDeleted,
    required this.subscriptionList,
    required this.createdAt,
    required this.updatedAt,
    required this.averageRating,
    required this.totalReviews,
    required this.totalLikes,
    required this.totalComments,
    required this.isLiked,
    required this.blueVerifiedBadge,
    required this.reviews,
    required this.isWishlisted
  });

  factory ExtraEventModel.fromJson(Map<String, dynamic> json) {
    return ExtraEventModel(
      id: json['_id'] ?? '',
      author: json['author'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      detailDescription: json['detailDescription'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['coverImage'] ?? '',
      gallery: List<String>.from(json['gallery'] ?? []),
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      bookingAndPaymentLink: json['bookingAndPaymentLink'] ?? '',
      address: json['address'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      supportedServices: List<String>.from(json['supportedServices'] ?? []),
      additionalServices: List<String>.from(json['additionalServices'] ?? []),
      maxParticipants: json['maxParticipants'] ?? 0,
      entranceFee: json['entranceFee'] ?? 0,
      additionalNotes: json['additionalNotes'] ?? '',
      faq: List<ExtraFaq>.from(json['faq']?.map((x) => ExtraFaq.fromJson(x)) ?? []),
      promotions: List<String>.from(json['promotions'] ?? []),
      isSubscription: json['isSubscription'] ?? false,
      subscriptionType: json['subscriptionType'] ?? '',
      expireSubscriptionTime: json['expireSubscriptionTime'] != null
          ? DateTime.tryParse(json['expireSubscriptionTime'])
          : null,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      subscriptionList: List<dynamic>.from(json['subscriptionList'] ?? []),
      createdAt: json['createdAt']??"",
      updatedAt: json['updatedAt']??"",
      averageRating: json['averageRating'] ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      reviews: List<dynamic>.from(json['reviews'] ?? []),
      isWishlisted: json['isWishlisted']??false
    );
  }
}
class ExtraFaq {
  final String question;
  final String answer;
  final String id;

  ExtraFaq({
    required this.question,
    required this.answer,
    required this.id,
  });

  factory ExtraFaq.fromJson(Map<String, dynamic> json) {
    return ExtraFaq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
