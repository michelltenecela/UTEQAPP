import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uteq_news_app/providers/auth_provider.dart';
import 'package:uteq_news_app/screens/auth/login_screen.dart';
import 'package:uteq_news_app/screens/home_screen.dart';
import 'package:uteq_news_app/screens/preferences_screen.dart';
import 'package:uteq_news_app/screens/menu_screen.dart';
import 'package:uteq_news_app/screens/profile_screen.dart';
import 'package:uteq_news_app/screens/chat_screen.dart';
import 'package:uteq_news_app/screens/explore_screen.dart';
import 'package:uteq_news_app/widgets/app_top_bar.dart'; // Mantener importación por si se usa en otro lugar
import 'package:uteq_news_app/widgets/app_bottom_nav_bar.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart'; // Importar AppStyles

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // index 0
    const ChatScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Si el usuario no está autenticado, redirigir al login
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('UTEQ', style: AppStyles.headline2.copyWith(color: AppColors.textWhite)),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}