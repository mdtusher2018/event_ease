
import 'pasination_model.dart';

class ProviderCategoryDataModel {
  final List<ProviderCategory> categories;
  final Meta meta;

  ProviderCategoryDataModel({required this.categories, required this.meta});

  factory ProviderCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return ProviderCategoryDataModel(
      categories: List<ProviderCategory>.from(
        json['data'].map((x) => ProviderCategory.fromJson(x)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class ProviderCategory {
  final String id;
  final String name;
  final String type;
  final String banner;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProviderCategory({
     this.id="",
     this.name="",
     this.type="",
     this.banner="",
     this.isDeleted=false,
     this.createdAt,
     this.updatedAt,
  });

  factory ProviderCategory.fromJson(Map<String, dynamic> json) {
    return ProviderCategory(
      id: json['_id']??"",
      name: json['name']??"N/A",
      type: json['type']??"",
      banner: json['icon'] ?? "https://png.pngtree.com/png-clipart/20220911/original/pngtree-no-button-png-image_8542482.png",
      isDeleted: json['isDeleted'],
      createdAt: DateTime.tryParse(json['createdAt']),
      updatedAt: DateTime.tryParse(json['updatedAt']),
    );
  }
}
