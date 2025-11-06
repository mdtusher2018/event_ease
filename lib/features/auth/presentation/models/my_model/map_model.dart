class MapModel {
  final List<Business> businesses;
  final List<Event> events;
  final List<Job> jobs; // ✅ Added Jobs

  MapModel({
    this.businesses = const [],
    this.events = const [],
    this.jobs = const [],
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      businesses: (json['businesses'] as List<dynamic>? ?? [])
          .map((e) => Business.fromJson(e))
          .toList(),
      events: (json['events'] as List<dynamic>? ?? [])
          .map((e) => Event.fromJson(e))
          .toList(),
      jobs: (json['jobs'] as List<dynamic>? ?? []) // ✅ parse jobs
          .map((e) => Job.fromJson(e))
          .toList(),
    );
  }
}

class Business {
  final String id;
  final String name;
  final String coverImage;
  final Availability availabilities;
  final String address;
  final Location location;

  Business({
    this.id = '',
    this.name = '',
    this.coverImage = '',
    this.availabilities = const Availability(),
    this.address = '',
    this.location = const Location(),
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      availabilities:
          Availability.fromJson(json['availabilities'] ?? <String, dynamic>{}),
      address: json['address'] ?? '',
      location: Location.fromJson(json['location'] ?? <String, dynamic>{}),
    );
  }
}

class Event {
  final String id;
  final String name;
  final String coverImage;
  final String address;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final Location location;

  Event({
    this.id = '',
    this.name = '',
    this.coverImage = '',
    this.address = '',
    this.startDate = '',
    this.endDate = '',
    this.startTime = '',
    this.endTime = '',
    this.location = const Location(),
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      address: json['address'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      location: Location.fromJson(json['location'] ?? <String, dynamic>{}),
    );
  }
}

class Job {
  final String id;
  final String title;
  final String company;
  final String coverImage;
  final String address;
  final Location location;
  final String postedDate;

  Job({
    this.id = '',
    this.title = '',
    this.company = '',
    this.coverImage = '',
    this.address = '',
    this.location = const Location(),
    this.postedDate = '',
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      coverImage: json['coverImage'] ?? '',
      address: json['address'] ?? '',
      location: Location.fromJson(json['location'] ?? <String, dynamic>{}),
      postedDate: json['postedDate'] ?? '',
    );
  }
}

class Availability {
  final List<String> day;
  final String startTime;
  final String endTime;
  final String id;

  const Availability({
    this.day = const [],
    this.startTime = '',
    this.endTime = '',
    this.id = '',
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      day: List<String>.from(json['day'] ?? []),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  const Location({
    this.type = 'Point',
    this.coordinates = const [],
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
