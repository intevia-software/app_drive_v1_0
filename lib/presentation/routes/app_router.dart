// lib/presentation/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/data/datasources/auth_api.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/validate/validate_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/denied/denied_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_success_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/admin/admin_home_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/user/user_home_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/question/question_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/response/response_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/test/test_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/error/connexion_error_screen.dart';
import 'package:app_drive_v1_0/injection/injection.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final authApi = getIt<AuthApi>();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/error_connexion':
        return MaterialPageRoute(builder: (_) =>  ConnexionErrorScreen());

      case '/success_user':
        return MaterialPageRoute(builder: (_) =>  RegisterSuccessScreen());


      case '/test_user':
        if (authApi.isAdmin == false  && authApi.currentUser?.accepted == true ) {
          return MaterialPageRoute(builder: (_) => TestScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/user':
        if (authApi.isAdmin == false  && authApi.currentUser?.accepted == true ) {
          return MaterialPageRoute(builder: (_) => UserHomeScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/test_admin':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) => TestScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/validate':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) =>  ValidateScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/put_question':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) =>  QuestionScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }


      case '/put_response':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) =>  ResponseScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/admin':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) =>  AdminHomeScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => const DeniedScreen(),
        );
    }
  }
}
