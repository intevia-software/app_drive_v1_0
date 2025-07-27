import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import 'package:app_drive_v1_0/domain/entities/user.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';




class AuthApi {




  String? _token;
  User? _currentUser;

  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isAdmin => _currentUser?.roles.contains('ROLE_ADMIN') ?? false;

  Future<void> init() async {
    _token = StorageService.getToken();
    if (_token != null) {
      try {
        final userResponse = await ApiClient.dio.get(
          '/me',
          options: Options(
            headers: {'Authorization': 'Bearer $_token'},
          ),
        );

        _currentUser = User.fromJson(userResponse.data);
      } catch (e) {
        // Token invalide : on l'efface
        _token = null;
        _currentUser = null;
        await StorageService.clearToken();
      }
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      _token = response.data['token'];

      if (_token == null) {
        throw Exception('Token non reçu');
      }else {
        await StorageService.saveToken(_token);
      }

      final userResponse = await ApiClient.dio.get(
        '/me',
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
        ),
      );

      _currentUser = User.fromJson(userResponse.data);
      return _currentUser!;
    } on DioException catch (e) {
      print('Erreur Dio: ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required List<String> roles,
    required String token,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/users',
        data: {
          "email": email,
          "password": password,
          "roles": roles,
          "firstName": firstName,
          "lastName": lastName,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/ld+json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response?.data ?? 'Échec de l’enregistrement');
    }
  }

  void logout() {
    _token = null;
    _currentUser = null;
    StorageService.clearToken();

  }
}


  //final AuthApi authApi = AuthApi();