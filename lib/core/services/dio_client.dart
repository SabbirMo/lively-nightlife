import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/auth_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio? _dio;
  static Dio? _dioWithoutAuth;

  static const Duration _timeout = Duration(seconds: 30);

  /// Authenticated Dio instance with AuthInterceptor
  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: _timeout,
          receiveTimeout: _timeout,
          sendTimeout: _timeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      _dio!.interceptors.add(AuthInterceptor(_dio!));

      if (kDebugMode) {
        _dio!.interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: false,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: false,
          ),
        );
      }
    }
    return _dio!;
  }

  /// Unauthenticated Dio instance for public endpoints (login, signup, OTP verification, etc.)
  static Dio get instanceWithoutAuth {
    if (_dioWithoutAuth == null) {
      _dioWithoutAuth = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: _timeout,
          receiveTimeout: _timeout,
          sendTimeout: _timeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (kDebugMode) {
        _dioWithoutAuth!.interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: false,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: false,
          ),
        );
      }
    }
    return _dioWithoutAuth!;
  }

  /// Reset Dio instances on logout or URL change
  static void reset() {
    _dio?.close();
    _dio = null;
    _dioWithoutAuth?.close();
    _dioWithoutAuth = null;
  }
}
