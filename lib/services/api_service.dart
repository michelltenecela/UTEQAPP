
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Importar los nuevos modelos
import 'package:uteq_news_app/models/news_model.dart';
import 'package:uteq_news_app/models/weekly_summary_model.dart';
import 'package:uteq_news_app/models/magazine_model.dart';
import 'package:uteq_news_app/models/tiktok_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://apiescuela.onrender.com';

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        print('Error en la petición: ${e.response?.statusCode} - ${e.message}');
        print('Response data: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  // --- Métodos de Autenticación ---

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/auth/register', data: userData);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al registrar usuario';
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    try {
      final response = await _dio.post('/auth/verify-email', data: { 'email': email, 'code': code });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al verificar correo';
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'usuario': email,       // backend espera 'usuario'
        'contraseña': password, // backend espera 'contraseña'
      },
    );

    final prefs = await SharedPreferences.getInstance();

    // Guardar usuario
    if (response.data['usuario'] != null) {
      await prefs.setString('userData', jsonEncode(response.data['usuario']));
    }

    // Guardar token
    final token = response.data['token'] ?? response.data['access_token'];
    if (token != null) {
      await prefs.setString('token', token);
    }

    return response.data;
  } on DioException catch (e) {
    throw e.response?.data['error'] ?? 'Error al iniciar sesión';
  }
}


  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  Future<Map<String, dynamic>> updateUser(String email, Map<String, dynamic> updateData) async {
    try {
      final response = await _dio.patch('/auth/update/$email', data: updateData);
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al actualizar usuario';
    }
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post('/auth/password/request-reset', data: { 'email': email });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al solicitar reseteo de contraseña';
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email, String token, String newPassword) async {
    try {
      final response = await _dio.post('/auth/password/reset', data: { 'email': email, 'token': token, 'newPassword': newPassword });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al resetear contraseña';
    }
  }

  // --- Métodos de Preferencias ---

  Future<Map<String, dynamic>> addPreference(String email, String careerName) async {
    try {
      final response = await _dio.post('/auth/preferences/add', data: { 'email': email, 'careerName': careerName });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al añadir preferencia';
    }
  }

  Future<Map<String, dynamic>> removePreference(String email, String careerName) async {
    try {
      final response = await _dio.post('/auth/preferences/remove', data: { 'email': email, 'careerName': careerName });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al eliminar preferencia';
    }
  }

  Future<Map<String, dynamic>> getPreferences(String email) async {
    try {
      final response = await _dio.get('/auth/preferences/$email');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener preferencias';
    }
  }

  // --- Métodos de Contenido ---

  Future<List<News>> getLatestNews() async {
    try {
      final response = await _dio.get('/news/latest');
      return (response.data as List).map((json) => News.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener últimas noticias';
    }
  }

  Future<List<News>> getAllNews() async {
    try {
      final response = await _dio.get('/news/all');
      return (response.data as List).map((json) => News.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener todas las noticias';
    }
  }

  Future<List<News>> getFilteredNews(String email) async {
    try {
      final response = await _dio.get('/news/filtered/$email');
      // Manejar el caso del mensaje de no coincidencias
      if (response.data is Map && response.data['message'] != null) {
        // Si el backend envía un mensaje de error/no coincidencias, lo lanzamos como excepción
        throw response.data['message'];
      }
      return (response.data as List).map((json) => News.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener noticias filtradas';
    }
  }

  Future<List<WeeklySummary>> getLatestWeeklySummaries() async {
    try {
      final response = await _dio.get('/videos/weekly-summaries/latest');
      return (response.data as List).map((json) => WeeklySummary.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener últimos resúmenes semanales';
    }
  }

  Future<List<WeeklySummary>> getAllWeeklySummaries() async {
    try {
      final response = await _dio.get('/videos/weekly-summaries/all');
      return (response.data as List).map((json) => WeeklySummary.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener todos los resúmenes semanales';
    }
  }

  Future<List<WeeklySummary>> getFilteredWeeklySummaries(String email) async {
    try {
      final response = await _dio.get('/videos/weekly-summaries/filtered/$email');
      if (response.data is Map && response.data['message'] != null) {
        throw response.data['message'];
      }
      return (response.data as List).map((json) => WeeklySummary.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener resúmenes semanales filtrados';
    }
  }

  Future<List<Magazine>> getLatestMagazines() async {
    try {
      final response = await _dio.get('/magazines/latest');
      return (response.data as List).map((json) => Magazine.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener últimas revistas';
    }
  }

  Future<List<Magazine>> getAllMagazines() async {
    try {
      final response = await _dio.get('/magazines/all');
      return (response.data as List).map((json) => Magazine.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener todas las revistas';
    }
  }

  Future<List<dynamic>> getFaculties() async {
    try {
      final response = await _dio.get('/faculties/all');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener facultades';
    }
  }

  Future<List<dynamic>> getCareers() async {
    try {
      final response = await _dio.get('/careers/all');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener carreras';
    }
  }

  Future<List<dynamic>> getCareersByFaculty(String facultyId) async {
    try {
      final response = await _dio.get('/careers/by-faculty/$facultyId');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener carreras por facultad';
    }
  }

  Future<List<TikTokVideo>> getLatestTikToks() async {
    try {
      final response = await _dio.get('/videos/tiktoks/latest');
      return (response.data as List).map((json) => TikTokVideo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener últimos TikToks';
    }
  }

  Future<List<TikTokVideo>> getAllTikToks() async {
    try {
      final response = await _dio.get('/videos/tiktoks/all');
      return (response.data as List).map((json) => TikTokVideo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener todos los TikToks';
    }
  }

  Future<List<TikTokVideo>> getFilteredTikToks(String email) async {
    try {
      final response = await _dio.get('/videos/tiktoks/filtered/$email');
      if (response.data is Map && response.data['message'] != null) {
        throw response.data['message'];
      }
      return (response.data as List).map((json) => TikTokVideo.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al obtener TikToks filtrados';
    }
  }

  // --- Métodos de IA ---

  Future<Map<String, dynamic>> askAI(String type, String name, String question) async {
    try {
      final response = await _dio.post('/ai/ask', data: { 'type': type, 'name': name, 'question': question });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Error al consultar a la IA';
    }
  }
}
