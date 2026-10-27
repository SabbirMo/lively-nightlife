import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/token_storage_service.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from storage
    final accessToken = await TokenStorageService.getAccessToken();

    // Add access token to request headers if available
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      log('Added access token to request: ${options.path}');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      log('Token expired, attempting refresh...');

      // Try to refresh the token
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry the original request with new token
        try {
          final request = err.requestOptions;
          final accessToken = await TokenStorageService.getAccessToken();

          // Update authorization header
          request.headers['Authorization'] = 'Bearer $accessToken';

          // Retry the request
          final response = await _dio.fetch(request);
          return handler.resolve(response);
        } catch (e) {
          log('Retry failed after token refresh: $e');
          return handler.next(err);
        }
      } else {
        // Refresh failed, logout user
        log('Token refresh failed, clearing tokens');
        await TokenStorageService.clearTokens();
        if (!TokenStorageService.isLoggingOut &&
            Get.currentRoute != AppRoute.loginView) {
          Get.offAllNamed(AppRoute.loginView);
        }
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Refresh the access token using refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenStorageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        log('No refresh token available');
        return false;
      }

      // Create a new Dio instance without interceptor to avoid infinite loop
      final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['access'];
        final newRefreshToken = response.data['refresh'];

        // Save new tokens
        if (newAccessToken != null) {
          await TokenStorageService.saveAccessToken(newAccessToken);
        }

        // Save new refresh token if provided
        if (newRefreshToken != null) {
          await TokenStorageService.saveRefreshToken(newRefreshToken);
        }

        log('Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      log('Token refresh error: $e');
      return false;
    }
  }
}
