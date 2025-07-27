import 'package:get_it/get_it.dart';
import 'package:app_drive_v1_0/data/datasources/auth_api.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AuthApi>(() => AuthApi());
}
