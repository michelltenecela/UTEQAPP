
class Magazine {
  final int year;
  final int month;
  final String coverUrl;
  final String pdfUrl;

  Magazine({
    required this.year,
    required this.month,
    required this.coverUrl,
    required this.pdfUrl,
  });

  factory Magazine.fromJson(Map<String, dynamic> json) {
    return Magazine(
      year: (json['year'] as int?) ?? 0,
      month: (json['month'] as int?) ?? 0,
      coverUrl: (json['coverUrl'] as String?) ?? '', // CORREGIDO: Manejar null para String
      pdfUrl: (json['pdfUrl'] as String?) ?? '',
    );
  }
}
