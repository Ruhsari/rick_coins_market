
import 'dart:math';

import 'package:dio/dio.dart';

class DioClient {
  static const String baseUrl = "https://rickandmortyapi.com/api";
  static final Dio _dio = _createDio();

  static Dio _createDio() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(
            "--> [DIO] REQUEST[${options.method}] => PATH: ${options.path}",
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            "<-- [DIO] REQUEST[${response.statusCode}] => PATH:"
                "${response.requestOptions.path}",
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            "<-- [DIO] ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}",
          );
            return handler.next(e);
            },
      ),
    );
    return dio;
  }
  static Dio get instance => _dio;
  static Dio getDio() => _dio;
}