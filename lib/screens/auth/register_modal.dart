
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uteq_news_app/theme/app_colors.dart';
import 'package:uteq_news_app/theme/app_styles.dart';
import 'package:uteq_news_app/widgets/custom_input_field.dart';
import 'package:uteq_news_app/widgets/custom_button.dart';
import 'package:uteq_news_app/services/api_service.dart';
import 'package:uteq_news_app/screens/auth/verify_email_modal.dart';

class RegisterModal extends StatefulWidget {
  final VoidCallback? onClose;

  const RegisterModal({super.key, this.onClose});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _selectedType = 'institucional';
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
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

  bool _isValidName(String value) {
    final regex = RegExp(r'^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]+$');
    return regex.hasMatch(value);
  }

  bool _isValidEmail(String value) {
    final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return regex.hasMatch(value);
  }

  bool _isValidPassword(String value) {
    final regex = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,15}$');
    return regex.hasMatch(value);
  }

  Future<void> _handleRegister() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Validaciones de campos vacíos y formato de email
    if (_nameController.text.isEmpty || !_isValidName(_nameController.text)) {
      _errorMessage = 'Por favor, ingresa un nombre válido.';
    } else if (_lastNameController.text.isEmpty || !_isValidName(_lastNameController.text)) {
      _errorMessage = 'Por favor, ingresa un apellido válido.';
    } else if (!_isValidEmail(_emailController.text)) {
      _errorMessage = 'Por favor, ingresa un correo válido.';
    } else if (!_isValidPassword(_passwordController.text)) {
      _errorMessage = 'La clave debe tener entre 8 y 15 caracteres y contener letras mayúsculas, minúsculas, números y caracteres especiales.';
    } else if (_selectedType == 'institucional' && _passwordController.text != _confirmPasswordController.text) {
      _errorMessage = 'Las claves no coinciden.';
    }

    // Validaciones de dominio de correo
    if (_errorMessage == null) {
      if (_selectedType == 'institucional') {
        if (!_emailController.text.endsWith('@uteq.edu.ec')) {
          _errorMessage = 'Para registro institucional, el correo debe ser @uteq.edu.ec.';
        }
      }
    } else if (_selectedType == 'publico') {
      final allowedDomains = ['gmail.com', 'hotmail.com', 'yahoo.com', 'outlook.com', 'outlook.es'];
      final emailDomain = _emailController.text.split('@').last.toLowerCase();
      if (!allowedDomains.contains(emailDomain)) {
        _errorMessage = 'El correo público debe tener uno de los siguientes dominios: @gmail.com, @hotmail.com, @yahoo.com, @outlook.com, @outlook.es';
      } else if (_emailController.text.endsWith('@uteq.edu.ec')) {
        _errorMessage = 'Para registro público, el correo no puede ser @uteq.edu.ec.';
      }
    }

    if (_errorMessage != null) {
      setState(() { _isLoading = false; });
      return;
    }

    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final userData = {
        'nombre': _nameController.text,
        'apellido': _lastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      final response = await apiService.registerUser(userData);
      if (!mounted) return;
      _showSnackBar(response['message'] ?? 'Registro exitoso. Revisa tu correo.');

      Navigator.pop(context);
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => VerifyEmailModal(email: _emailController.text),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString(), isError: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25,
          right: 25,
          top: 30,
        ),
        decoration: BoxDecoration(
          color: AppColors.veryLightBackground, // Fondo más claro para el modal
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Bordes más redondeados
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
              'Crear Cuenta',
              style: AppStyles.headline1.copyWith(color: AppColors.primaryGreen), // Título más grande y verde
            ),
            const SizedBox(height: 30),
            // Opciones de radio (Institucional/Público)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRadioOption('institucional', 'Institucional', screenWidth),
                const SizedBox(width: 20), // Separación entre radio buttons
                _buildRadioOption('publico', 'Público', screenWidth),
              ],
            ),
            const SizedBox(height: 30),
            // Campos de entrada
            CustomInputField(
              controller: _nameController,
              hintText: 'Nombre',
              prefixIcon: FontAwesomeIcons.user,
              keyboardType: TextInputType.name,
            ),
            CustomInputField(
              controller: _lastNameController,
              hintText: 'Apellido',
              prefixIcon: FontAwesomeIcons.user,
              keyboardType: TextInputType.name,
            ),
            CustomInputField(
              controller: _emailController,
              hintText: 'Correo',
              prefixIcon: FontAwesomeIcons.envelope,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomInputField(
              controller: _passwordController,
              hintText: 'Clave',
              obscureText: !_showPassword,
              prefixIcon: FontAwesomeIcons.lock,
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
            if (_selectedType == 'institucional')
              CustomInputField(
                controller: _confirmPasswordController,
                hintText: 'Repetir Clave',
                obscureText: !_showConfirmPassword,
                prefixIcon: FontAwesomeIcons.lock,
                suffixIcon: Icon(
                  _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                ),
                onSuffixIconPressed: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _errorMessage!,
                  style: AppStyles.bodyText.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            // Botones de Registrar y Cerrar en una fila
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Registrar',
                    onPressed: _handleRegister,
                    isLoading: _isLoading,
                    backgroundColor: AppColors.primaryGreen,
                    textColor: AppColors.textWhite,
                    icon: FontAwesomeIcons.userPlus, // Icono para Registrar
                    padding: const EdgeInsets.symmetric(vertical: 18), // Ajustar padding
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(width: 15), // Espacio entre botones
                Expanded(
                  child: CustomButton(
                    text: 'Cerrar',
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onClose?.call();
                    },
                    backgroundColor: AppColors.errorRed,
                    textColor: AppColors.textWhite,
                    icon: FontAwesomeIcons.times, // Icono para Cerrar
                    padding: const EdgeInsets.symmetric(vertical: 18), // Ajustar padding
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

  Widget _buildRadioOption(String type, String label, double screenWidth) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: _selectedType == type ? AppColors.primaryGreen : AppColors.inputBackgroundLight, // Color de fondo
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
            border: Border.all(
              color: _selectedType == type ? AppColors.primaryGreen : AppColors.borderColor, // Borde
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _selectedType == type ? Icons.radio_button_checked : Icons.radio_button_off,
                color: _selectedType == type ? AppColors.textWhite : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppStyles.bodyText.copyWith(
                  color: _selectedType == type ? AppColors.textWhite : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
