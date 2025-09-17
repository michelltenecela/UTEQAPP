
import 'package:flutter/material.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;

  const CustomInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: AppStyles.inputDecoration,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppStyles.bodyText.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.bodyText.copyWith(color: AppColors.textSecondary),
          border: InputBorder.none, // Elimina el borde predeterminado
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textSecondary) : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: suffixIcon!,
                  onPressed: onSuffixIconPressed,
                )
              : null,
        ),
      ),
    );
  }
}
