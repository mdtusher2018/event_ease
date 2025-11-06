class DeshBoardModel {
  final String? businessId;
  final String? eventId;
  final String? jobId;

  final num? totalFollowers;
  final num? totalLikes;
  final num? totalComments;
  final num? profileViews;
  final num? eventViews;
  final num? jobViews;
  final num? jobApplicants;

  final List<MonthlyView>? monthlyViews;

  final double? averageRating;
  final num? totalReviews;

  final dynamic activeSubscription;
  final num? totalActiveSub;
  final num? totalCredits;
  final num? interestsUsers;

  // Optional: Add status fields from API
  final bool? success;
  final num? statusCode;
  final String? message;
  final String? customId;
  final String? image;

  DeshBoardModel({
    this.businessId,
    this.eventId,
    this.jobId,
    this.totalFollowers,
    this.totalLikes,
    this.totalComments,
    this.profileViews,
    this.eventViews,
    this.jobViews,
    this.jobApplicants,
    this.monthlyViews,
    this.averageRating,
    this.totalReviews,
    this.activeSubscription,
    this.totalActiveSub,
    this.totalCredits,
    this.interestsUsers,
    this.success,
    this.statusCode,
    this.message,
    this.customId,
    this.image,
  });

  factory DeshBoardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return DeshBoardModel(
      businessId: data['businessId'],
      eventId: data['eventId'],
      jobId: data['jobId'],
      totalFollowers: data['totalFollowers'],
      totalLikes: data['totalLikes'],
      totalComments: data['totalComments'],
      profileViews: data['profileViews'],
      eventViews: data['eventViews'],
      jobViews: data['jobViews'],
      jobApplicants: data['jobApplicants'],
      monthlyViews:
          data['monthlyViews'] != null
              ? (data['monthlyViews'] as List<dynamic>)
                  .map((e) => MonthlyView.fromJson(e))
                  .toList()
              : null,
      averageRating: (data['averageRating'] as num?)?.toDouble(),
      totalReviews: data['totalReviews'],
      activeSubscription: data['activeSubscription'],
      totalActiveSub: data['totalActiveSub'],
      totalCredits: data['totalCredits'] ?? 0.0,
      interestsUsers: data['interestsUsers'],
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      customId: json['customId'],
      image: json['image'],
    );
  }
}

class MonthlyView {
  final String month;
  final int totalViews;

  MonthlyView({required this.month, required this.totalViews});

  factory MonthlyView.fromJson(Map<String, dynamic> json) {
    return MonthlyView(month: json['month'], totalViews: json['totalViews']);
  }
}
