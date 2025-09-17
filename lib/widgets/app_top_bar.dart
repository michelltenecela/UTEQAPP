
import 'package:flutter/material.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;

  const AppTopBar({
    Key? key,
    this.title,
    this.onMenuPressed,
    this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.lightBackground,
      elevation: 0, // Sin sombra
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textPrimary), // Icono de menú
        onPressed: onMenuPressed ?? () { /* Implementar apertura de menú lateral */ },
      ),
      title: title != null
          ? Text(title!,
              style: AppStyles.subTitle.copyWith(color: AppColors.primaryGreen))
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textPrimary), // Icono de búsqueda
          onPressed: onSearchPressed ?? () { /* Implementar búsqueda */ },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
