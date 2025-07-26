import '../datasources/auth_api.dart';
import '../../domain/entities/user.dart';


class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

    Future<User> login(String email, String password) {
    return api.login(email, password); // api.login retourne maintenant User
  }


  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required List<String> roles,
    required String token,
    required String firstName,
    required String lastName,
  }) {
    return api.register(
      email: email,
      password: password,
      roles: roles,
      token: token,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

