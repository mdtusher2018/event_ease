class PendingCreditRequestForBusiness {
  final String id;
  final User user;
  final String type;
  final BusinessOwner businessOwner;
  final Business business;
  final int usedCredits;
  final String text;
  final String image;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PendingCreditRequestForBusiness({
    required this.id,
    required this.user,
    required this.type,
    required this.businessOwner,
    required this.business,
    required this.usedCredits,
    required this.text,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendingCreditRequestForBusiness.fromJson(Map<String, dynamic> json) {
    return PendingCreditRequestForBusiness(
      id: json['_id'] ?? '',
      user: User.fromJson(json['userId']),
      type: json['type'] ?? '',
      businessOwner: BusinessOwner.fromJson(json['businessOwner']),
      business: Business.fromJson(json['businessId']),
      usedCredits: json['usedCredits'] ?? 0,
      text: json['text'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user.toJson(),
      'type': type,
      'businessOwner': businessOwner.toJson(),
      'businessId': business.toJson(),
      'usedCredits': usedCredits,
      'text': text,
      'image': image,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// The user who made the credit request
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}

/// The owner of the business receiving the request
class BusinessOwner {
  final String id;
  final String name;
  final String email;

  BusinessOwner({required this.id, required this.name, required this.email});

  factory BusinessOwner.fromJson(Map<String, dynamic> json) {
    return BusinessOwner(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}

/// The business entity
class Business {
  final String id;
  final String name;
  final String logo;

  Business({required this.id, required this.name, required this.logo});

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'logo': logo};
  }
}
