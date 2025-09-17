
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_input_field.dart';
import 'package:uteq_news_app/widgets/custom_button.dart';
import 'package:uteq_news_app/services/api_service.dart';
import 'package:uteq_news_app/screens/auth/reset_password_modal.dart';

class RequestResetModal extends StatefulWidget {
  const RequestResetModal({super.key});

  @override
  State<RequestResetModal> createState() => _RequestResetModalState();
}

class _RequestResetModalState extends State<RequestResetModal> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleRequestReset() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa tu correo electrónico.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.requestPasswordReset(_emailController.text);
      if (!mounted) return;
      _showSnackBar(response['message'] ?? 'Solicitud enviada. Revisa tu correo.');

      Navigator.pop(context);
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ResetPasswordModal(email: _emailController.text),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
      _showSnackBar(e.toString(), isError: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25,
          right: 25,
          top: 30,
        ),
        decoration: BoxDecoration(
          color: AppColors.textWhite, // Fondo blanco sólido
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Restablecer Contraseña',
              style: AppStyles.headline1.copyWith(color: AppColors.primaryGreen), // Título más grande y verde
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Ingresa tu correo electrónico para recibir un código de restablecimiento.',
              style: AppStyles.bodyText.copyWith(color: AppColors.textPrimary), // Texto más claro
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomInputField(
              controller: _emailController,
              hintText: 'Correo Electrónico',
              prefixIcon: FontAwesomeIcons.envelope,
              keyboardType: TextInputType.emailAddress,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  _errorMessage!,
                  style: AppStyles.bodyText.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            // Botones en una fila
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Solicitar Reseteo',
                    onPressed: _handleRequestReset,
                    isLoading: _isLoading,
                    backgroundColor: AppColors.primaryGreen,
                    textColor: AppColors.textWhite,
                    icon: FontAwesomeIcons.paperPlane,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(width: 15), // Espacio entre botones
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.errorRed,
                    textColor: AppColors.textWhite,
                    icon: FontAwesomeIcons.times,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
