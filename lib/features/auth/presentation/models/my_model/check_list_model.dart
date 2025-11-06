
class CheckListModel {
   String id;
   String userId;
   String image;
   String checklistName;
   bool isActive;
   bool isDeleted;
   List<ChecklistItem> items;
   String createdAt;
   String updatedAt;
   int checkedItemsCount;

  CheckListModel({
    required this.id,
    required this.userId,
    required this.image,
    required this.checklistName,
    required this.isActive,
    required this.isDeleted,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    required this.checkedItemsCount,
  });

  factory CheckListModel.fromJson(Map<String, dynamic> json) {
    return CheckListModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      image: json['image'] ?? '',
      checklistName: json['checklistName'] ?? '',
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ChecklistItem.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      checkedItemsCount: json['checkedItemsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'image': image,
      'checklistName': checklistName,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'items': items.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'checkedItemsCount': checkedItemsCount,
    };
  }
}

class ChecklistItem {
  final String id;
  final String itemName;
  final bool isChecked;
  final String createdAt;

  ChecklistItem({
    required this.id,
    required this.itemName,
    required this.isChecked,
    required this.createdAt,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['_id'] ?? '',
      itemName: json['itemName'] ?? '',
      isChecked: json['isChecked'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'itemName': itemName,
      'isChecked': isChecked,
      'createdAt': createdAt,
    };
  }
}