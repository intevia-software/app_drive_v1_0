import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/data/datasources/auth_api.dart';
import 'package:app_drive_v1_0/data/repositories/auth_repository.dart';
import 'package:app_drive_v1_0/domain/usecases/login_user.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_screen.dart';

import 'package:provider/provider.dart';

void main() {
  final authApi = AuthApi();
  final authRepo = AuthRepository(authApi);
  final loginUseCase = LoginUser(authRepo);
  final loginController = LoginController(loginUseCase);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => loginController)],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Écran de démarrage
      debugShowCheckedModeBanner: false,
    );
  }
}