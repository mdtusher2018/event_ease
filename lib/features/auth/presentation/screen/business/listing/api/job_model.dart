class JobModel {
  final String id;
  final String author;
  final String title;
  final String description;
  final String logo;
  final String coverImage;
  final List<String> gallery;
  final String phoneNumber;
  final String email;
  final String categoryId;
  final String category;
  final String address;
  final String role;
  final String contractType;
  final num salery;
  final String experience;
  final String availability;
  final num workHour;
  final bool isSubscription;
  final String subscriptionType;
  final dynamic expireSubscriptionTime;
   bool isActive;
  final bool isDeleted;
  final List<dynamic> faq;
  final List<dynamic> subscriptionList;
  final String createdAt;
  final String updatedAt;
  final num averageRating;
  final num totalReviews;
  final num totalComments;
  final List<dynamic> comments;
  final Location location;
  final List<RelatedJob> relatedJobs;

  JobModel({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.logo,
    required this.coverImage,
    required this.gallery,
    required this.phoneNumber,
    required this.email,
    required this.categoryId,
    required this.category,
    required this.address,
    required this.role,
    required this.contractType,
    required this.salery,
    required this.experience,
    required this.availability,
    required this.workHour,
    required this.isSubscription,
    required this.subscriptionType,
    required this.expireSubscriptionTime,
    required this.isActive,
    required this.isDeleted,
    required this.faq,
    required this.subscriptionList,
    required this.createdAt,
    required this.updatedAt,
    required this.averageRating,
    required this.totalReviews,
    required this.totalComments,
    required this.comments,
    required this.location,
    required this.relatedJobs,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
        id: json['_id'] ?? '',
    author: json['author'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    logo: json['logo'] ?? '',
    coverImage: json['coverImage'] ?? '',
    gallery: List<String>.from((json['gallery'] ?? []).map((x) => x?.toString() ?? '')),
    phoneNumber: json['phoneNumber'] ?? '',
    email: json['email'] ?? '',
    categoryId: json['categoryId'] ?? '',
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
    isActive: json['isActive'] ?? true,
    isDeleted: json['isDeleted'] ?? false,
    faq: json['faq'] ?? [],
    subscriptionList: json['subscriptionList'] ?? [],
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
    averageRating: json['averageRating'] ?? 0,
    totalReviews: json['totalReviews'] ?? 0,
    totalComments: json['totalComments'] ?? 0,
    comments: json['comments'] ?? [],
      location: Location.fromJson(json['location']??{}),
      relatedJobs: List<RelatedJob>.from(json['relatedJobs'].map((x) => RelatedJob.fromJson(x??{}))),
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
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}

class RelatedJob {
  final String id;
  final String title;
  final String logo;
  final String coverImage;
  final String category;
  final String address;

  RelatedJob({
    required this.id,
    required this.title,
    required this.logo,
    required this.coverImage,
    required this.category,
    required this.address,
  });

  factory RelatedJob.fromJson(Map<String, dynamic> json) {
    return RelatedJob(
      id: json['_id'],
      title: json['title'],
      logo: json['logo'],
      coverImage: json['coverImage'],
      category: json['category'],
      address: json['address'],
    );
  }
}
