import '../../../domain/usecases/login_user.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final LoginUser loginUser;

  LoginController(this.loginUser);

  bool isLoading = false;
  String? error;

  Future<void> login(String email, String password, BuildContext context) async {

    print("➡️ Début login"); // 
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await loginUser(email, password);
      if (user.isAdmin) {
        print("🔐 Redirection admin");

        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        error = "Accès refusé : rôle non autorisé.";
        print("⛔ Rôle non admin");

      }
    } catch (e, stack) {
      error = 'Erreur de connexion : $e';
      print("❌ Erreur login: $e");
      print(stack); // Pour voir la source exacte

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
