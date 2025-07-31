import '../../../domain/usecases/login_user.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final LoginUser loginUser;

  LoginController(this.loginUser);

  bool isLoading = false;
  String? error;

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    print("➡️ Début login");

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await loginUser(email, password);

      if (user.isAdmin) {
        print("🔐 Redirection admin");
        Navigator.pushReplacementNamed(context, '/admin');
        return true;
      } else if (user.isAdmin == false &&
          user.accepted == true &&
          user.block == null) {
        Navigator.pushReplacementNamed(context, '/user');
        return false;
      } else {
        error = "Accès refusé";
        return false;
      }
    } catch (e, stack) {
      error = 'Email ou mot de passe incorrect !';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
