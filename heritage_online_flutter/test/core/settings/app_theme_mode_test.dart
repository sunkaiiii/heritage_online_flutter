import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/settings/app_theme_mode.dart';

void main() {
  group('AppThemeMode', () {
    test('storageKey should match expected values', () {
      expect(AppThemeMode.system.storageKey, 'system');
      expect(AppThemeMode.light.storageKey, 'light');
      expect(AppThemeMode.dark.storageKey, 'dark');
    });

    test('fromStorageKey should parse correctly', () {
      expect(AppThemeMode.fromStorageKey('system'), AppThemeMode.system);
      expect(AppThemeMode.fromStorageKey('light'), AppThemeMode.light);
      expect(AppThemeMode.fromStorageKey('dark'), AppThemeMode.dark);
    });

    test('fromStorageKey should default to system for unknown', () {
      expect(AppThemeMode.fromStorageKey('unknown'), AppThemeMode.system);
      expect(AppThemeMode.fromStorageKey(null), AppThemeMode.system);
    });

    test('toThemeMode should convert correctly', () {
      expect(AppThemeMode.system.toThemeMode(), ThemeMode.system);
      expect(AppThemeMode.light.toThemeMode(), ThemeMode.light);
      expect(AppThemeMode.dark.toThemeMode(), ThemeMode.dark);
    });

    test('fromThemeMode should convert correctly', () {
      expect(AppThemeMode.fromThemeMode(ThemeMode.system), AppThemeMode.system);
      expect(AppThemeMode.fromThemeMode(ThemeMode.light), AppThemeMode.light);
      expect(AppThemeMode.fromThemeMode(ThemeMode.dark), AppThemeMode.dark);
    });

    test('round-trip conversion should preserve value', () {
      for (final mode in AppThemeMode.values) {
        final themeMode = mode.toThemeMode();
        final restored = AppThemeMode.fromThemeMode(themeMode);
        expect(restored, mode);
      }
    });
  });
}
