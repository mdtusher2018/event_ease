
class JobSearchModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String address;
  final String contractType;
  final int salery;
  final String experience;
  final String availability;
  final int workHour;
  final String coverImage;
  final String logo;

  JobSearchModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.address,
    required this.contractType,
    required this.salery,
    required this.experience,
    required this.availability,
    required this.workHour,
    required this.coverImage,
    required this.logo,
  });

  factory JobSearchModel.fromJson(Map<String, dynamic> json) {
    return JobSearchModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      contractType: json['contractType'] ?? '',
      salery: json['salery'] ?? 0,
      experience: json['experience'] ?? '',
      availability: json['availability'] ?? '',
      workHour: json['workHour'] ?? 0,
      coverImage: json['coverImage'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'address': address,
      'contractType': contractType,
      'salery': salery,
      'experience': experience,
      'availability': availability,
      'workHour': workHour,
      'coverImage': coverImage,
      'logo': logo,
    };
  }
}