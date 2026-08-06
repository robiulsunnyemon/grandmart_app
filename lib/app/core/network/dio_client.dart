import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../storage/storage_service.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Dio Network Client
//  Handles API requests, automatic JWT authorization header injection,
//  401 refresh token flow, and centralized error logging.
// ════════════════════════════════════════════════════════════════════════════

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
      );
    }
  }

  Dio get instance => _dio;

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = StorageService.to.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  void _onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        try {
          final opts = err.requestOptions;
          final token = StorageService.to.getAccessToken();
          opts.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(opts);
          return handler.resolve(response);
        } catch (e) {
          // Retry failed
        }
      } else {
        await StorageService.to.clearAuth();
        // Redirect to login if needed
      }
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    final refreshToken = StorageService.to.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    try {
      final response = await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post(
        ApiConfig.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccess = response.data['access_token'];
        final newRefresh = response.data['refresh_token'];
        if (newAccess != null && newRefresh != null) {
          await StorageService.to.saveTokens(access: newAccess, refresh: newRefresh);
          return true;
        }
      }
    } catch (_) {
      // Refresh token expired or invalid
    }

    return false;
  }
}
