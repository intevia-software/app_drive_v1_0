import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/data/datasources/auth_api.dart';
import 'package:app_drive_v1_0/data/repositories/auth_repository.dart';
import 'package:app_drive_v1_0/domain/usecases/login_user.dart';
import 'package:app_drive_v1_0/domain/usecases/register_user.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_screen.dart';
import 'presentation/screens/register/register_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/admin/admin_home_screen.dart';
import 'presentation/screens/register/register_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_success_screen.dart';

import 'package:provider/provider.dart';

void main() {
  final authApi = AuthApi();
  final authRepo = AuthRepository(authApi);

  final loginUseCase = LoginUser(authRepo);
  final loginController = LoginController(loginUseCase);

  final registerUseCase = RegisterUser(authRepo);
  final registerController = RegisterController(registerUseCase);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => loginController),
        ChangeNotifierProvider(
          create: (_) => registerController,
        ), // ✅ Ajout ici
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Drive',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin': (context) => AdminHomeScreen(),
        '/success_user': (context) => RegisterSuccessScreen(),
      },
    );
  }
}
