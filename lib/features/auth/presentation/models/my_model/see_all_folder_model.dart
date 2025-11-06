// class SeeAllFolderModel {
//   final String folderName;
//   final List<Business> businesses;
//   final List<Event> events;
//   final List<Job> jobs;
//
//   SeeAllFolderModel({
//     this.folderName = '',
//     this.businesses = const [],
//     this.events = const [],
//     this.jobs = const [],
//   });
//
//   factory SeeAllFolderModel.fromJson(Map<String, dynamic> json) {
//     return SeeAllFolderModel(
//       folderName: json['folderName'] ?? '',
//       businesses:
//           (json['businesses'] as List<dynamic>? ?? [])
//               .map((e) => Business.fromJson(e))
//               .toList(),
//       events:
//           (json['events'] as List<dynamic>? ?? [])
//               .map((e) => Event.fromJson(e))
//               .toList(),
//       jobs:
//           (json['jobs'] as List<dynamic>? ?? [])
//               .map((e) => Job.fromJson(e))
//               .toList(),
//     );
//   }
// }
//
// class Business {
//   final String id;
//   final String name;
//   final String coverImage;
//   final String address;
//   ProviderType providerType;
//   final String priceRange;
//   final int maxGuest;
//   final String subscriptionType;
//   final String createdAt;
//   final double averageRating;
//   final int totalReviews;
//   final int totalLikes;
//   final int totalComments;
//   final bool isLiked;
//   final bool isFollowed;
//   final bool blueVerifiedBadge;
//   final String type;
//
//   Business({
//     this.id = '',
//     this.name = '',
//     this.coverImage = '',
//     this.address = '',
//     this.providerType = const ProviderType(),
//     this.priceRange = '',
//     this.maxGuest = 0,
//     this.subscriptionType = '',
//     this.createdAt = '',
//     this.averageRating = 0.0,
//     this.totalReviews = 0,
//     this.totalLikes = 0,
//     this.totalComments = 0,
//     this.isLiked = false,
//     this.isFollowed = false,
//     this.blueVerifiedBadge = false,
//     this.type = 'business',
//   });
//
//   factory Business.fromJson(Map<String, dynamic> json) {
//     return Business(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       coverImage: json['coverImage'] ?? '',
//       address: json['address'] ?? '',
//       providerType: json['providerType'] != null
//           ? ProviderType.fromJson(json['providerType'])
//           :  ProviderType(),
//       priceRange: json['priceRange'] ?? '',
//       maxGuest: json['maxGuest'] ?? 0,
//       subscriptionType: json['subscriptionType'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//       totalReviews: json['totalReviews'] ?? 0,
//       totalLikes: json['totalLikes'] ?? 0,
//       totalComments: json['totalComments'] ?? 0,
//       isLiked: json['isLiked'] ?? false,
//       isFollowed: json['isFollowed'] ?? false,
//       blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
//       type: json['type'] ?? 'business',
//     );
//   }
// }
//
// class Event {
//   final String id;
//   final String name;
//   final String coverImage;
//   final String address;
//   final String subscriptionType;
//   final String createdAt;
//   final double averageRating;
//   final int totalReviews;
//   final int totalLikes;
//   final int totalComments;
//   final bool isLiked;
//   final bool blueVerifiedBadge;
//   final String type;
//   final int entranceFee; // <-- Add this
//
//   Event({
//     this.id = '',
//     this.name = '',
//     this.coverImage = '',
//     this.address = '',
//     this.subscriptionType = '',
//     this.createdAt = '',
//     this.averageRating = 0.0,
//     this.totalReviews = 0,
//     this.totalLikes = 0,
//     this.totalComments = 0,
//     this.isLiked = false,
//     this.blueVerifiedBadge = false,
//     this.type = 'event',
//     this.entranceFee = 0, // <-- Default
//   });
//
//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       coverImage: json['coverImage'] ?? '',
//       address: json['address'] ?? '',
//       subscriptionType: json['subscriptionType'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//       totalReviews: json['totalReviews'] ?? 0,
//       totalLikes: json['totalLikes'] ?? 0,
//       totalComments: json['totalComments'] ?? 0,
//       isLiked: json['isLiked'] ?? false,
//       blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
//       type: json['type'] ?? 'event',
//       entranceFee: json['entranceFee'] ?? 0, // <-- Parse here
//     );
//   }
// }
//
// class Job {
//   final String id;
//   final String title;
//   final String coverImage;
//   final String category;
//   final String address; // <-- Add this
//   final String subscriptionType;
//   final String createdAt;
//   final bool blueVerifiedBadge;
//   final String type;
//
//   Job({
//     this.id = '',
//     this.title = '',
//     this.coverImage = '',
//     this.category = '',
//     this.address = '', // <-- Default
//     this.subscriptionType = '',
//     this.createdAt = '',
//     this.blueVerifiedBadge = false,
//     this.type = 'job',
//   });
//
//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       coverImage: json['coverImage'] ?? '',
//       category: json['category'] ?? '',
//       address: json['address'] ?? '', // <-- Parse here
//       subscriptionType: json['subscriptionType'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
//       type: json['type'] ?? 'job',
//     );
//   }
// }
//
// class ProviderType {
//   final String id;
//   final String name;
//
//   ProviderType({this.id = "", this.name = ""});
//
//   factory ProviderType.fromJson(Map<String, dynamic> json) {
//     return ProviderType(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//
//     );
//   }
// }

