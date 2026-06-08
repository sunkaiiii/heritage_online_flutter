import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'api_config.dart';
import 'api_error.dart';

/// HTTP Client
/// 封装 Dio，提供统一的网络请求接口
class HttpClient {
  late final Dio _dio;
  final ApiConfig config;

  HttpClient({required this.config}) {
    _dio = _createDio();
  }

  /// 创建 Dio 实例
  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: Duration(seconds: config.timeoutSeconds),
        receiveTimeout: Duration(seconds: config.timeoutSeconds),
        sendTimeout: Duration(seconds: config.timeoutSeconds),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Debug local backends often use a self-signed HTTPS certificate.
    // Only trust those certificates for local hosts; never make this global.
    if (config.trustSelfSigned) {
      final adapter = dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = io.HttpClient();
          client.badCertificateCallback = (cert, host, port) {
            return _isLocalDevelopmentHost(host);
          };
          return client;
        };
      }
    }

    // 添加拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 可以在这里添加认证 token 等
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  /// GET 请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      // 确保 path 以 / 开头，避免 URL 拼接错误
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      return await _dio.get<T>(
        normalizedPath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// 将 DioException 映射为 ApiError
  ApiError _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError.timeout('Request timed out', error);

      case DioExceptionType.connectionError:
        return ApiError.network(
          'Network unavailable: ${_dioErrorMessage(error, "no connection")}',
          error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          return ApiError.fromStatusCode(statusCode, error);
        }
        return ApiError.server('Server error', null, error);

      case DioExceptionType.badCertificate:
        return ApiError.network(
          'Certificate validation failed. Check local HTTPS certificate settings.',
          error,
        );

      case DioExceptionType.cancel:
        return ApiError.unknown('Request cancelled', error);

      case DioExceptionType.unknown:
        return ApiError.unknown(
          _dioErrorMessage(error, 'An unknown error occurred'),
          error,
        );
    }
  }

  String _dioErrorMessage(DioException error, String fallback) {
    final message = error.message;
    if (message != null && message.trim().isNotEmpty) {
      return message;
    }

    final originalError = error.error;
    if (originalError != null) {
      return originalError.toString();
    }

    return fallback;
  }

  bool _isLocalDevelopmentHost(String host) {
    final normalizedHost = host.toLowerCase();
    return normalizedHost == 'localhost' ||
        normalizedHost == '127.0.0.1' ||
        normalizedHost == '::1' ||
        normalizedHost == '0.0.0.0' ||
        normalizedHost == '10.0.2.2';
  }
}
