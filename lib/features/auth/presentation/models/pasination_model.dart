class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page']??1,
      limit: json['limit']??10,
      total: json['total']??0,
      totalPage: json['totalPage']??1,
    );
  }
}
