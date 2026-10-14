import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_error_handler.dart';
import 'package:lively_nightlife_nightclub_party/core/services/base_url.dart';
import 'package:lively_nightlife_nightclub_party/core/services/dio_client.dart';
import 'package:lively_nightlife_nightclub_party/core/services/token_storage_service.dart';

void main() {
  group('Networking & Error Handler Tests', () {
    test('BaseUrl points to ApiEndpoints.baseUrl', () {
      expect(BaseUrl.baseUrl, equals(ApiEndpoints.baseUrl));
      expect(ApiBaseUrl.baseUrl, equals(ApiEndpoints.baseUrl));
    });

    test('DioClient instances initialization and singleton behavior', () {
      final client1 = DioClient.instance;
      final client2 = DioClient.instance;
      expect(identical(client1, client2), isTrue);

      final unauth1 = DioClient.instanceWithoutAuth;
      final unauth2 = DioClient.instanceWithoutAuth;
      expect(identical(unauth1, unauth2), isTrue);

      expect(identical(client1, unauth1), isFalse);

      expect(client1.options.baseUrl, equals(ApiEndpoints.baseUrl));
      expect(unauth1.options.baseUrl, equals(ApiEndpoints.baseUrl));
    });

    test('ApiErrorHandler handles timeout errors', () {
      final requestOptions = RequestOptions(path: '/test');
      final timeoutException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      final error = ApiErrorHandler.handle(timeoutException);
      expect(error.message, contains('Connection timeout'));
    });

    test('ApiErrorHandler extracts message from JSON response', () {
      final requestOptions = RequestOptions(path: '/login');
      final badResponseException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {'message': 'Invalid email or password.'},
        ),
      );

      final error = ApiErrorHandler.handle(badResponseException);
      expect(error.message, equals('Invalid email or password.'));
      expect(error.statusCode, equals(400));
    });

    test('ApiErrorHandler extracts field errors', () {
      final requestOptions = RequestOptions(path: '/signup');
      final badResponseException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'email': ['This email is already in use.']
          },
        ),
      );

      final error = ApiErrorHandler.handle(badResponseException);
      expect(error.message, equals('This email is already in use.'));
    });

    test('TokenStorageService.decodeJwt correctly extracts payload', () {
      const sampleAccessToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzkwODQ3NjE2LCJpYXQiOjE3ODk1NTE2MTYsImp0aSI6ImEzYTA3N2I0NDgyMzQyZjk4YjhhOWI0Njc1OGUwZDkyIiwidXNlcl9pZCI6Ijg0YWM5N2EwLTgzMTItNGRkMC1hODFhLTNiMjJlYTAzMDI1ZSIsImFjdGl2ZV9wcm9maWxlIjoidXNlciJ9.'
          'Yu30JeAfEX5DGkqYvOiLcwW_DL6NgUmJhWCSCIjMtJg';

      final payload = TokenStorageService.decodeJwt(sampleAccessToken);
      expect(payload, isNotNull);
      expect(payload!['user_id'], equals('84ac97a0-8312-4dd0-a81a-3b22ea03025e'));
      expect(payload['active_profile'], equals('user'));
    });

    test('ApiEndpoints.forgotPassword is correct', () {
      expect(ApiEndpoints.forgotPassword, equals('/api/users/password/forgot/'));
    });
  });
}
