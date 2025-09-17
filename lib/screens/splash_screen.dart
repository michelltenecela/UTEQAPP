
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uteq_news_app/providers/auth_provider.dart';
import 'package:uteq_news_app/screens/auth/login_screen.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'dart:ui'; // Importar para ImageFilter
import 'package:uteq_news_app/widgets/custom_button.dart';
import 'package:uteq_news_app/screens/main_app_screen.dart'; // Importar MainAppScreen

// REMOVIDO: HomeScreenPlaceholder se ha movido a main_app_screen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUserSession();

    // Asegurar que la splash screen sea visible por un tiempo mínimo
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      // Navegar a la pantalla principal de la app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainAppScreen()), // CORREGIDO: Navegar a MainAppScreen
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo de imagen
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Capa de desenfoque y oscuridad (similar al login)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo en contenedor cuadrado blanco transparente/difuminado (similar al login)
                Container(
                  width: screenWidth * 0.4, // Ajusta el tamaño del cuadrado
                  height: screenWidth * 0.4, // Asegura que sea cuadrado
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withOpacity(0.8), // Blanco con mayor opacidad
                    borderRadius: BorderRadius.circular(20), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Recorta la imagen si es más grande
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur para el contenedor
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Padding dentro del contenedor
                        child: Image.asset(
                          'assets/images/LogoUteq.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CircularProgressIndicator(color: AppColors.inputBackground),
                const SizedBox(height: 15),
                Text(
                  'Verificando sesión...',
                  style: AppStyles.bodyText.copyWith(color: AppColors.textWhite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
