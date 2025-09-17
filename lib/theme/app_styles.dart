
import 'package:flutter/material.dart';
import 'package:uteq_news_app/theme/app_colors.dart';

class AppStyles {
  // Estilos de texto
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 16,
    color: AppColors.primaryGreen,
    decoration: TextDecoration.underline,
  );

  // Decoraciones de caja (para tarjetas, contenedores, etc.)
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.textWhite,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration buttonDecoration = BoxDecoration(
    color: AppColors.primaryGreen,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration inputDecoration = BoxDecoration(
    color: AppColors.inputBackground,
    borderRadius: BorderRadius.circular(7),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ],
  );

  // Puedes añadir más estilos según sea necesario
}
