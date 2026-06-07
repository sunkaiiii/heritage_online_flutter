/// API 错误类型
/// 统一错误类型，用于处理网络请求中的各种错误情况
enum ApiErrorType {
  /// 网络连接错误
  network,

  /// 请求超时
  timeout,

  /// 服务器错误（5xx）
  server,

  /// 资源未找到（404）
  notFound,

  /// 未知错误
  unknown,
}

/// API 错误
/// 包含错误类型、消息和可选的原始错误
class ApiError implements Exception {
  /// 错误类型
  final ApiErrorType type;

  /// 错误消息
  final String message;

  /// 原始错误（可选）
  final dynamic originalError;

  /// HTTP 状态码（可选）
  final int? statusCode;

  const ApiError({
    required this.type,
    required this.message,
    this.originalError,
    this.statusCode,
  });

  /// 创建网络错误
  factory ApiError.network([String message = 'Network unavailable. Please check your connection.', dynamic error]) {
    return ApiError(
      type: ApiErrorType.network,
      message: message,
      originalError: error,
    );
  }

  /// 创建超时错误
  factory ApiError.timeout([String message = 'Request timed out. Please try again later.', dynamic error]) {
    return ApiError(
      type: ApiErrorType.timeout,
      message: message,
      originalError: error,
    );
  }

  /// 创建服务器错误
  factory ApiError.server([String message = 'Service temporarily unavailable.', int? statusCode, dynamic error]) {
    return ApiError(
      type: ApiErrorType.server,
      message: message,
      statusCode: statusCode,
      originalError: error,
    );
  }

  /// 创建未找到错误
  factory ApiError.notFound([String message = 'Content not found or unavailable.', dynamic error]) {
    return ApiError(
      type: ApiErrorType.notFound,
      message: message,
      originalError: error,
    );
  }

  /// 创建未知错误
  factory ApiError.unknown([String message = 'An unknown error occurred.', dynamic error]) {
    return ApiError(
      type: ApiErrorType.unknown,
      message: message,
      originalError: error,
    );
  }

  /// 从 HTTP 状态码创建错误
  factory ApiError.fromStatusCode(int statusCode, [dynamic error]) {
    switch (statusCode) {
      case 404:
        return ApiError.notFound('Resource not found', error);
      case >= 500:
        return ApiError.server('Server error ($statusCode)', statusCode, error);
      default:
        return ApiError.unknown('Request failed ($statusCode)', error);
    }
  }

  @override
  String toString() {
    return 'ApiError(type: $type, message: $message, statusCode: $statusCode)';
  }
}
