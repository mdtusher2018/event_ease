

class LatestInspirationData {
  final List<InspirationItem> data;

  LatestInspirationData({
    required this.data,

  });

  factory LatestInspirationData.fromJson(Map<String, dynamic> json) {
    return LatestInspirationData(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => InspirationItem.fromJson(e))
          .toList(),
    );
  }
}

class InspirationItem {
  final String id;
  final InspirationAuthor author;
  final String title;
  final InspirationCategory category;
  final String subCategory;
  final String type;
  final String description;
  final String coverImage;
  final List<String> imageGallery;
  final bool isBlocked;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  InspirationItem({
    required this.id,
    required this.author,
    required this.title,
    required this.category,
    required this.subCategory,
    required this.type,
    required this.description,
    required this.coverImage,
    required this.imageGallery,
    required this.isBlocked,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InspirationItem.fromJson(Map<String, dynamic> json) {
    return InspirationItem(
      id: json['_id'] ?? '',
      author: InspirationAuthor.fromJson(json['author'] ?? {}),
      title: json['title'] ?? '',
      category: InspirationCategory.fromJson(json['category'] ?? {}),
      subCategory: json['subCategory'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      imageGallery: List<String>.from(json['imageGallery'] ?? []),
      isBlocked: json['isBlocked'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class InspirationAuthor {
  final String id;
  final String name;
  final String profileImage;
  final String role;

  InspirationAuthor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.role,
  });

  factory InspirationAuthor.fromJson(Map<String, dynamic> json) {
    return InspirationAuthor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class InspirationCategory {
  final String id;
  final String name;
  final String description;

  InspirationCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory InspirationCategory.fromJson(Map<String, dynamic> json) {
    return InspirationCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

