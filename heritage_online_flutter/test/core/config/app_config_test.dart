import 'package:flutter_test/flutter_test.dart';
import 'package:heritage_online_flutter/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('should be a singleton', () {
      final config1 = AppConfig.instance;
      final config2 = AppConfig.instance;
      expect(identical(config1, config2), isTrue);
    });

    test('should have valid app name', () {
      expect(AppConfig.instance.appName, isNotEmpty);
    });

    test('should have valid app version', () {
      expect(AppConfig.instance.appVersion, isNotEmpty);
    });

    test('should have valid request timeout', () {
      expect(AppConfig.instance.requestTimeoutSeconds, greaterThan(0));
    });

    test('should have valid api base url', () {
      final url = AppConfig.instance.apiBaseUrl;
      expect(url, isNotEmpty);
      expect(url.startsWith('https://'), isTrue);
    });
  });
}
