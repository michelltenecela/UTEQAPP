
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_card.dart';

class NewsCard extends StatelessWidget {
  final String id;
  final String title;
  final String date;
  final String newsUrl;
  final String coverUrl;
  final String? departmentName;
  final String? categoryName;
  final String? categoryColor;

  const NewsCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.newsUrl,
    required this.coverUrl,
    this.departmentName,
    this.categoryName,
    this.categoryColor,
  });

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color categoryBgColor = AppColors.primaryGreen; // Color por defecto
    if (categoryColor != null && categoryColor!.startsWith('#')) {
      try {
        // Convertir color hexadecimal a Color de Flutter
        categoryBgColor = Color(int.parse(categoryColor!.substring(1, 7), radix: 16) + 0xFF000000);
      } catch (e) {
        print('Error al parsear categoryColor: $e');
      }
    }

    return CustomCard(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      borderRadius: 15.0, // Bordes más redondeados
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65, // Ancho ligeramente mayor para carrusel
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // Bordes redondeados para la imagen
              child: Image.network(
                coverUrl,
                height: 200, // Altura ajustada para el carrusel de 420
                width: double.infinity,
                fit: BoxFit.contain, // CORREGIDO: Cambiado a BoxFit.contain
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.borderColor,
                  child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: AppStyles.subTitle.copyWith(fontSize: 17, color: AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6.0),
            if (departmentName != null && departmentName!.isNotEmpty)
              Text(
                departmentName!,
                style: AppStyles.bodyText.copyWith(fontSize: 13, color: AppColors.textSecondary),
              ),
            const SizedBox(height: 4.0),
            if (categoryName != null && categoryName!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryBgColor.withOpacity(0.8), // Color de categoría con opacidad
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  categoryName!,
                  style: AppStyles.bodyText.copyWith(fontSize: 12, color: AppColors.textWhite, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 8.0), // Espacio antes de la fecha
            Text(
              date,
              style: AppStyles.bodyText.copyWith(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8.0), // Espacio antes del botón
            Align(
              alignment: Alignment.bottomCenter, // Centrar el botón
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.secondaryGreen], // Degradado
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(newsUrl),
                  icon: const Icon(FontAwesomeIcons.arrowRight, size: 16, color: AppColors.textWhite),
                  label: Text('Leer más', style: AppStyles.buttonText.copyWith(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fondo transparente para mostrar el gradiente
                    shadowColor: Colors.transparent, // Sin sombra propia del botón
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
