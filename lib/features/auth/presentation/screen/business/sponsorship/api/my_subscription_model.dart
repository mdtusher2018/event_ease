class MySubscriptionModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<MySponsorSubscriptionData> data;

  MySubscriptionModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) {
    return MySubscriptionModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'],
      message: json['message'] ?? "N/A",
      data: List<MySponsorSubscriptionData>.from(
        (json['data'] ?? []).map((x) => MySponsorSubscriptionData.fromJson(x)),
      ),
    );
  }
}

class MySponsorSubscriptionData {
  final String id;
  final String user;
  final String subscriptionPaymentId;
  final DateTime expireDate;
  final MySponsorSubscriptionFor subscriptionFor;
  final String subscriptionForType;
  final MySponsorSubscription subscription;
  final int subscriptionOptionIndex;
  final int subscriptionPriorityLevel;
  final String subscriptionType;
  final String paymentMethod;
  final String paymentType;
  final String paymentStatus;
  final String status;
  final int activateExpireDays;
  final DateTime? activateExpireDate;
  final DateTime? activateDate;
  final DateTime? stopDate;
  final bool isExpired;
  final bool isNotified;
  final num gotCredits;
  final num potentialCredits;
  final DateTime createdAt;
  final DateTime updatedAt;

  MySponsorSubscriptionData({
    required this.id,
    required this.user,
    required this.subscriptionPaymentId,
    required this.expireDate,
    required this.subscriptionFor,
    required this.subscriptionForType,
    required this.subscription,
    required this.subscriptionOptionIndex,
    required this.subscriptionPriorityLevel,
    required this.subscriptionType,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentType,
    required this.status,
    required this.activateExpireDays,
    this.activateExpireDate,
    this.activateDate,
    this.stopDate,
    required this.isExpired,
    required this.isNotified,
    required this.createdAt,
    required this.updatedAt,
    required this.gotCredits,
    required this.potentialCredits,
  });

  factory MySponsorSubscriptionData.fromJson(Map<String, dynamic> json) {
    return MySponsorSubscriptionData(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      subscriptionPaymentId: json['subscriptionPaymentId'] ?? '',
      expireDate: json['expireDate'] != null ? DateTime.parse(json['expireDate']) : DateTime.now(),
      subscriptionFor: MySponsorSubscriptionFor.fromJson(json['subscriptionFor'] ?? {}),
      subscriptionForType: json['subscriptionForType'] ?? '',
      subscription: MySponsorSubscription.fromJson(json['subscription'] ?? {}),
      subscriptionOptionIndex: json['subscriptionOptionIndex'] ?? 0,
      subscriptionPriorityLevel: json['subscriptionPriorityLevel'] ?? 0,
      subscriptionType: json['subscriptionType'] ?? '',
      paymentType: json["paymentType"]??'',
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
      gotCredits: json["gotCredits"]??0,
      potentialCredits: json['potentialCredits']??0,
      activateExpireDays: json['activateExpireDays'] ?? 0,
      activateExpireDate: json['activateExpireDate'] != null ? DateTime.parse(json['activateExpireDate']) : null,
      activateDate: json['activateDate'] != null ? DateTime.tryParse(json['activateDate']) : null,
      stopDate: json['stopDate'] != null ? DateTime.tryParse(json['stopDate']) : null,
      isExpired: json['isExpired'] ?? false,
      isNotified: json['isNotified'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}

class MySponsorSubscriptionOption {
  final String time;
  final double price;
  final int expirationDays;
  final int refoundDays;

  MySponsorSubscriptionOption({
    required this.time,
    required this.price,
    required this.expirationDays,
    required this.refoundDays,
  });

  factory MySponsorSubscriptionOption.fromJson(Map<String, dynamic> json) {
    return MySponsorSubscriptionOption(
      time: json['time'] ?? '',
      price: (json['price'] as num).toDouble(),
      expirationDays: json['expirationDays'] ?? 0,
      refoundDays: json['refoundDays'] ?? 0,
    );
  }
}

class MySponsorSubscriptionFor {
  final String id;
  final String name;

  MySponsorSubscriptionFor({required this.id, required this.name});

  factory MySponsorSubscriptionFor.fromJson(Map<String, dynamic> json) {
    return MySponsorSubscriptionFor(
      id: json['_id'] ?? '',
      name: json['name'] ?? (json['title']?? 'N/A'),
    );
  }
}

class MySponsorSubscription {
  final String id;
  final String title;
  final String subTitle;
  final String type;
  final List<String> feature;
  final List<MySponsorSubscriptionOption> options;
  final int priorityLevel;
  final bool blueVerified;
  final String createdAt;
  final String updatedAt;

  MySponsorSubscription({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.type,
    required this.feature,
    required this.options,
    required this.priorityLevel,
    required this.blueVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MySponsorSubscription.fromJson(Map<String, dynamic> json) {
    return MySponsorSubscription(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['subTitle'] ?? '',
      type: json['type'] ?? '',
      feature: List<String>.from(json['feature'] ?? []),
      options: List<MySponsorSubscriptionOption>.from(
        (json['options'] ?? []).map(
          (x) => MySponsorSubscriptionOption.fromJson(x),
        ),
      ),
      priorityLevel: json['priorityLevel'] ?? 0,
      blueVerified: json['blueVerified'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }
}

