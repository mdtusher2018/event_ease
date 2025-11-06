class ExtraBusinessModel {
  List<Event> currentEvents;
  List<Event> pastEvents;
  List<InspirationBlog> inspirationBlogs;
  List<Comment> comments;
  List<RelatedBusiness> relatedBusinesses;

  ExtraBusinessModel({
    this.currentEvents = const [],
    this.pastEvents = const [],
    this.inspirationBlogs = const [],
    this.comments = const [],
    this.relatedBusinesses = const [],
  });

  factory ExtraBusinessModel.fromJson(Map<String, dynamic> json) {
    return ExtraBusinessModel(
      currentEvents: List<Event>.from(
        (json['currentEvents'] ?? []).map((e) => Event.fromJson(e)),
      ),
      pastEvents: List<Event>.from(
        (json['pastEvents'] ?? []).map((e) => Event.fromJson(e)),
      ),
      inspirationBlogs: List<InspirationBlog>.from(
        (json['inspirationBlogs'] ?? []).map((e) => InspirationBlog.fromJson(e)),
      ),
      comments: List<Comment>.from(
        (json['comments'] ?? []).map((e) => Comment.fromJson(e)),
      ),
      relatedBusinesses: List<RelatedBusiness>.from(
        (json['relatedBusinesses'] ?? []).map((e) => RelatedBusiness.fromJson(e)),
      ),
    );
  }
}

class Event {
  String id;
  String name;
  String description;
  String detailDescription;
  String logo;
  String coverImage;
  List<String> gallery;
  String phoneNumber;
  String email;
  String bookingAndPaymentLink;
  String address;
  String category;
  String type;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  List<String> supportedServices;
  List<String> additionalServices;
  num maxParticipants;
  num entranceFee;
  String additionalNotes;
  List<Faq> faq;
  bool isSubscription;
  String subscriptionType;
  bool isDeleted;
  num averageRating;
  num totalReviews;
  num totalLikes;
  num totalComments;
  bool isLiked;
  bool isWishlisted;
  bool blueVerifiedBadge;
  List<dynamic> reviews;
  List<dynamic> promotions;
  List<dynamic> subscriptionList;

  Event({
    this.id = '',
    this.name = '',
    this.description = '',
    this.detailDescription = '',
    this.logo = '',
    this.coverImage = '',
    this.gallery = const [],
    this.phoneNumber = '',
    this.email = '',
    this.bookingAndPaymentLink = '',
    this.address = '',
    this.category = '',
    this.type = '',
    this.startDate = '',
    this.endDate = '',
    this.startTime = '',
    this.endTime = '',
    this.supportedServices = const [],
    this.additionalServices = const [],
    this.maxParticipants = 0,
    this.entranceFee = 0,
    this.additionalNotes = '',
    this.faq = const [],
    this.isSubscription = false,
    this.subscriptionType = 'none',
    this.isDeleted = false,
    this.averageRating = 0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    this.blueVerifiedBadge = false,
    this.reviews = const [],
    this.promotions = const [],
    this.subscriptionList = const [],
    required this.isWishlisted
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
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
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      supportedServices: List<String>.from(json['supportedServices'] ?? []),
      additionalServices: List<String>.from(json['additionalServices'] ?? []),
      maxParticipants: json['maxParticipants'] ?? 0,
      entranceFee: json['entranceFee'] ?? 0,
      additionalNotes: json['additionalNotes'] ?? '',
      faq: List<Faq>.from((json['faq'] ?? []).map((e) => Faq.fromJson(e))),
      isSubscription: json['isSubscription'] ?? false,
      subscriptionType: json['subscriptionType'] ?? 'none',
      isDeleted: json['isDeleted'] ?? false,
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      reviews: List<dynamic>.from(json['reviews'] ?? []),
      promotions: List<dynamic>.from(json['promotions'] ?? []),
      subscriptionList: List<dynamic>.from(json['subscriptionList'] ?? []),
      isWishlisted: json['isWishlisted']??false
    );
  }
}

class Faq {
  String question;
  String answer;

  Faq({
    this.question = '',
    this.answer = '',
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class InspirationBlog {
  String id;
  String title;
  String category;
  String description;
  String coverImage;
  String createdAt;

  InspirationBlog({
    this.id = '',
    this.title = '',
    this.category = '',
    this.description = '',
    this.coverImage = '',
    this.createdAt = '',
  });

  factory InspirationBlog.fromJson(Map<String, dynamic> json) {
    return InspirationBlog(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class Comment {
  User user;
  String text;

  Comment({
    this.user = const User(),
    this.text = '',
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: User.fromJson(json['user'] ?? {}),
      text: json['text'] ?? '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String profileImage;

  const User({
    this.id = '',
    this.name = '',
    this.profileImage = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class RelatedBusiness {
  String id;
  String name;
  String coverImage;
  String address;
  String priceRange;
  num maxGuest;
  String subscriptionType;
  num totalFollowers;
  num totalLikes;
  num totalComments;
  bool isLiked;
  bool isFollowed;
  bool blueVerifiedBadge;
  num averageRating;
  num totalReviews;
  bool isWishlisted;

  RelatedBusiness({
    this.id = '',
    this.name = '',
    this.coverImage = '',
    this.address = '',
    this.priceRange = '',
    this.maxGuest = 0,
    this.subscriptionType = '',
    this.totalFollowers = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    this.isFollowed = false,
    this.blueVerifiedBadge = false,
    this.averageRating = 0,
    this.totalReviews = 0,
    required this.isWishlisted,
  });

  factory RelatedBusiness.fromJson(Map<String, dynamic> json) {
    return RelatedBusiness(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      address: json['address'] ?? '',
      priceRange: json['priceRange'] ?? '',
      maxGuest: json['maxGuest'] ?? 0,
      subscriptionType: json['subscriptionType'] ?? '',
      totalFollowers: json['totalFollowers'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      isWishlisted: json['isWishlisted']??false
    );
  }
}

