class PendingCreditRequestOfUser {
  final String id;
  final String userId;
  final String type;
  final BusinessOwner businessOwner;
  final BusinessId businessId;
  final int usedCredits;
  final String text;
  final String image;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PendingCreditRequestOfUser({
    required this.id,
    required this.userId,
    required this.type,
    required this.businessOwner,
    required this.businessId,
    required this.usedCredits,
    required this.text,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PendingCreditRequestOfUser.fromJson(Map<String, dynamic> json) {
    return PendingCreditRequestOfUser(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      businessOwner: BusinessOwner.fromJson(json['businessOwner']),
      businessId: BusinessId.fromJson(json['businessId']),
      usedCredits: json['usedCredits'],
      text: json['text'],
      image: json['image'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'type': type,
      'businessOwner': businessOwner.toJson(),
      'businessId': businessId.toJson(),
      'usedCredits': usedCredits,
      'text': text,
      'image': image,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class BusinessOwner {
  final String id;
  final String name;
  final String email;

  BusinessOwner({required this.id, required this.name, required this.email});

  factory BusinessOwner.fromJson(Map<String, dynamic> json) {
    return BusinessOwner(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}

class BusinessId {
  final String id;
  final String name;
  final String logo;

  BusinessId({required this.id, required this.name, required this.logo});

  factory BusinessId.fromJson(Map<String, dynamic> json) {
    return BusinessId(id: json['_id'], name: json['name'], logo: json['logo']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'logo': logo};
  }
}
