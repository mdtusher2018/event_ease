class ProfileModel {
  final String id;
  final String sureName;
  final String name;
  final String email;
  final String profileImage;
  final String role;
  final String phone;
  final String about;
  final String address;
  final List<double> coordinates;
  final bool isSubBusiness;
  final String parentBusiness;
  final List<dynamic> wishlist;
  final bool isBlocked;
  final bool isDeleted;
  final bool termsAndConditions;
  final String createdAt;
  final String updatedAt;
  final DeviceInfo device;

  ProfileModel({
    this.id = '',
    this.sureName = '',
    this.name = '',
    this.email = '',
    this.profileImage = '',
    this.role = '',
    this.phone = '',
    this.about = '',
    this.address = '',
    this.coordinates = const [],
    this.isSubBusiness = false,
    this.parentBusiness = '',
    this.wishlist = const [],
    this.isBlocked = false,
    this.isDeleted = false,
    this.termsAndConditions = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.device = const DeviceInfo(),
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      sureName: json['sureName'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      about: json['about'] ?? '',
      address: json['address'] ?? '',
      coordinates: (json['location']?['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      isSubBusiness: json['isSubBusiness'] ?? false,
      parentBusiness: json['parentBusiness'] ?? '',
      wishlist: json['wishlist'] ?? [],
      isBlocked: json['isBlocked'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      termsAndConditions: json['termsAndConditions'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      device: json['device'] != null ? DeviceInfo.fromJson(json['device']) : const DeviceInfo(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sureName': sureName,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'role': role,
      'phone': phone,
      'about': about,
      'address': address,
      'location': {
        'coordinates': coordinates,
      },
      'isSubBusiness': isSubBusiness,
      'parentBusiness': parentBusiness,
      'wishlist': wishlist,
      'isBlocked': isBlocked,
      'isDeleted': isDeleted,
      'termsAndConditions': termsAndConditions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'device': device.toJson(),
    };
  }
}

class DeviceInfo {
  final String ip;
  final String device;
  final String lastLogin;

  const DeviceInfo({
    this.ip = '',
    this.device = '',
    this.lastLogin = '',
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      ip: json['ip'] ?? '',
      device: json['device'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'device': device,
      'lastLogin': lastLogin,
    };
  }
}
