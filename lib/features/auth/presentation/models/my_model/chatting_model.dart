class ChattingModel {
  String text;
  String sender;
  String createdAt;
  List<dynamic> images;

  ChattingModel({
    this.text = '',
    this.sender = '',
    this.createdAt = '',
    this.images = const [],
  });

  factory ChattingModel.fromJson(Map<String, dynamic> json) {
    return ChattingModel(
      text: json['text'] ?? '',
      sender: json['sender'] ?? '',
      createdAt: json['createdAt'] ?? '',
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

}
