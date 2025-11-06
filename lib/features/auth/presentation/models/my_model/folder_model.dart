class FolderModel {
  String folderName;
  List<BusinessModel> businesses;
  List<EventModel> events;
  List<JobModel> jobs;
  bool isActive;

  FolderModel({
    this.folderName = '',
    this.businesses = const [],
    this.events = const [],
    this.jobs = const [],
    this.isActive = false,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      folderName: json['folderName'] ?? '',
      businesses: (json['businesses'] as List<dynamic>?)
          ?.map((e) => BusinessModel.fromJson(e))
          .toList() ??
          [],
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => EventModel.fromJson(e))
          .toList() ??
          [],
      jobs: (json['jobs'] as List<dynamic>?)
          ?.map((e) => JobModel.fromJson(e))
          .toList() ??
          [],
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderName': folderName,
      'businesses': businesses.map((e) => e.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'jobs': jobs.map((e) => e.toJson()).toList(),
      'isActive': isActive,
    };
  }
}

class BusinessModel {
  String id;
  String name;
  String coverImage;

  BusinessModel({
    this.id = '',
    this.name = '',
    this.coverImage = '',
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'coverImage': coverImage,
    };
  }
}

class EventModel {
  String id;
  String name;
  String coverImage;

  EventModel({
    this.id = '',
    this.name = '',
    this.coverImage = '',
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'coverImage': coverImage,
    };
  }
}

class JobModel {
  String id;
  String title;
  String coverImage;

  JobModel({
    this.id = '',
    this.title = '',
    this.coverImage = '',
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'coverImage': coverImage,
    };
  }
}
