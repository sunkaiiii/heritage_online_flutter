import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/api_error.dart';

void main() {
  group('ApiError', () {
    group('factory constructors', () {
      test('network should create network error', () {
        final error = ApiError.network();
        expect(error.type, ApiErrorType.network);
        expect(error.message, 'Network unavailable. Please check your connection.');
      });

      test('timeout should create timeout error', () {
        final error = ApiError.timeout();
        expect(error.type, ApiErrorType.timeout);
        expect(error.message, 'Request timed out. Please try again later.');
      });

      test('server should create server error', () {
        final error = ApiError.server();
        expect(error.type, ApiErrorType.server);
        expect(error.message, 'Service temporarily unavailable.');
      });

      test('server should include status code', () {
        final error = ApiError.server('服务器错误', 500);
        expect(error.statusCode, 500);
      });

      test('notFound should create not found error', () {
        final error = ApiError.notFound();
        expect(error.type, ApiErrorType.notFound);
        expect(error.message, 'Content not found or unavailable.');
      });

      test('unknown should create unknown error', () {
        final error = ApiError.unknown();
        expect(error.type, ApiErrorType.unknown);
        expect(error.message, 'An unknown error occurred.');
      });
    });

    group('fromStatusCode', () {
      test('should create notFound for 404', () {
        final error = ApiError.fromStatusCode(404);
        expect(error.type, ApiErrorType.notFound);
      });

      test('should create server error for 500', () {
        final error = ApiError.fromStatusCode(500);
        expect(error.type, ApiErrorType.server);
      });

      test('should create server error for 502', () {
        final error = ApiError.fromStatusCode(502);
        expect(error.type, ApiErrorType.server);
      });

      test('should create server error for 503', () {
        final error = ApiError.fromStatusCode(503);
        expect(error.type, ApiErrorType.server);
      });

      test('should create unknown error for other status codes', () {
        final error = ApiError.fromStatusCode(400);
        expect(error.type, ApiErrorType.unknown);
      });

      test('should include status code', () {
        final error = ApiError.fromStatusCode(500);
        expect(error.statusCode, 500);
      });
    });

    group('toString', () {
      test('should include type and message', () {
        final error = ApiError.network();
        final str = error.toString();
        expect(str, contains('network'));
        expect(str, contains('Network unavailable. Please check your connection.'));
      });

      test('should include status code when present', () {
        final error = ApiError.server('服务器错误', 500);
        final str = error.toString();
        expect(str, contains('500'));
      });
    });

    group('custom messages', () {
      test('should support custom network message', () {
        final error = ApiError.network('自定义网络错误');
        expect(error.message, '自定义网络错误');
      });

      test('should support custom timeout message', () {
        final error = ApiError.timeout('自定义超时错误');
        expect(error.message, '自定义超时错误');
      });

      test('should support custom server message', () {
        final error = ApiError.server('自定义服务器错误', 500);
        expect(error.message, '自定义服务器错误');
      });

      test('should support custom notFound message', () {
        final error = ApiError.notFound('自定义未找到错误');
        expect(error.message, '自定义未找到错误');
      });

      test('should support custom unknown message', () {
        final error = ApiError.unknown('自定义未知错误');
        expect(error.message, '自定义未知错误');
      });
    });

    group('original error', () {
      test('should store original error', () {
        final original = Exception('原始错误');
        final error = ApiError.network('网络错误', original);
        expect(error.originalError, original);
      });

      test('should allow null original error', () {
        final error = ApiError.network();
        expect(error.originalError, isNull);
      });
    });
  });
}
