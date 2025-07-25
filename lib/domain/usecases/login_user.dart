import '../../data/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Map<String, dynamic>> call(String email, String password) {
    return repository.login(email, password);
  }
}
