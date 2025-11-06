

class InterestedUsersData {
  final String id;
  final List<InterestUser> interestUsers;

  InterestedUsersData({
    required this.id,
    required this.interestUsers,
  });

  factory InterestedUsersData.fromJson(Map<String, dynamic> json) {
    return InterestedUsersData(
      id: json['_id'] ?? '',
      interestUsers: (json['interestUsers'] as List)
          .map((e) => InterestUser.fromJson(e))
          .toList(),
    );
  }
}

class InterestUser {
  final User user;
  final DateTime interestedAt;
  final String id;

  InterestUser({
    required this.user,
    required this.interestedAt,
    required this.id,
  });

  factory InterestUser.fromJson(Map<String, dynamic> json) {
    return InterestUser(
      user: User.fromJson(json['user']),
      interestedAt: DateTime.parse(json['interestedAt']),
      id: json['_id'] ?? '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}