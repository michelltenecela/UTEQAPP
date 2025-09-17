import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_input_field.dart';
import 'package:uteq_news_app/widgets/custom_button.dart';
import 'package:uteq_news_app/services/api_service.dart';

class VerifyEmailModal extends StatefulWidget {
  final String email;

  const VerifyEmailModal({super.key, required this.email}); // CORREGIDO: Usar super.key

  @override
  State<VerifyEmailModal> createState() => _VerifyEmailModalState();
}

class _VerifyEmailModalState extends State<VerifyEmailModal> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // CORREGIDO: Check mounted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleVerify() async {
    if (_codeController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa el código de verificación.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.verifyEmail(
        widget.email,
        _codeController.text,
      );
      if (!mounted) return; // CORREGIDO: Check mounted
      _showSnackBar(response['message'] ?? 'Correo verificado exitosamente.');
      Navigator.pop(context); // Cierra el modal de verificación
      // TODO: Podrías navegar a la pantalla principal aquí si el flujo lo requiere
    } catch (e) {
      if (!mounted) return; // CORREGIDO: Check mounted
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
          left: 20,
          right: 20,
          top: 20,
        ),
        decoration: const BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Verificación de Usuario',
              style: AppStyles.headline2.copyWith(color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 20),
            CustomInputField(
              controller: _codeController,
              hintText: 'Código de verificación',
              prefixIcon: FontAwesomeIcons.key,
              keyboardType: TextInputType.number,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage!,
                  style: AppStyles.bodyText.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            CustomButton(
              text: 'Validar Usuario',
              onPressed: _handleVerify,
              isLoading: _isLoading,
              backgroundColor: AppColors.primaryGreen,
              textColor: AppColors.textWhite,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}