
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/services/api_service.dart';
import 'package:uteq_news_app/screens/splash_screen.dart'; // NUEVO: Importar SplashScreen
import 'package:uteq_news_app/providers/auth_provider.dart'; // NUEVO: Importar AuthProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTEQNewsApp',
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      theme: ThemeData(
        primaryColor: AppColors.primaryGreen,
        hintColor: AppColors.secondaryGreen,
        scaffoldBackgroundColor: AppColors.lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textWhite,
        ),
        textTheme: const TextTheme(
          headlineLarge: AppStyles.headline1,
          headlineMedium: AppStyles.headline2,
          titleMedium: AppStyles.subTitle,
          bodyLarge: AppStyles.bodyText,
          labelLarge: AppStyles.buttonText,
        ),
        // Puedes añadir más configuraciones de tema aquí
      ),
      home: const SplashScreen(), // Establece SplashScreen como la pantalla inicial
    );
  }
}
