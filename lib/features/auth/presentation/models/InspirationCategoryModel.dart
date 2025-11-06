import 'package:event_ease/features/auth/presentation/models/pasination_model.dart';

class InspirationCategoryModel {
  final List<InspirationCategory> categories;
  final Meta meta;

  InspirationCategoryModel({required this.categories, required this.meta});

  factory InspirationCategoryModel.fromJson(Map<String, dynamic> json) {
    return InspirationCategoryModel(
      categories: List<InspirationCategory>.from(
        json['data'].map((x) => InspirationCategory.fromJson(x)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class InspirationCategory {
  final String id;
  final String name;
  final String type;
  final String banner;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  InspirationCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.banner,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InspirationCategory.fromJson(Map<String, dynamic> json) {
    return InspirationCategory(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      banner: json['banner'] ?? "",
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
