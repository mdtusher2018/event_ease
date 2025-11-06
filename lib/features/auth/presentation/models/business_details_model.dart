import 'package:event_ease/features/auth/presentation/utils/business%20helper/bussiness_helper.dart';

class BusinessDetailModel {
  final String id;
  String author;
  final String name;
  final String description;
  final String detailDescription;
  final String logo;
  final String coverImage;
  final List<String> gallery;
  final String phoneNumber;
  final String email;
  final String website;
  final SocialLinks socialLinks;
  final Availability availabilities;
  final String address;
  final ProviderType providerType;
  final List<String> supportedServices;
  final List<String> additionalServices;
  final String priceRange;
  final num maxGuest;
  final List<Faq> faq;
  final bool isSubscription;
  final String subscriptionType;
  final String businessLevel;
  final bool isDeleted;
  final List<dynamic> promotionImage;
  final List<dynamic> subcriptionList;
  final String createdAt;
  final String updatedAt;
  final num averageRating;
  final num totalReviews;
   num totalFollowers;
   num totalLikes;
   num totalComments;
  final bool blueVerifiedBadge;
  bool isLiked;
  bool isFollowed;
  final String categoryName;
  final List<Review> reviews;
  final Location location;

  BusinessDetailModel({
    required this.id,
    this.author = "",
    required this.isLiked,
    required this.isFollowed,
    required this.name,
    required this.description,
    required this.detailDescription,
    required this.logo,
    required this.coverImage,
    required this.gallery,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.socialLinks,
    required this.availabilities,
    required this.address,
    required this.providerType,
    required this.supportedServices,
    required this.additionalServices,
    required this.priceRange,
    required this.maxGuest,
    required this.faq,
    required this.isSubscription,
    required this.subscriptionType,
    required this.businessLevel,
    required this.isDeleted,
    required this.promotionImage,
    required this.subcriptionList,
    required this.createdAt,
    required this.updatedAt,
    required this.averageRating,
    required this.totalReviews,
    required this.totalFollowers,
    required this.totalLikes,
    required this.totalComments,
    required this.blueVerifiedBadge,
    required this.categoryName,
    required this.reviews,
    required this.location,
  });

  factory BusinessDetailModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailModel(
      id: json['_id'],
      author: json['author'] ?? "",
      name: json['name']??"",
      isLiked: json["isLiked"] ?? false,
      isFollowed: json["isFollowed"] ?? false,
      description: json['description']??"",
      detailDescription: json['detailDescription']??"",
      logo: getFullImagePath(json['logo'] ?? ""),
      coverImage: json['coverImage']??"",
      gallery: List<String>.from(
        json['gallery'].map((e) => e??""),
      ),
      phoneNumber: json['phoneNumber']??"",
      email: json['email']??"",
      website: json['website']??"",
      socialLinks: SocialLinks.fromJson(json['socialLinks']??{}),
      availabilities: Availability.fromJson(json['availabilities']??{}),
      address: json['address'],
      providerType: ProviderType.fromJson(json['providerType']??{}),
      supportedServices: List<String>.from(json['supportedServices']??[]),
      additionalServices: List<String>.from(json['additionalServices']??[]),
      priceRange: json['priceRange']??"",
      maxGuest: json['maxGuest']??0,
      faq: List<Faq>.from(json['faq'].map((x) => Faq.fromJson(x??{}))),
      isSubscription: json['isSubscription']??false,
      subscriptionType: json['subscriptionType']??"",
      businessLevel: json['businessLevel']??"",
      isDeleted: json['isDeleted']??false,
      promotionImage: List<dynamic>.from(json['promotionImage']??[]),
      subcriptionList: List<dynamic>.from(json['subcriptionList']??[]),
      createdAt: json['createdAt']??"",
      updatedAt: json['updatedAt']??"",
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews']??0,
      totalFollowers: json['totalFollowers']??0,
      totalLikes: json['totalLikes']??0,
      totalComments: json['totalComments']??0,
      blueVerifiedBadge: json['blueVerifiedBadge']??false,
      categoryName: json['categoryName']??"",
      reviews: List<Review>.from(
        json['reviews'].map((x) => Review.fromJson(x??{})),
      ),
      location: Location.fromJson(json['location']??{}),
    );
  }
}

class SocialLinks {
  final String facebook;
  final String instagram;
  final String twitter;
  final String tiktok;

  SocialLinks({
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.tiktok,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      facebook: json['facebook']??"https://facebook.com",
      instagram: json['instagram']??"https://instagram.com",
      twitter: json['twitter']??"https://twitter.com",
      tiktok: json['tiktok']??"https://tiktok.com",
    );
  }
}

class Availability {
  final List<String> day;
  final String startTime;
  final String endTime;

  Availability({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      day: List<String>.from(json['day']??{}),
      startTime: json['startTime']??"",
      endTime: json['endTime']??"",
    );
  }
}

class ProviderType {
  final String id;
  final String name;

  ProviderType({required this.id, required this.name});

  factory ProviderType.fromJson(Map<String, dynamic> json) {
    return ProviderType(id: json['_id']??"", name: json['name']??"");
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(question: json['question']??"", answer: json['answer']??"");
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
      userId: ReviewUser.fromJson(json['userId']??{}),
      rating: json['rating'] as num,
      comment: json['comment']??"",
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
      id: json['_id']??"",
      name: json['name']??"",
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
      type: json['type']??"",
      coordinates: List<double>.from(
        json['coordinates'].map((x) => x.toDouble()),
      ),
    );
  }
}
