import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://localhost:8000/api',
      contentType: 'application/json',
    ),
  );
}
