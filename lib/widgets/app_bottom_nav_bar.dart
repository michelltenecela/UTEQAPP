
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uteq_news_app/theme/app_colors.dart';

class AppBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      selectedItemColor: AppColors.activeTint,
      unselectedItemColor: AppColors.inactiveTint,
      backgroundColor: AppColors.lightBackground,
      type: BottomNavigationBarType.fixed, // Para mostrar todos los labels
      items: [
        // CORREGIDO: Eliminado const de la lista y de BottomNavigationBarItem e Icon
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.comments),
          label: 'Chat/Dudas',
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.account),
          label: 'Perfil',
        ),
      ],
    );
  }
}
