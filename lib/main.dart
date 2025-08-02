import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/data/repositories/auth_repository.dart';
import 'package:app_drive_v1_0/domain/usecases/login_user.dart';
import 'package:app_drive_v1_0/domain/usecases/register_user.dart';
import 'package:app_drive_v1_0/presentation/screens/login/login_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_controller.dart';
import 'package:app_drive_v1_0/presentation/screens/register/register_admin_controller.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';
import 'package:app_drive_v1_0/presentation/routes/app_router.dart';
import 'package:app_drive_v1_0/injection/injection.dart';
import 'package:provider/provider.dart';
import 'data/datasources/auth_api.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les services et dépendances
  await StorageService.init(); // Doit être async
  setupDependencies();

  final authApi = getIt<AuthApi>();
  await authApi.init(); // Token + utilisateur si dispo

  // Injection manuelle pour login/register (peut être migré vers get_it aussi)
  final authRepo = AuthRepository(authApi);
  final loginUseCase = LoginUser(authRepo);
  final registerUseCase = RegisterUser(authRepo);

  final loginController = LoginController(loginUseCase);
  final registerController = RegisterController(registerUseCase);
  final registerAdminController = RegisterAdminController(registerUseCase);

 // Désactiver la rotation, forcer mode portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // optionnel
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => loginController),
        ChangeNotifierProvider(create: (_) => registerController),
        ChangeNotifierProvider(create: (_) => registerAdminController),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print('Lien reçu : $uri');
        // Exemple : myapp://reset-password
        if (uri.path == "/reset-password") {
          // Redirige vers l'écran de réinitialisation
        }
      }
    }, onError: (err) {
      print("Erreur de lien : $err");
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Drive',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false,),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
