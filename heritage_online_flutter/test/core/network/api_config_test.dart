import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/api_config.dart';

void main() {
  group('ApiConfig', () {
    group('default config', () {
      test('should have valid base url', () {
        final config = ApiConfig.defaultConfig();
        expect(config.baseUrl, isNotEmpty);
        expect(config.baseUrl.startsWith('https://'), isTrue);
      });

      test('should have timeout seconds', () {
        final config = ApiConfig.defaultConfig();
        expect(config.timeoutSeconds, greaterThan(0));
      });

      test('should have lenient json enabled', () {
        final config = ApiConfig.defaultConfig();
        expect(config.lenientJson, isTrue);
      });
    });

    group('debug config', () {
      test('should use localhost base url', () {
        final config = ApiConfig.debug();
        expect(config.baseUrl, contains('localhost'));
      });

      test('should trust self signed certificates', () {
        final config = ApiConfig.debug();
        expect(config.trustSelfSigned, isTrue);
      });
    });

    group('release config', () {
      test('should use production base url', () {
        final config = ApiConfig.release();
        expect(config.baseUrl, isNot(contains('localhost')));
      });

      test('should not trust self signed certificates', () {
        final config = ApiConfig.release();
        expect(config.trustSelfSigned, isFalse);
      });
    });

    group('copyWith', () {
      test('should copy with new base url', () {
        final config = ApiConfig.debug();
        final newConfig = config.copyWith(baseUrl: 'https://new.example.com');
        expect(newConfig.baseUrl, 'https://new.example.com');
        expect(newConfig.trustSelfSigned, config.trustSelfSigned);
      });

      test('should copy with new timeout', () {
        final config = ApiConfig.debug();
        final newConfig = config.copyWith(timeoutSeconds: 60);
        expect(newConfig.timeoutSeconds, 60);
        expect(newConfig.baseUrl, config.baseUrl);
      });

      test('should copy with new trust self signed', () {
        final config = ApiConfig.debug();
        final newConfig = config.copyWith(trustSelfSigned: false);
        expect(newConfig.trustSelfSigned, isFalse);
        expect(newConfig.baseUrl, config.baseUrl);
      });
    });

    group('custom config', () {
      test('should create custom config', () {
        const config = ApiConfig(
          baseUrl: 'https://custom.example.com',
          trustSelfSigned: false,
          timeoutSeconds: 45,
          lenientJson: false,
        );
        expect(config.baseUrl, 'https://custom.example.com');
        expect(config.trustSelfSigned, isFalse);
        expect(config.timeoutSeconds, 45);
        expect(config.lenientJson, isFalse);
      });
    });
  });
}
