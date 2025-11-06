class InspirationDetailModel {
  String id;
  String title;
  String type;
  String description;
  String coverImage;
  String createdAt;
  String updatedAt;
  int v;
  Category category;
  String subCategory;
  List<String> imageGallery;


    // ✅ New fields
  String authorId;
  String authorName;
  String authorImage;
  String authorRole;
  String createdDate;
  String createdTime;


  InspirationDetailModel({
    this.id = '',
    this.title = '',
    this.type = '',
    this.description = '',
    this.coverImage = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.v = 0,
    this.subCategory='',

    this.authorId = '',
    this.authorName = '',
    this.authorImage = '',
    this.authorRole = '',
    this.createdDate = '',
    this.createdTime = '',


    Category? category,
    List<String>? imageGallery,
  })  : category = category ?? Category(),
        imageGallery = imageGallery ?? [];

  factory InspirationDetailModel.fromJson(Map<String, dynamic> json) {


    // Extract author safely
    final author = json['author'] ?? {};

    // Handle created date/time split
    String createdAtRaw = json['createdAt'] ?? '';
    String datePart = '';
    String timePart = '';
    if (createdAtRaw.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(createdAtRaw).toLocal();
        datePart = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
        timePart = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (e) {
        // fallback in case parsing fails
        datePart = createdAtRaw;
        timePart = '';
      }
    }


    return InspirationDetailModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      subCategory: json['subCategory'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      imageGallery: List<String>.from(json['imageGallery'] ?? []),
    
      authorId: author['_id'] ?? '',
      authorName: author['name'] ?? '',
      authorImage: author['profileImage'] ?? '',
      authorRole: author['role'] ?? '',
      createdDate: datePart,
      createdTime: timePart,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'type': type,
      'description': description,
      'coverImage': coverImage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'category': category.toJson(),
      'imageGallery': imageGallery,
    };
  }
}

class Category {
  String id;
  String name;

  Category({
    this.id = '',
    this.name = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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
}
