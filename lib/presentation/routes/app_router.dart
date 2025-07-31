// lib/presentation/routes/app_router.dart

import 'package:app_drive_v1_0/presentation/screens/deblock/deblock_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/data/datasources/auth_api.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/validate/validate_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/block/block_user_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/denied/denied_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_admin_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_success_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/admin/admin_home_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/user/user_home_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/question/question_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/response/response_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/test/test_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/show_questions/show_questions_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/error/connexion_error_screen.dart';
import 'package:app_drive_v1_0/injection/injection.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final authApi = getIt<AuthApi>();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/error_connexion':
        return MaterialPageRoute(builder: (_) =>  ConnexionErrorScreen());

      case '/success_user':
        return MaterialPageRoute(builder: (_) =>  RegisterSuccessScreen());


      case '/test_user':
        if (authApi.isAdmin == false  && authApi.currentUser?.accepted == true && authApi.currentUser?.block == null) {
          return MaterialPageRoute(builder: (_) => TestScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/user':
        if (authApi.isAdmin == false  && authApi.currentUser?.accepted == true && authApi.currentUser?.block == null ) {
          return MaterialPageRoute(builder: (_) => UserHomeScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/show_questions':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) => ShowQuestionsScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }
      case '/register_admin':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) => RegisterAdminScreen());
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

      case '/block_user':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) =>  BlockUserScreen());
        } else {
          return MaterialPageRoute(
            builder: (_) => const DeniedScreen(),
          );
        }

      case '/deblock_user':
        if (authApi.isAdmin) {
          return MaterialPageRoute(builder: (_) =>  DeblockUserScreen());
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
