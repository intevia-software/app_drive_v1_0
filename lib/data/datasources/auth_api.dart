import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';

class AuthApi {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }
}
