import 'package:dio/dio.dart';
import 'package:app_drive_v1_0/core/services/globals.dart' as globals;

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${globals.domaine}/api',
      contentType: 'application/json',
    ),
  );
}

