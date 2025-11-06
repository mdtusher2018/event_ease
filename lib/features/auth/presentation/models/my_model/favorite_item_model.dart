class FavoriteItemModel {
  final String id;
  final String name;
  final String title;
  final String coverImage;
  final String address;
  final String category;
  final String subscriptionType;
  final String createdAt;
  final double averageRating;
  final int totalReviews;
   int totalLikes;
   int totalComments;
   bool isLiked;
   bool isFollowed;
   bool isWishlisted;
   bool blueVerifiedBadge;
  final int maxGuest;
  final int entranceFee;
  final String providerType;
  final String priceRange;
  final String type;

  FavoriteItemModel({
    this.id = '',
    this.name = '',
    this.title = '',
    this.coverImage = '',
    this.address = '',
    this.category = '',
    this.subscriptionType = '',
    this.createdAt = '',
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.isLiked = false,
    this.isFollowed = false,
    this.blueVerifiedBadge = false,
    this.maxGuest = 0,
    this.entranceFee = 0,
    this.providerType = '',
    this.priceRange = '',
    this.type = '',
    required this.isWishlisted,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
      address: json['address'] ?? '',
      category: json['category'] ?? '',
      subscriptionType: json['subscriptionType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      blueVerifiedBadge: json['blueVerifiedBadge'] ?? false,
      maxGuest: json['maxGuest'] ?? 0,
      entranceFee: json['entranceFee'] ?? 0,
      providerType: json['providerType'] ?? '',
      priceRange: json['priceRange'] ?? '',
      type: json['type'] ?? '',
      isWishlisted: json['isWishlisted']?? true
    );
  }
}
