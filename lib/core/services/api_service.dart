import 'package:dio/dio.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_error_handler.dart';
import 'package:lively_nightlife_nightclub_party/core/services/dio_client.dart';

class ApiService {
  Dio _getDio(bool requireAuth) {
    return requireAuth ? DioClient.instance : DioClient.instanceWithoutAuth;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    try {
      return await _getDio(
        requireAuth,
      ).get(path, queryParameters: queryParameters, cancelToken: cancelToken);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    try {
      return await _getDio(requireAuth).post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    try {
      return await _getDio(requireAuth).put(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    try {
      return await _getDio(requireAuth).patch(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    try {
      return await _getDio(requireAuth).delete(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  /// File / Multipart upload using Dio
  Future<Response> upload(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    bool requireAuth = true,
  }) async {
    try {
      return await _getDio(requireAuth).post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }
}
