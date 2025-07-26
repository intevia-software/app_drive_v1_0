// lib/presentation/screens/validate/validate_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'validate_controller.dart';

class ValidateScreen extends StatelessWidget {
  const ValidateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ValidateController(),
      child: Consumer<ValidateController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(title: const Text('Validation Page')),
            body: Center(
              child: controller.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: controller.validateAction,
                      child: const Text('Lancer validation'),
                    ),
            ),
          );
        },
      ),
    );
  }
}