// CreditData Model
class CreditData {
  final String? id;
  final User? userId;
  final String type;
  final String? businessOwner; // This is just an ID (string)
  final BusinessId? businessId; // Contains business information
  final int usedCredits;
  final String text;
  final String image;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CreditData({
    this.id,
    this.userId,
    required this.type,
    this.businessOwner,
    this.businessId,
    required this.usedCredits,
    required this.text,
    required this.image,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for converting JSON into CreditData
  factory CreditData.fromJson(Map<String, dynamic> json) {
    return CreditData(
      id: json['_id'],
      userId: json['userId'] != null ? User.fromJson(json['userId']) : null,
      type: json['type'] ?? '',
      businessOwner:
          json['businessOwner'] ?? null, // This will be just the ID (string)
      businessId:
          json['businessId'] != null
              ? BusinessId.fromJson(json['businessId'])
              : null,
      usedCredits: json['usedCredits'] ?? 0,
      text: json['text'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

// User Model
class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

// BusinessId Model (Contains business information like name, logo, etc.)
class BusinessId {
  final String id;
  final String name;
  final String logo;
  final String coverImage;

  BusinessId({
    required this.id,
    required this.name,
    required this.logo,
    required this.coverImage,
  });

  factory BusinessId.fromJson(Map<String, dynamic> json) {
    return BusinessId(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['coverImage'] ?? '',
    );
  }
}
