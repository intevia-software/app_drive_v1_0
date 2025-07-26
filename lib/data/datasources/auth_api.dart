import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import 'package:app_drive_v1_0/domain/entities/user.dart';

class AuthApi {
  Future<User> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Réponse login status: ${response.statusCode}');
      print('Réponse login data: ${response.data}');

      // Supposons que tu récupères un token dans response.data['token']
      final token = response.data['token'];
      if (token == null) {
        throw Exception('Token non reçu');
      }

      // Récupération des infos utilisateur via /me avec le token
      final userResponse = await ApiClient.dio.get(
        '/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('User data: ${userResponse.data}');

      return User.fromJson(userResponse.data);
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
}
