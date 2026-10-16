import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lively_nightlife_nightclub_party/core/services/dio_client.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/logging/logger.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class TokenStorageService {
  TokenStorageService._();

  static final GetStorage _storage = GetStorage();

  static const String _accessTokenKey = 'access';
  static const String _refreshTokenKey = 'refresh';
  static const String _userIdKey = 'user_id';
  static const String _activeProfileKey = 'active_profile';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Save access token and auto-extract user_id/active_profile if present in JWT
  static Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(_accessTokenKey, token);
      await _storage.write(_isLoggedInKey, true);

      final payload = decodeJwt(token);
      if (payload != null) {
        if (payload['user_id'] != null) {
          await _storage.write(_userIdKey, payload['user_id'].toString());
        }
        if (payload['active_profile'] != null) {
          await _storage.write(
            _activeProfileKey,
            payload['active_profile'].toString(),
          );
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Failed to save access token: $e');
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    try {
      final token = _storage.read<String>(_accessTokenKey);
      return (token != null && token.isNotEmpty) ? token : null;
    } catch (e) {
      AppLoggerHelper.error('Failed to read access token: $e');
      return null;
    }
  }

  /// Synchronous access token getter
  static String? getAccessTokenSync() {
    try {
      final token = _storage.read<String>(_accessTokenKey);
      return (token != null && token.isNotEmpty) ? token : null;
    } catch (e) {
      AppLoggerHelper.error('Failed to read access token synchronously: $e');
      return null;
    }
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(_refreshTokenKey, token);
    } catch (e) {
      AppLoggerHelper.error('Failed to save refresh token: $e');
    }
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final token = _storage.read<String>(_refreshTokenKey);
      return (token != null && token.isNotEmpty) ? token : null;
    } catch (e) {
      AppLoggerHelper.error('Failed to read refresh token: $e');
      return null;
    }
  }

  /// Synchronous refresh token getter
  static String? getRefreshTokenSync() {
    try {
      final token = _storage.read<String>(_refreshTokenKey);
      return (token != null && token.isNotEmpty) ? token : null;
    } catch (e) {
      AppLoggerHelper.error('Failed to read refresh token synchronously: $e');
      return null;
    }
  }

  /// Save both access and refresh tokens
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await saveRefreshToken(refreshToken);
    }
  }

  /// Get saved user ID
  static String? getUserId() {
    return _storage.read<String>(_userIdKey);
  }

  /// Get saved active profile ('user' or 'venue')
  static String? getActiveProfile() {
    return _storage.read<String>(_activeProfileKey);
  }

  /// Save active profile ('user' or 'venue')
  static Future<void> saveActiveProfile(String profile) async {
    try {
      await _storage.write(_activeProfileKey, profile);
    } catch (e) {
      AppLoggerHelper.error('Failed to save active profile: $e');
    }
  }

  /// Check if user has an active access token
  static bool hasToken() {
    final token = _storage.read<String>(_accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return hasToken();
  }

  /// Safely decode JWT payload
  static Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded);
      if (map is Map<String, dynamic>) {
        return map;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Clear all stored tokens and user details (on logout / expired session)
  static Future<void> clearTokens() async {
    try {
      await _storage.remove(_accessTokenKey);
      await _storage.remove(_refreshTokenKey);
      await _storage.remove(_userIdKey);
      await _storage.remove(_activeProfileKey);
      await _storage.remove(_isLoggedInKey);
      await _storage.remove('is_logged_in');
      await _storage.remove('user_profile');
      await _storage.remove('auth_token');
      await _storage.remove('token');
      AppLoggerHelper.info('Tokens cleared successfully');
    } catch (e) {
      AppLoggerHelper.error('Failed to clear tokens: $e');
    }
  }

  /// Complete logout helper: clears all tokens, resets DioClient, clears memory and navigates to login
  static Future<void> logout() async {
    await clearTokens();
    DioClient.reset();
    try {
      Get.deleteAll(force: true);
    } catch (_) {}
    Get.offAllNamed(AppRoute.loginView);
  }
}
