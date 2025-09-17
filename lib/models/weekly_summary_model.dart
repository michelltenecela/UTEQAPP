class WeeklySummary {
  final String title;
  final String date;
  final String videoUrl;
  final String coverUrl;

  WeeklySummary({
    required this.title,
    required this.date,
    required this.videoUrl,
    required this.coverUrl,
  });

  factory WeeklySummary.fromJson(Map<String, dynamic> json) {
    return WeeklySummary(
      title: (json['title'] as String?) ?? '', // CORREGIDO: Manejar null para String
      date: (json['date'] as String?) ?? '',
      videoUrl: (json['videoUrl'] as String?) ?? '',
      coverUrl: (json['coverUrl'] as String?) ?? '',
    );
  }
}