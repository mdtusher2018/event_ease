class BusinessNameModel {
  final String id;
  final String name;

  BusinessNameModel({
    required this.id,
    required this.name,
  });

  factory BusinessNameModel.fromJson(Map<String, dynamic> json) {
    return BusinessNameModel(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}


class EventNameModel {
  final String id;
  final String name;

  EventNameModel({
    required this.id,
    required this.name,
  });

  factory EventNameModel.fromJson(Map<String, dynamic> json) {
    return EventNameModel(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class JobNameModel {
  final String id;
  final String name;

  JobNameModel({
    required this.id,
    required this.name,
  });

  factory JobNameModel.fromJson(Map<String, dynamic> json) {
    return JobNameModel(
      id: json['_id'],
      name: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': name,
    };
  }
}
