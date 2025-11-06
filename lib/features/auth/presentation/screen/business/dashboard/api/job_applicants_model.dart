class JobApplicantModel {
  final String id;
  final String jobId;
  final List<ApplicantUser> applicantUsers;
  final String createdAt;
  final String updatedAt;
  final int v;

  JobApplicantModel({
    this.id = '',
    this.jobId = '',
    this.applicantUsers = const [],
    this.createdAt = '',
    this.updatedAt = '',
    this.v = 0,
  });

  factory JobApplicantModel.fromJson(Map<String, dynamic> json) {
    return JobApplicantModel(
      id: json['_id'] ?? '',
      jobId: json['jobId'] ?? '',
      applicantUsers: (json['applicantUsers'] as List<dynamic>? ?? [])
          .map((e) => ApplicantUser.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}

class ApplicantUser {
  final UserInfo user;
  final String viewCvImage;
  final String id;
  final String applicantTime;

  ApplicantUser({
    this.user = const UserInfo(),
    this.viewCvImage = '',
    this.id = '',
    this.applicantTime = '',
  });

  factory ApplicantUser.fromJson(Map<String, dynamic> json) {
    return ApplicantUser(
      user: UserInfo.fromJson(json['user'] ?? {}),
      viewCvImage: json['viewCvImage'] ?? '',
      id: json['_id'] ?? '',
      applicantTime: json['applicantTime'] ?? '',
    );
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  const UserInfo({
    this.id = '',
    this.name = '',
    this.email = '',
    this.profileImage = '',
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
