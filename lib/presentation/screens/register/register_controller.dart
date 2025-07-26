import 'package:flutter/material.dart';
import '../../../domain/usecases/register_user.dart';

class RegisterController extends ChangeNotifier {
  final RegisterUser registerUser;

  RegisterController(this.registerUser);

  bool isLoading = false;
  String? error;

  Future<bool> register({
    required String email,
    required String password,
    required List<String> roles,
    required String token,
    required String firstName,
    required String lastName,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await registerUser(
        email: email,
        password: password,
        roles: roles,
        token: token,
        firstName: firstName,
        lastName: lastName,
      );

      print('Inscription réussie : $result');
      return true; // L’appelant (vue) peut naviguer après ça
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
