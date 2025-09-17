import 'package:flutter/material.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryGreen,
        foregroundColor: textColor ?? AppColors.textWhite,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.25),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.textWhite,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center, // CORREGIDO: Centrar contenido horizontalmente
              mainAxisSize: MainAxisSize.min, // Mantener el tamaño mínimo para que el Expanded funcione
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor ?? AppColors.textWhite, size: 18),
                  const SizedBox(width: 8),
                ],
                Flexible( // CORREGIDO: Usar Flexible en lugar de Expanded para permitir que el texto no ocupe todo el espacio si es corto
                  child: Text(
                    text,
                    style: AppStyles.buttonText.copyWith(color: textColor ?? AppColors.textWhite),
                    textAlign: TextAlign.center, // CORREGIDO: Centrar el texto dentro de su Flexible
                  ),
                ),
              ],
            ),
    );
  }
}