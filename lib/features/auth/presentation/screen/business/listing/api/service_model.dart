
class SupportedService {
  final String id;
  final String name;
  final String type;
  final String description;
  final String icon;
  final String banner;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupportedService({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.icon,
    required this.banner,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportedService.fromJson(Map<String, dynamic> json) {
    return SupportedService(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      banner: json['banner'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
