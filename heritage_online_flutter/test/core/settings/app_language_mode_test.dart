import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/settings/app_language_mode.dart';

void main() {
  group('AppLanguageMode', () {
    test('storageKey should match expected values', () {
      expect(AppLanguageMode.system.storageKey, 'system');
      expect(AppLanguageMode.simplifiedChinese.storageKey, 'zh-Hans');
      expect(AppLanguageMode.english.storageKey, 'en');
    });

    test('languageTag should match expected values', () {
      expect(AppLanguageMode.system.languageTag, isNull);
      expect(AppLanguageMode.simplifiedChinese.languageTag, 'zh-Hans');
      expect(AppLanguageMode.english.languageTag, 'en');
    });

    test('fromStorageKey should parse correctly', () {
      expect(AppLanguageMode.fromStorageKey('system'), AppLanguageMode.system);
      expect(AppLanguageMode.fromStorageKey('zh-Hans'), AppLanguageMode.simplifiedChinese);
      expect(AppLanguageMode.fromStorageKey('en'), AppLanguageMode.english);
    });

    test('fromStorageKey should default to system for unknown', () {
      expect(AppLanguageMode.fromStorageKey('unknown'), AppLanguageMode.system);
      expect(AppLanguageMode.fromStorageKey(null), AppLanguageMode.system);
    });

    test('toLocale should convert correctly', () {
      expect(AppLanguageMode.system.toLocale(), isNull);
      expect(AppLanguageMode.simplifiedChinese.toLocale(), const Locale('zh-Hans'));
      expect(AppLanguageMode.english.toLocale(), const Locale('en'));
    });
  });
}