class SeeAllFolderModel {
  final String folderName;
  String image;
  final List<Business> businesses;
  final List<Event> events;
  final List<Job> jobs;

  SeeAllFolderModel({
    this.folderName = '',
    this.image='',
    this.businesses = const [],
    this.events = const [],
    this.jobs = const [],
  });

  factory SeeAllFolderModel.fromJson(Map<String, dynamic> json) {
    return SeeAllFolderModel(
      folderName: json['folderName'] ?? '',
      image: json['image']??'',
      businesses: (json['businesses'] as List<dynamic>? ?? [])
          .map((e) => Business.fromJson(e))
          .toList(),
      events: (json['events'] as List<dynamic>? ?? [])
          .map((e) => Event.fromJson(e))
          .toList(),
      jobs: (json['jobs'] as List<dynamic>? ?? [])
          .map((e) => Job.fromJson(e))
          .toList(),
    );
  }
}

class Business {
  final String id;
  final String name;
  final String coverImage;
  final String address;
  final ProviderType providerType;
  final String priceRange;
  final int maxGuest;
  final String subscriptionType;
  final String createdAt;
  final double averageRating;
  final int totalReviews;
  final int totalLikes;
  final int totalComments;
  final bool isLiked;
  final bool isFollowed;
  bool isWishlisted;
  final bool blueVerifiedBadge;
  final String type;

  Business({
    this.id = '',
    this.name = '',
    this.coverImage = '',
    this.address = '',
    this.providerType = const ProviderType(),
    this.priceRange = '',
    this.maxGuest = 0,
    this.subscriptionType = '',
    this.createdAt = '',
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    this.isFollowed = false,
    this.blueVerifiedBadge = false,
    this.type = 'business',
    required this.isWishlisted
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      address: json['address'] ?? '',
      providerType: json['providerType'] != null
          ? ProviderType.fromJson(json['providerType'])
          : ProviderType(),
      priceRange: json['priceRange'] ?? '',
      maxGuest: json['maxGuest'] ?? 0,
      subscriptionType: json['subscriptionType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      type: json['type'] ?? 'business',
      isWishlisted: json['isWishlisted']??true
    );
  }
}

class Event {
  final String id;
  final String name;
  final String coverImage;
  final String address;
  final String subscriptionType;
  final String createdAt;
  final double averageRating;
  final int totalReviews;
  final int totalLikes;
  final int totalComments;
  final bool isLiked;
  final bool blueVerifiedBadge;
  final String type;
  final int entranceFee;
  bool isWishlisted;

  Event({
    this.id = '',
    this.name = '',
    this.coverImage = '',
    this.address = '',
    this.subscriptionType = '',
    this.createdAt = '',
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    this.blueVerifiedBadge = false,
    this.type = 'event',
    this.entranceFee = 0,
    required this.isWishlisted
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      address: json['address'] ?? '',
      subscriptionType: json['subscriptionType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      type: json['type'] ?? 'event',
      entranceFee: json['entranceFee'] ?? 0,
      isWishlisted: json['isWishlisted']?? true
    );
  }
}

class Job {
  final String id;
  final String title;
  final String coverImage;
  final String category;
  final String address;
  final String subscriptionType;
  final String createdAt;
  final bool blueVerifiedBadge;
  final String type;
  bool isWishlisted;

  Job({
    this.id = '',
    this.title = '',
    this.coverImage = '',
    this.category = '',
    this.address = '',
    this.subscriptionType = '',
    this.createdAt = '',
    this.blueVerifiedBadge = false,
    this.type = 'job',
    required this.isWishlisted
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      subscriptionType: json['subscriptionType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      type: json['type'] ?? 'job',
      isWishlisted: json['isWishlisted']??true
    );
  }
}

class ProviderType {
  final String id;
  final String name;

  const ProviderType({
    this.id = '',
    this.name = '',
  });

  factory ProviderType.fromJson(Map<String, dynamic> json) {
    return ProviderType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'ProviderType(id: $id, name: $name)';
}
