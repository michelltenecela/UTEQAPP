
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_card.dart';

class MagazineCard extends StatelessWidget {
  final int year;
  final int month;
  final String coverUrl;
  final String pdfUrl;

  const MagazineCard({
    super.key,
    required this.year,
    required this.month,
    required this.coverUrl,
    required this.pdfUrl,
  });

  String _getMonthName(int month) {
    const List<String> monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return monthNames[month - 1]; // month es 1-12, lista es 0-11
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      borderRadius: 15.0, // Bordes más redondeados
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65, // Ancho para carrusel
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // Bordes redondeados para la imagen
              child: Image.network(
                coverUrl,
                height: 240, // Altura ajustada para el carrusel de 420
                width: double.infinity,
                fit: BoxFit.contain, // CORREGIDO: Cambiado a BoxFit.contain
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: AppColors.borderColor,
                  child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Edición ${ _getMonthName(month) } $year',
              style: AppStyles.subTitle.copyWith(fontSize: 17, color: AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            const Spacer(), // Empuja el botón hacia abajo
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
                  onPressed: () => _launchURL(pdfUrl),
                  icon: const Icon(FontAwesomeIcons.book, size: 16, color: AppColors.textWhite),
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
