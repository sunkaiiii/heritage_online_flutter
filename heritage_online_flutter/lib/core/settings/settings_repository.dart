import 'package:shared_preferences/shared_preferences.dart';

import 'app_language_mode.dart';
import 'app_theme_mode.dart';

// ignore_for_file: prefer_initializing_formals

/// 设置持久化 Repository
/// 使用 SharedPreferences 存储主题和语言设置
class SettingsRepository {
  static const _themeModeKey = 'theme_mode';
  static const _languageModeKey = 'language_mode';

  final SharedPreferences _prefs;

  SettingsRepository({required SharedPreferences prefs}) : _prefs = prefs;

  /// 获取主题模式
  AppThemeMode getThemeMode() {
    final value = _prefs.getString(_themeModeKey);
    return AppThemeMode.fromStorageKey(value);
  }

  /// 设置主题模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.storageKey);
  }

  /// 获取语言模式
  AppLanguageMode getLanguageMode() {
    final value = _prefs.getString(_languageModeKey);
    return AppLanguageMode.fromStorageKey(value);
  }

  /// 设置语言模式
  Future<void> setLanguageMode(AppLanguageMode mode) async {
    await _prefs.setString(_languageModeKey, mode.storageKey);
  }
}
