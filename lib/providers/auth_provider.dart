
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para jsonEncode y jsonDecode

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user; // Información del usuario logueado

  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _user != null;

  // Cargar la sesión del usuario desde SharedPreferences
  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      _user = jsonDecode(userDataString);
      notifyListeners();
    }
  }

  // Iniciar sesión y guardar datos del usuario
  Future<void> login(Map<String, dynamic> userData) async {
    _user = userData;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', jsonEncode(userData));
    notifyListeners();
  }

  // Cerrar sesión y limpiar datos
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }
}
