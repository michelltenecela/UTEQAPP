
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_input_field.dart';
import 'package:uteq_news_app/widgets/custom_button.dart';
import 'package:uteq_news_app/services/api_service.dart';

class ResetPasswordModal extends StatefulWidget {
  final String email;

  const ResetPasswordModal({super.key, required this.email});

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  bool _showNewPassword = false;
  bool _showConfirmNewPassword = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
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

  bool _isValidPassword(String value) {
    final regex = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,15}$');
    return regex.hasMatch(value);
  }

  Future<void> _handleResetPassword() async {
    if (_tokenController.text.isEmpty || _newPasswordController.text.isEmpty || _confirmNewPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, completa todos los campos.';
      });
      return;
    }

    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      setState(() {
        _errorMessage = 'Las nuevas contraseñas no coinciden.';
      });
      return;
    }

    if (!_isValidPassword(_newPasswordController.text)) {
      setState(() {
        _errorMessage = 'La nueva clave debe tener entre 8 y 15 caracteres y contener letras mayúsculas, minúsculas, números y caracteres especiales.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final response = await apiService.resetPassword(
        widget.email,
        _tokenController.text,
        _newPasswordController.text,
      );
      if (!mounted) return;
      _showSnackBar(response['message'] ?? 'Contraseña restablecida exitosamente.');
      Navigator.pop(context); // Cierra el modal de reseteo
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
              'Establecer Nueva Contraseña',
              style: AppStyles.headline1.copyWith(color: AppColors.primaryGreen),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Ingresa el código recibido y tu nueva contraseña.',
              style: AppStyles.bodyText.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomInputField(
              controller: _tokenController,
              hintText: 'Código de Reseteo',
              prefixIcon: FontAwesomeIcons.key,
              keyboardType: TextInputType.text,
            ),
            CustomInputField(
              controller: _newPasswordController,
              hintText: 'Nueva Contraseña',
              obscureText: !_showNewPassword,
              prefixIcon: FontAwesomeIcons.lock,
              suffixIcon: Icon(
                _showNewPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onSuffixIconPressed: () {
                setState(() {
                  _showNewPassword = !_showNewPassword;
                });
              },
            ),
            CustomInputField(
              controller: _confirmNewPasswordController,
              hintText: 'Confirmar Nueva Contraseña',
              obscureText: !_showConfirmNewPassword,
              prefixIcon: FontAwesomeIcons.lock,
              suffixIcon: Icon(
                _showConfirmNewPassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onSuffixIconPressed: () {
                setState(() {
                  _showConfirmNewPassword = !_showConfirmNewPassword;
                });
              },
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
                    text: 'Restablecer', // CORREGIDO: Texto del botón
                    onPressed: _handleResetPassword,
                    isLoading: _isLoading,
                    backgroundColor: AppColors.primaryGreen,
                    textColor: AppColors.textWhite,
                    icon: FontAwesomeIcons.check,
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
