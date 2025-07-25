import '../datasources/auth_api.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

  Future<Map<String, dynamic>> login(String email, String password) {
    return api.login(email, password);
  }
}
