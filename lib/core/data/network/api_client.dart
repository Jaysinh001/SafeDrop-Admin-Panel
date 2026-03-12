import 'dart:developer';

import 'package:dio/dio.dart';

import '../local_storage/hive_boxes.dart';
import '../local_storage/local_storage_service.dart';
import '../local_storage/storage_keys.dart';

import 'api_response.dart';
import 'api_exception.dart';
import 'api_codes.dart';
import 'endpoints.dart';

class ApiClient {
  late Dio _dio;

  // final LocalStorageService _storage = sl<LocalStorageService>();
  final LocalStorageService _storage;



  ApiClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _storage.read<String>(
            box: HiveBoxes.authBox,
            key: StorageKeys.accessToken,
          );

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          final responseData = error.response?.data;

          if (responseData != null) {

            log('responseData["code"] type : ${responseData["code"].runtimeType}');

            if (responseData["code"] == ApiCodes.expiredToken) {
              try {
                await _refreshToken();

                final request = error.requestOptions;

                final newToken = _storage.read<String>(
                  box: HiveBoxes.authBox,
                  key: StorageKeys.accessToken,
                );

                if (newToken != null) {
                  request.headers["Authorization"] = "Bearer $newToken";
                }

                final response = await _dio.fetch(request);

                return handler.resolve(response);
              } catch (_) {
                await _clearSession();
              }
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  /// Refresh token
  Future<void> _refreshToken() async {

    final refreshToken = _storage.read<String>(
      box: HiveBoxes.authBox,
      key: StorageKeys.refreshToken,
    );

    final response = await _dio.post(
      ApiEndpoints.refreshTokenApi,
      data: {
        "refresh_token": refreshToken,
      },
    );

    final newAccessToken = response.data["data"]["access_token"];
    final newRefreshToken = response.data["data"]["refresh_token"];

    await _storage.write(
      box: HiveBoxes.authBox,
      key: StorageKeys.accessToken,
      value: newAccessToken,
    );

    if (newRefreshToken != null) {
      await _storage.write(
        box: HiveBoxes.authBox,
        key: StorageKeys.refreshToken,
        value: newRefreshToken,
      );
    }
  }

  /// Clear session (logout)
  Future<void> _clearSession() async {
    await _storage.clearBox(HiveBoxes.authBox);
  }

  // ---------------- GENERIC REQUEST ----------------

  Future<ApiResponse<T>> _request<T>(
    Future<Response> request,
    T Function(dynamic json)? parser,
  ) async {
    try {
      final response = await request;

      final body = response.data;
      
      final apiResponse = ApiResponse<T>.fromJson(body, parser);

      if (!apiResponse.success) {
        throw ApiException(
          code: apiResponse.code,
          message: apiResponse.message,
        );
      }

      return apiResponse;
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data != null) {
        throw ApiException(
          code: data["code"] ?? "UNKNOWN",
          message: data["message"] ?? "Unknown error",
        );
      }

      throw ApiException(
        code: "NETWORK_ERROR",
        message: "Unable to connect to server",
      );
    }
  }

  // ---------------- GET ----------------

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(dynamic json)? parser,
  }) {
    return _request(
      _dio.get(path, queryParameters: query),
      parser,
    );
  }

  // ---------------- POST ----------------

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) {
    return _request(
      _dio.post(path, data: body),
      parser,
    );
  }

  // ---------------- PUT ----------------

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) {
    return _request(
      _dio.put(path, data: body),
      parser,
    );
  }

  // ---------------- PATCH ----------------

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) {
    return _request(
      _dio.patch(path, data: body),
      parser,
    );
  }

  // ---------------- DELETE ----------------

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic body,
    T Function(dynamic json)? parser,
  }) {
    return _request(
      _dio.delete(path, data: body),
      parser,
    );
  }
}