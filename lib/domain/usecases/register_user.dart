import '../../data/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Map<String, dynamic>> call({
    required String email,
    required String password,
    required List<String> roles,
    required String token,
    required String firstName,
    required String lastName,
  }) {
    return repository.register(
      email: email,
      password: password,
      roles: roles,
      token: token,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
