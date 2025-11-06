
import 'pasination_model.dart';

class BusinessDataModel {
  final List<Business> data;
  final Meta meta;

  BusinessDataModel({required this.data, required this.meta});

  factory BusinessDataModel.fromJson(Map<String, dynamic> json) {
    return BusinessDataModel(
      data: List<Business>.from(json['data'].map((x) => Business.fromJson(x??{}))),
      meta: Meta.fromJson(json['meta']),
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
  int totalReviews;
  int totalLikes;
  int totalComments;
  final bool blueVerifiedBadge;
  bool isLiked;
  bool isFollowed;
  bool isWishlisted;

  Business({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.address,
    required this.providerType,
    required this.priceRange,
    required this.maxGuest,
    required this.subscriptionType,
    required this.createdAt,
    required this.averageRating,
    required this.totalReviews,
    required this.totalLikes,
    required this.totalComments,
    required this.blueVerifiedBadge,
    required this.isLiked,
    required this.isFollowed,
    required this.isWishlisted,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['_id'],
      name: json['name'],
      coverImage: json['coverImage'] ?? "",
      address: json['address'],
      providerType: ProviderType.fromJson(json['providerType']??{}),
      priceRange: json['priceRange'],
      maxGuest: json['maxGuest'],
      subscriptionType: json['subscriptionType'],
      createdAt: json['createdAt'],
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      totalLikes: json['totalLikes'],
isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      totalComments: json['totalComments'],
      blueVerifiedBadge: json['blueVerifiedBadge']??false,
      isWishlisted: json['isWishlisted'] ?? false,
    );
  }
}

class ProviderType {
  final String id;
  final String name;

  ProviderType({required this.id, required this.name});

  factory ProviderType.fromJson(Map<String, dynamic> json) {
    return ProviderType(id: json['_id'], name: json['name']);
  }
}
