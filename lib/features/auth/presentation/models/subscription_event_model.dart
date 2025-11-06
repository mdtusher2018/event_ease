import 'package:event_ease/features/auth/presentation/models/pasination_model.dart';

class AllEventResponseModel {
  final List<EventModel> data;
  final Meta meta;

  AllEventResponseModel({required this.data, required this.meta});

  factory AllEventResponseModel.fromJson(Map<String, dynamic> json) {
    return AllEventResponseModel(
      data: List<EventModel>.from(
        json['data'].map((x) => EventModel.fromJson(x)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class EventModel {
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
  final int maxParticipants;
  final int entranceFee;
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
  final int averageRating;
  int totalReviews;
  int totalLikes;
  int totalComments;
  bool blueVerifiedBadge;

  bool isLiked;
  bool isWishlisted;
  final Location location;

  EventModel({
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
    required this.blueVerifiedBadge,
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
    required this.location,
    required this.isWishlisted
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      author: json['author'],
      name: json['name'],
      description: json['description'],
      blueVerifiedBadge: json['blueVerifiedBadge']??false,
      detailDescription: json['detailDescription'],
      logo: json['logo'],
      coverImage: json['coverImage'] ?? "",
      gallery: List<String>.from(json['gallery']),
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
      maxParticipants: parseInt(json['maxParticipants']),
      entranceFee: parseInt(json['entranceFee']),
      additionalNotes: json['additionalNotes'],
      faq: List<Faq>.from(json['faq'].map((x) => Faq.fromJson(x))),
      isSubscription: json['isSubscription'],
      subscriptionType: json['subscriptionType'],
      expireSubscriptionTime: json['expireSubscriptionTime'],
      isDeleted: json['isDeleted'],
      promotions: json['promotions'],
      subscriptionList: json['subscriptionList'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      averageRating: parseInt(json['averageRating']),
      totalReviews: parseInt(json['totalReviews']),
      totalLikes: parseInt(json['totalLikes']),
      totalComments: parseInt(json['totalComments']),
      isLiked: json['isLiked'] ?? false,
      location: Location.fromJson(json['location']??{}),
      isWishlisted: json['isWishlisted']??false
    );
  }
}

class Faq {
  final String question;
  final String answer;
  final String id;

  Faq({required this.question, required this.answer, required this.id});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'],
      answer: json['answer'],
      id: json['_id'],
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
        json['coordinates'].map((x) =>(x==null)?0.0: x.toDouble()),
      ),
    );
  }
}

// Helper to handle int/double from JSON
int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is num) return value.toInt();
  return 0;
}
