class SubscriptionModel {
  final String id;
  final String title;
    final String subtitle;
  final String type;
  final List<String> feature;
  final List<SubscriptionOption> options;
  final num priorityLevel;
  final bool blueVerified;

  SubscriptionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.feature,
    required this.options,
    required this.priorityLevel,
    required this.blueVerified,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id']??"",
      title: json['title']??"",
      subtitle: json['subTitle']??"",
      type: json['type'],
      feature: List<String>.from(json['feature']??[]),
      options: (json['options'] as List)
          .map((item) => SubscriptionOption.fromJson(item))
          .toList(),
      priorityLevel: json['priorityLevel']??0,
      blueVerified: json['blueVerified']??false,
    );
  }
}

class SubscriptionOption {
  final String time;
  final num price;
  final num expirationDays;

  SubscriptionOption({
    required this.time,
    required this.price,
    required this.expirationDays,
  });

  factory SubscriptionOption.fromJson(Map<String, dynamic> json) {
    return SubscriptionOption(
      time: json['time'],
      price: json['price']??0,
      expirationDays: json['expirationDays']??0,
    );
  }
}
