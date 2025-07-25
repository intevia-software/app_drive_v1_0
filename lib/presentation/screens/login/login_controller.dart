import '../../../domain/usecases/login_user.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final LoginUser loginUser;

  LoginController(this.loginUser);

  bool isLoading = false;
  String? error;

  Future<void> login(String email, String password) async {
      print('login() called'); // 👈 test de déclenchement
  isLoading = true;
  error = null;
  notifyListeners();

  try {
    final data = await loginUser(email, password);
    print("Login success: $data");
  } catch (e) {
    error = e.toString();
    print("Login error: $error"); // 👈 log d'erreur
  } finally {
    isLoading = false;
    notifyListeners();
  }
  }
}
