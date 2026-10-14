import 'dart:io';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

class ApiErrorHandler {
  ApiErrorHandler._();

  static ApiException handle(dynamic error) {
    if (error is ApiException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is SocketException) {
      return ApiException(
        message: 'No internet connection. Please check your network settings.',
      );
    }

    return ApiException(
      message:
          error?.toString() ??
          'An unexpected error occurred. Please try again.',
    );
  }

  static ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timeout with server. Please try again later.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timeout in connection with server.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timeout in connection with server.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'SSL certificate verification failed.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request to server was cancelled.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ApiException(
            message: 'No internet connection. Please check your network.',
          );
        }
        return ApiException(
          message:
              'Unexpected network error occurred: ${error.message ?? 'Unknown error'}',
          statusCode: error.response?.statusCode,
        );
    }
  }

  static ApiException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String errorMessage = 'Server returned an error ($statusCode).';

    if (data != null) {
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message') && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else if (data.containsKey('detail') && data['detail'] != null) {
          errorMessage = data['detail'].toString();
        } else if (data.containsKey('error') && data['error'] != null) {
          final err = data['error'];
          errorMessage = err is Map ? _extractFirstError(err) : err.toString();
        } else if (data.containsKey('errors') && data['errors'] != null) {
          final errs = data['errors'];
          if (errs is Map) {
            errorMessage = _extractFirstError(errs);
          } else if (errs is List && errs.isNotEmpty) {
            errorMessage = errs.first.toString();
          }
        } else {
          // Check for validation errors format e.g. {"field": ["error message"]}
          final extracted = _extractFirstError(data);
          if (extracted.isNotEmpty) {
            errorMessage = extracted;
          }
        }
      } else if (data is String && data.trim().isNotEmpty) {
        if (!data.contains('<!DOCTYPE') && !data.contains('<html')) {
          errorMessage = data.trim();
        }
      }
    } else {
      switch (statusCode) {
        case 400:
          errorMessage = 'Bad request. Please check your input.';
          break;
        case 401:
          errorMessage = 'Unauthorized. Please log in again.';
          break;
        case 403:
          errorMessage =
              'Forbidden. You do not have permission to access this.';
          break;
        case 404:
          errorMessage = 'Requested resource not found.';
          break;
        case 500:
          errorMessage = 'Internal server error. Please try again later.';
          break;
        case 502:
          errorMessage = 'Bad gateway. The server is temporarily unavailable.';
          break;
        case 503:
          errorMessage =
              'Service temporarily unavailable. Please try again later.';
          break;
      }
    }

    return ApiException(
      message: errorMessage,
      statusCode: statusCode,
      data: data,
    );
  }

  static String _extractFirstError(Map map) {
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        return '${value.first}';
      } else if (value is String && value.isNotEmpty) {
        return value;
      } else if (value is Map && value.isNotEmpty) {
        return _extractFirstError(value);
      }
    }
    return '';
  }
}
