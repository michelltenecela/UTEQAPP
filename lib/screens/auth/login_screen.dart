
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_input_field.dart';
import 'package:uteq_news_app/widgets/custom_button.dart';
import 'package:uteq_news_app/services/api_service.dart';
import 'package:uteq_news_app/screens/auth/register_modal.dart';
import 'package:uteq_news_app/screens/auth/verify_email_modal.dart';
import 'package:uteq_news_app/providers/auth_provider.dart';
import 'package:uteq_news_app/screens/auth/request_reset_modal.dart';
import 'package:uteq_news_app/screens/main_app_screen.dart'; // NUEVO: Importar MainAppScreen
import 'dart:ui'; // Importar para ImageFilter

// REMOVIDO: HomeScreenPlaceholder se ha movido a main_app_screen.dart

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Por favor, completa todos los campos.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiService = Provider.of<ApiService>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await apiService.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      // Guardar datos del usuario en AuthProvider y SharedPreferences
      await authProvider.login(response); 

      // Navegar a la pantalla principal de la app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainAppScreen()), // CORREGIDO: Navegar a MainAppScreen
      );
      _showSnackBar('Inicio de sesión exitoso!');
    } catch (e) {
      if (!mounted) return;
      if (e.toString().contains('verifica tu correo')) {
        _showVerificationModal();
      } else {
        _showSnackBar(e.toString(), isError: true);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showRegisterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RegisterModal(),
    );
  }

  void _showVerificationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => VerifyEmailModal(email: _emailController.text),
    );
  }

  void _showRequestResetModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RequestResetModal(),
    );
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
              'assets/images/fondo.png',
              fit: BoxFit.cover,
            ),
          ),
          // Capa de desenfoque y oscuridad
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Ajusta los valores de sigma para más o menos blur
              child: Container(
                color: const Color.fromARGB(255, 128, 127, 127).withOpacity(0.3), // Capa semi-transparente para reducir la oscuridad
              ),
            ),
          ),
          // Contenido principal con scroll
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight, // Asegura que el scroll ocupe al menos la altura de la pantalla
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05), // Espacio superior
                  // Logo en contenedor cuadrado blanco transparente/difuminado
                  Image.asset(
          'assets/images/LogoUteq.png',
          fit: BoxFit.contain,
          width: screenWidth * 0.4,
          height: screenWidth * 0.4,
        ),
        SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite.withOpacity(0.8), // Fondo semi-transparente más claro
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomInputField(
                          controller: _emailController,
                          hintText: 'Correo',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        CustomInputField(
                          controller: _passwordController,
                          hintText: 'Contraseña',
                          obscureText: !_showPassword,
                          prefixIcon: Icons.lock,
                          suffixIcon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomButton(
                          text: 'Iniciar Sesión',
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                          backgroundColor: AppColors.primaryGreen,
                          textColor: AppColors.textWhite,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.1),
                          borderRadius: 10,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        // Botones de Registrarse y Olvidé Contraseña en una fila
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextButton(
                                onPressed: _showRequestResetModal, // NUEVO: Abrir modal de reseteo
                                child: Text(
                                  '¿Has olvidado la contraseña?',
                                  style: AppStyles.linkText.copyWith(color: AppColors.primaryGreen),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: _showRegisterModal,
                                child: Text(
                                  'Registrarse',
                                  style: AppStyles.linkText.copyWith(color: AppColors.primaryGreen),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Espacio inferior
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
