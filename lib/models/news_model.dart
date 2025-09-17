class News {
  final String id; // Cambiado a String
  final String title;
  final String date;
  final String newsUrl;
  final String coverUrl;
  final String? departmentName; // Nuevo campo
  final String? categoryName; // Nuevo campo
  final String? categoryColor; // Nuevo campo

  News({
    required this.id,
    required this.title,
    required this.date,
    required this.newsUrl,
    required this.coverUrl,
    this.departmentName,
    this.categoryName,
    this.categoryColor,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      date: (json['date'] as String?) ?? '',
      newsUrl: (json['newsUrl'] as String?) ?? '',
      coverUrl: (json['coverUrl'] as String?) ?? '',
      departmentName: (json['departmentName'] as String?),
      categoryName: (json['categoryName'] as String?),
      categoryColor: (json['categoryColor'] as String?),
    );
  }
}