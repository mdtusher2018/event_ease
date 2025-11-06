class BusinessProfileModel {
  final String id;
  final String author;
  String name;
  String description;
  String detailDescription;
  String logo;
  String coverImage;
  List<String> gallery;
  String phoneNumber;
  String email;
  String website;
  SocialLinks socialLinks;
  final Availabilities availabilities;
  final String address;
  final String providerType;
  final List<String> supportedServices;
  final List<String> additionalServices;
  final String priceRange;
  final int maxGuest;
   List<FaqItem> faq;
  final String businessLevel;
  final bool isSubscription;
  final String subscriptionType;
  final String createdAt;
  final String updatedAt;
   List<String> promotionImage;
  final List<dynamic> subcriptionList;
  final int totalAdvertisingCredits;
  final bool isDeleted;
  final Location location;

  BusinessProfileModel({
    this.id = '',
    this.author = '',
    this.name = '',
    this.description = '',
    this.detailDescription = '',
    this.logo = '',
    this.coverImage = '',
    this.gallery = const [],
    this.phoneNumber = '',
    this.email = '',
    this.website = '',
    this.socialLinks = const SocialLinks(), // ✅ FIXED HERE
    this.availabilities = const Availabilities(),
    this.address = '',
    this.providerType = '',
    this.supportedServices = const [],
    this.additionalServices = const [],
    this.priceRange = '',
    this.maxGuest = 0,
    this.faq = const [],
    this.businessLevel = '',
    this.isSubscription = false,
    this.subscriptionType = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.promotionImage = const [],
    this.subcriptionList = const [],
    this.totalAdvertisingCredits = 0,
    this.isDeleted = false,
    this.location = const Location(),
  });

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    return BusinessProfileModel(
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
      website: json['website'] ?? '',
      socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
      availabilities: Availabilities.fromJson(json['availabilities'] ?? {}),
      address: json['address'] ?? '',
      providerType: json['providerType'] ?? '',
      supportedServices: List<String>.from(json['supportedServices'] ?? []),
      additionalServices: List<String>.from(json['additionalServices'] ?? []),
      priceRange: json['priceRange'] ?? '',
      maxGuest: json['maxGuest'] ?? 0,
      faq: (json['faq'] as List<dynamic>? ?? []).map((e) => FaqItem.fromJson(e)).toList(),
      businessLevel: json['businessLevel'] ?? '',
      isSubscription: json['isSubscription'] ?? false,
      subscriptionType: json['subscriptionType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      promotionImage: List<String>.from(json['promotionImage'] ?? []),
      subcriptionList: json['subcriptionList'] ?? [],
      totalAdvertisingCredits: json['totalAdvertisingCredits'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      location: Location.fromJson(json['location'] ?? {}),
    );
  }
}


class SocialLinks {
  final String facebook;
  final String instagram;
  final String twitter;
  final String tiktok;

  const SocialLinks({
    this.facebook = '',
    this.instagram = '',
    this.twitter = '',
    this.tiktok = '',
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


class Availabilities {
  final List<String> day;
  final String startTime;
  final String endTime;

  const Availabilities({
    this.day = const [],
    this.startTime = '',
    this.endTime = '',
  });

  factory Availabilities.fromJson(Map<String, dynamic> json) {
    return Availabilities(
      day: List<String>.from(json['day'] ?? []),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    this.question = '',
    this.answer = '',
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  const Location({
    this.type = 'Point',
    this.coordinates = const [0.0, 0.0],
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from((json['coordinates'] ?? [0.0, 0.0]).map((e) => e.toDouble())),
    );
  }
}
