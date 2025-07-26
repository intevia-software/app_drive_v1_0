// lib/presentation/screens/validate/validate_controller.dart
import 'package:flutter/material.dart';

class ValidateController extends ChangeNotifier {
  bool isLoading = false;

  Future<void> validateAction() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulation

    isLoading = false;
    notifyListeners();
  }
}