import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

    Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
