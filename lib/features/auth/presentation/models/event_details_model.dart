
class EventDetailsModel {
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
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final List<String> supportedServices;
  final List<String> additionalServices;
  final num maxParticipants;
  final num entranceFee;
  final String additionalNotes;
  final List<Faq> faq;
  final bool isSubscription;
  final String subscriptionType;
  final String? expireSubscriptionTime;
  final bool isDeleted;
  final List<dynamic> promotions;
  final List<dynamic> subscriptionList;
  final String createdAt;
  final String updatedAt;
  final double averageRating;
  final num totalReviews;
  num totalLikes;
  num totalComments;
  bool isLiked;
  bool isWishlisted;
  final bool blueVerifiedBadge;
  final List<Review> reviews;
  final Location location;

  EventDetailsModel({
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
    required this.isSubscription,
    required this.subscriptionType,
    required this.expireSubscriptionTime,
    required this.isDeleted,
    required this.promotions,
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
    required this.location,
    required this.isWishlisted,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['_id'],
      author: json['author'],
      name: json['name'],
      description: json['description'],
      detailDescription: json['detailDescription'],
      logo: json['logo'] ?? "",
      coverImage: json['coverImage'] ?? "",
      gallery: List<String>.from(
        json['gallery'].map((e) => e),
      ),
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      bookingAndPaymentLink: json['bookingAndPaymentLink'],
      address: json['address'],
      category: json['category'],
      type: json['type'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      supportedServices: List<String>.from(json['supportedServices']),
      additionalServices: List<String>.from(json['additionalServices']),
      maxParticipants: json['maxParticipants'],
      entranceFee: json['entranceFee'],
      additionalNotes: json['additionalNotes'],
      faq: List<Faq>.from(json['faq'].map((x) => Faq.fromJson(x))),
      isSubscription: json['isSubscription'],
      subscriptionType: json['subscriptionType'],
      expireSubscriptionTime: json['expireSubscriptionTime'],
      isDeleted: json['isDeleted'],
      promotions: List<dynamic>.from(json['promotions']),
      subscriptionList: List<dynamic>.from(json['subscriptionList']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      totalLikes: json['totalLikes'],
      totalComments: json['totalComments'],
      isLiked: json['isLiked'],
      blueVerifiedBadge: json['blueVerifiedBadge'],
      reviews: List<Review>.from(
        json['reviews'].map((x) => Review.fromJson(x)),
      ),
      location: Location.fromJson(json['location']),
      isWishlisted: json['isWishlisted'] ?? false,
    );
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(question: json['question'], answer: json['answer']);
  }
}

class Review {
  final String id;
  final ReviewUser userId;
  final num rating;
  final String comment;

  Review({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      userId: ReviewUser.fromJson(json['userId']),
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}

class ReviewUser {
  final String id;
  final String name;
  final String profileImage;

  ReviewUser({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['_id'],
      name: json['name'],
      profileImage: json['profileImage'] ?? "",
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(
        json['coordinates'].map((x) => (x ?? 90.0).toDouble()),
      ),
    );
  }
}
