class MyBusinessModel {
  final String id;
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
  final Availabilities availabilities;
  final String address;
  final ProviderType providerType;
  final List<String> supportedServices;
  final List<String> additionalServices;
  final String priceRange;
  final num maxGuest;
  final List<Faq> faq;
  final String businessLevel;
  final bool isSubscription;
  final String subscriptionType;
  final DateTime? expireSubscriptionTime;
  final bool isDeleted;
  final List<dynamic> promotionImage;
  final List<dynamic> subcriptionList;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> advertisingCreditsList;
  final num averageRating;
  final num totalReviews;
  final num totalFollowers;
  final num totalLikes;
  final num totalComments;
  final bool isLiked;
  final bool isFollowed;
  final bool blueVerifiedBadge;
  final String categoryName;
  final List<Review> reviews;
  final Location location;
  final num totalAdvertisingCredits;
  final String author;
  bool? isActive;

  MyBusinessModel({
    required this.id,
    this.isActive,
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
    required this.businessLevel,
    required this.isSubscription,
    required this.subscriptionType,
    required this.expireSubscriptionTime,
    required this.isDeleted,
    required this.promotionImage,
    required this.subcriptionList,
    required this.createdAt,
    required this.updatedAt,
    required this.advertisingCreditsList,
    required this.averageRating,
    required this.totalReviews,
    required this.totalFollowers,
    required this.totalLikes,
    required this.totalComments,
    required this.isLiked,
    required this.isFollowed,
    required this.blueVerifiedBadge,
    required this.categoryName,
    required this.reviews,
    required this.location,
    required this.totalAdvertisingCredits,
    required this.author,
  });
factory MyBusinessModel.fromJson(Map<String, dynamic> json) => MyBusinessModel(
      id: json['_id'] ?? "N/A",
      name: json['name'] ?? "N/A",
      isActive: json['isActive']??true,
      description: json['description'] ?? "N/A",
      detailDescription: json['detailDescription'] ?? "N/A",
      logo: json['logo'] ?? "N/A",
      coverImage: json['coverImage'] ?? "N/A",
      gallery: List<String>.from((json['gallery'] ?? []).map((x) => x.toString())),
      phoneNumber: json['phoneNumber'] ?? "N/A",
      email: json['email'] ?? "N/A",
      website: json['website'] ?? "N/A",
      socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
      availabilities: Availabilities.fromJson(json['availabilities'] ?? {}),
      address: json['address'] ?? "N/A",
      providerType: ProviderType.fromJson(json['providerType'] ?? {}),
      supportedServices: List<String>.from((json['supportedServices'] ?? []).map((x) => x.toString())),
      additionalServices: List<String>.from((json['additionalServices'] ?? []).map((x) => x.toString())),
      priceRange: json['priceRange'] ?? "N/A",
      maxGuest: json['maxGuest'] ?? 0,
      faq: (json['faq'] as List? ?? []).map((x) => Faq.fromJson(x)).toList(),
      businessLevel: json['businessLevel'] ?? "N/A",
      isSubscription: json['isSubscription'] ?? false,
      subscriptionType: json['subscriptionType'] ?? "N/A",
      expireSubscriptionTime: json['expireSubscriptionTime'] != null
          ? DateTime.tryParse(json['expireSubscriptionTime'])
          : null,
      isDeleted: json['isDeleted'] ?? false,
    promotionImage: (json['promotionImage'] as List? ?? [])
    .map((e) => e.toString())
    .toList(),

      subcriptionList: List<dynamic>.from(json['subcriptionList'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? "N/A") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? "N/A") ?? DateTime.now(),
      advertisingCreditsList: List<dynamic>.from(json['advertisingCreditsList'] ?? []),
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      totalFollowers: json['totalFollowers'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      categoryName: json['categoryName'] ?? "N/A",
      reviews: (json['reviews'] as List? ?? []).map((x) => Review.fromJson(x)).toList(),
      location: Location.fromJson(json['location'] ?? {'type': 'Ponum', 'coordinates': [0.0, 0.0]}),
      totalAdvertisingCredits: json['totalAdvertisingCredits'] ?? 0,
      author: json['author'] ?? "N/A",
    );


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

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
    facebook: json['facebook']??"https://facebook.com",
      instagram: json['instagram']??"https://instagram.com",
      twitter: json['twitter']??"https://twitter.com",
      tiktok: json['tiktok']??"https://tiktok.com",
      );
}


class Availabilities {
  final List<String> day;
  final String startTime;
  final String endTime;

  Availabilities({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Availabilities.fromJson(Map<String, dynamic> json) => Availabilities(
        day: List<String>.from((json['day'] ?? []).map((x) => x.toString())),
        startTime: json['startTime'] ?? "N/A",
        endTime: json['endTime'] ?? "N/A",
      );
}


class ProviderType {
  final String id;
  final String name;

  ProviderType({required this.id, required this.name});

  factory ProviderType.fromJson(Map<String, dynamic> json) => ProviderType(
        id: json['_id'] ?? "N/A",
        name: json['name'] ?? "N/A",
      );
}

class Faq {
  final String question;
  final String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        question: json['question'] ?? "N/A",
        answer: json['answer'] ?? "N/A",
      );
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

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['_id'] ?? "N/A",
        userId: ReviewUser.fromJson(json['userId'] ?? {}),
        rating: json['rating'] ?? 0,
        comment: json['comment'] ?? "N/A",
      );
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

  factory ReviewUser.fromJson(Map<String, dynamic> json) => ReviewUser(
        id: json['_id'] ?? "N/A",
        name: json['name'] ?? "N/A",
        profileImage: json['profileImage'] ?? "N/A",
      );
}


class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json['type'] ?? "Ponum",
        coordinates: List<double>.from((json['coordinates'] ?? [0.0, 0.0]).map((x) => (x ?? 0).toDouble())),
      );
}

