class BusinessListResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<BusinessItem> data;

  BusinessListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BusinessListResponse.fromJson(Map<String, dynamic> json) {
    return BusinessListResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BusinessItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class BusinessItem {
  final String id;
  final String name;

  BusinessItem({
    required this.id,
    required this.name,
  });

  factory BusinessItem.fromJson(Map<String, dynamic> json) {
    return BusinessItem(
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
