
class MyEventModel {
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
  final num maxParticipants;
  final num entranceFee;
  final String additionalNotes;
  final List<Faq> faq;
  final bool isSubscription;
  final String subscriptionType;
  final dynamic expireSubscriptionTime;
  final bool isDeleted;
  final List<dynamic> promotions;
  final List<dynamic> subscriptionList;
  final DateTime createdAt;
  final DateTime updatedAt;
  final num averageRating;
  final num totalReviews;
  final num totalLikes;
  final num totalComments;
  final bool isLiked;
  final bool blueVerifiedBadge;
  final List<dynamic> reviews;
  final Location location;
  bool? isActive;

  MyEventModel({
    required this.id,
    this.isActive,
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
  });

  factory MyEventModel.fromJson(Map<String, dynamic> json) {
    return MyEventModel(
      id: json['_id']??"",
      author: json['author']??"",
      isActive: json['isActive']??false,
      name: json['name']??"",
      description: json['description']??"",
      detailDescription: json['detailDescription']??"",
      logo: json['logo']??"",
      coverImage: json['coverImage']??"",
      gallery: List<String>.from((json['gallery'] ?? []).map((x) => x.toString())),
      phoneNumber: json['phoneNumber']??"",
      email: json['email']??"",
      bookingAndPaymentLink: json['bookingAndPaymentLink']??"",
      address: json['address']??"",
      category: json['category']??"",
      type: json['type']??"",
      startDate: DateTime.parse(json['startDate']??"2025-07-20T00:00:00.000Z"),
      endDate: DateTime.parse(json['endDate']??"2025-07-20T00:00:00.000Z"),
      startTime: json['startTime']??"",
      endTime: json['endTime']??"",
      supportedServices: List<String>.from(json['supportedServices']??""),
      additionalServices: List<String>.from(json['additionalServices']??""),
      maxParticipants: json['maxParticipants']??0,
      entranceFee: json['entranceFee']??0,
      additionalNotes: json['additionalNotes']??"",
      faq: List<Faq>.from(json['faq'].map((x) => Faq.fromJson(x))),
      isSubscription: json['isSubscription']??false,
      subscriptionType: json['subscriptionType']??"",
      expireSubscriptionTime: json['expireSubscriptionTime'],
      isDeleted: json['isDeleted']??false,
      promotions: json['promotions']??[""],
      subscriptionList: json['subscriptionList']??[""],
      createdAt: DateTime.parse(json['createdAt']??""),
      updatedAt: DateTime.parse(json['updatedAt']??""),
      averageRating: json['averageRating']??0,
      totalReviews: json['totalReviews']??0,
      totalLikes: json['totalLikes']??0,
      totalComments: json['totalComments']??0,
      isLiked: json['isLiked']??false,
      blueVerifiedBadge: json['blueVerifiedBadge']??false,
      reviews: json['reviews']??[],
      location: Location.fromJson(json['location']),
    );
  }
}

class Faq {
  final String question;
  final String answer;
  final String id;

  Faq({
    required this.question,
    required this.answer,
    required this.id,
  });

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

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) =>(x==null)?0.0:  (x as num).toDouble())),
    );
  }
}
