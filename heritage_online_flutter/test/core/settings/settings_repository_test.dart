import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/settings/app_language_mode.dart';
import 'package:heritage_online_flutter/core/settings/app_theme_mode.dart';
import 'package:heritage_online_flutter/core/settings/settings_repository.dart';

void main() {
  group('SettingsRepository', () {
    late SharedPreferences prefs;
    late SettingsRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repository = SettingsRepository(prefs: prefs);
    });

    group('ThemeMode', () {
      test('should return system by default', () {
        expect(repository.getThemeMode(), AppThemeMode.system);
      });

      test('should save and load light theme', () async {
        await repository.setThemeMode(AppThemeMode.light);
        expect(repository.getThemeMode(), AppThemeMode.light);
      });

      test('should save and load dark theme', () async {
        await repository.setThemeMode(AppThemeMode.dark);
        expect(repository.getThemeMode(), AppThemeMode.dark);
      });

      test('should save and load system theme', () async {
        await repository.setThemeMode(AppThemeMode.dark);
        await repository.setThemeMode(AppThemeMode.system);
        expect(repository.getThemeMode(), AppThemeMode.system);
      });
    });

    group('LanguageMode', () {
      test('should return system by default', () {
        expect(repository.getLanguageMode(), AppLanguageMode.system);
      });

      test('should save and load simplified chinese', () async {
        await repository.setLanguageMode(AppLanguageMode.simplifiedChinese);
        expect(repository.getLanguageMode(), AppLanguageMode.simplifiedChinese);
      });

      test('should save and load english', () async {
        await repository.setLanguageMode(AppLanguageMode.english);
        expect(repository.getLanguageMode(), AppLanguageMode.english);
      });

      test('should save and load system language', () async {
        await repository.setLanguageMode(AppLanguageMode.english);
        await repository.setLanguageMode(AppLanguageMode.system);
        expect(repository.getLanguageMode(), AppLanguageMode.system);
      });
    });

    group('Persistence', () {
      test('theme mode should persist across repository instances', () async {
        await repository.setThemeMode(AppThemeMode.dark);

        // 创建新的 repository 实例
        final newRepository = SettingsRepository(prefs: prefs);
        expect(newRepository.getThemeMode(), AppThemeMode.dark);
      });

      test('language mode should persist across repository instances', () async {
        await repository.setLanguageMode(AppLanguageMode.english);

        // 创建新的 repository 实例
        final newRepository = SettingsRepository(prefs: prefs);
        expect(newRepository.getLanguageMode(), AppLanguageMode.english);
      });
    });
  });
}
