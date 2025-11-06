class WizardModel {
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
  final String website;
  final SocialLinks socialLinks;
  final Availability availabilities;
  final String address;
  final ProviderType providerType;
  final List<String> supportedServices;
  final List<String> additionalServices;
  final String priceRange;
  final int maxGuest;
  final List<FAQ> faq;
  final String businessLevel;
  final bool isSubscription;
  final String subscriptionType;
  final String? expireSubscriptionTime;
  final bool isDeleted;
  final List<String> promotionImage;
  final List<String> subcriptionList;
  final String createdAt;
  final String updatedAt;
  final List<String> advertisingCreditsList;
  final num rating;
  late int totalLikes;
  final int totalComments;
  late bool isLiked;
  final bool isFollowed;
  final bool blueVerifiedBadge;
  final String type;
  bool isWishlisted;
  final Location location;
  final int totalAdvertisingCredits;

  WizardModel({
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
    this.socialLinks = const SocialLinks(),
    this.availabilities = const Availability(),
    this.address = '',
    this.providerType = const ProviderType(),
    this.supportedServices = const [],
    this.additionalServices = const [],
    this.priceRange = '',
    this.maxGuest = 0,
    this.faq = const [],
    this.businessLevel = '',
    this.isSubscription = false,
    this.subscriptionType = '',
    this.expireSubscriptionTime,
    this.isDeleted = false,
    this.promotionImage = const [],
    this.subcriptionList = const [],
    this.createdAt = '',
    this.updatedAt = '',
    this.advertisingCreditsList = const [],
    this.rating =  0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    this.isFollowed = false,
    this.blueVerifiedBadge = false,
    this.type = '',
    required this.isWishlisted,
    this.location = const Location(),
    this.totalAdvertisingCredits = 0,
  });

  factory WizardModel.fromJson(Map<String, dynamic> json) {
    return WizardModel(
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
      availabilities: Availability.fromJson(json['availabilities'] ?? {}),
      address: json['address'] ?? '',
      providerType: ProviderType.fromJson(json['providerType'] ?? {}),
      supportedServices: List<String>.from(json['supportedServices'] ?? []),
      additionalServices: List<String>.from(json['additionalServices'] ?? []),
      priceRange: json['priceRange'] ?? '',
      maxGuest: json['maxGuest'] ?? 0,
      faq:
          (json['faq'] as List<dynamic>?)
              ?.map((e) => FAQ.fromJson(e))
              .toList() ??
          [],
      businessLevel: json['businessLevel'] ?? '',
      isSubscription: json['isSubscription'] ?? false,
      subscriptionType: json['subscriptionType'] ?? '',
      expireSubscriptionTime: json['expireSubscriptionTime'],
      isDeleted: json['isDeleted'] ?? false,
      promotionImage: List<String>.from(json['promotionImage'] ?? []),
      subcriptionList: List<String>.from(json['subcriptionList'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      advertisingCreditsList: List<String>.from(
        json['advertisingCreditsList'] ?? [],
      ),
      
      rating: json['rating'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      type: json['type'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      totalAdvertisingCredits: json['totalAdvertisingCredits'] ?? 0,
      isWishlisted: json['isWishlisted']??false
    );
  }

  @override
  String toString() {
    return 'WizardModel(name: $name, type: $type, priceRange: $priceRange)';
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

class Availability {
  final List<String> day;
  final String startTime;
  final String endTime;

  const Availability({
    this.day = const [],
    this.startTime = '',
    this.endTime = '',
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      day: List<String>.from(json['day'] ?? []),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}

class ProviderType {
  final String id;
  final String name;
  final String type;
  final String description;
  final String icon;
  final String banner;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  const ProviderType({
    this.id = '',
    this.name = '',
    this.type = '',
    this.description = '',
    this.icon = '',
    this.banner = '',
    this.isDeleted = false,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ProviderType.fromJson(Map<String, dynamic> json) {
    return ProviderType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      banner: json['banner'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class FAQ {
  final String question;
  final String answer;
  final String id;

  const FAQ({this.question = '', this.answer = '',this.id = ''});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(question: json['question'] ?? '', answer: json['answer'] ?? '', id: json['_id'] ?? '');
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  const Location({this.type = 'Point', this.coordinates = const [0.0, 0.0]});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates:
          (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [0.0, 0.0],
    );
  }
}
