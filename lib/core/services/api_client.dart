import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://driving.ovh/api',
      contentType: 'application/json',
    ),
  );
}

