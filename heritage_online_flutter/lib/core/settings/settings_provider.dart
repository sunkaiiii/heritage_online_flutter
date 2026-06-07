import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_language_mode.dart';
import 'app_theme_mode.dart';
import 'settings_repository.dart';

/// SharedPreferences Provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// 设置 Repository Provider
final settingsRepositoryProvider = FutureProvider<SettingsRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return SettingsRepository(prefs: prefs);
});

/// 主题模式状态
class ThemeModeState {
  final AppThemeMode themeMode;

  const ThemeModeState({this.themeMode = AppThemeMode.system});

  ThemeModeState copyWith({AppThemeMode? themeMode}) {
    return ThemeModeState(themeMode: themeMode ?? this.themeMode);
  }

  /// 获取当前 ThemeMode
  ThemeMode get currentThemeMode => themeMode.toThemeMode();
}

/// 主题模式通知器
class ThemeModeNotifier extends StateNotifier<ThemeModeState> {
  final SettingsRepository? _repository;

  ThemeModeNotifier(this._repository) : super(const ThemeModeState()) {
    _loadThemeMode();
  }

  /// 加载保存的主题模式
  void _loadThemeMode() {
    final repo = _repository;
    if (repo != null) {
      final mode = repo.getThemeMode();
      state = ThemeModeState(themeMode: mode);
    }
  }

  /// 设置主题模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = ThemeModeState(themeMode: mode);
    await _repository?.setThemeMode(mode);
  }
}

/// 主题模式 Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeModeState>((ref) {
  final repositoryAsync = ref.watch(settingsRepositoryProvider);
  final repository = repositoryAsync.valueOrNull;
  return ThemeModeNotifier(repository);
});

/// 语言模式状态
class LanguageModeState {
  final AppLanguageMode languageMode;

  const LanguageModeState({this.languageMode = AppLanguageMode.system});

  LanguageModeState copyWith({AppLanguageMode? languageMode}) {
    return LanguageModeState(languageMode: languageMode ?? this.languageMode);
  }

  /// 获取当前 Locale（null 表示跟随系统）
  Locale? get currentLocale => languageMode.toLocale();
}

/// 语言模式通知器
class LanguageModeNotifier extends StateNotifier<LanguageModeState> {
  final SettingsRepository? _repository;

  LanguageModeNotifier(this._repository) : super(const LanguageModeState()) {
    _loadLanguageMode();
  }

  /// 加载保存的语言模式
  void _loadLanguageMode() {
    final repo = _repository;
    if (repo != null) {
      final mode = repo.getLanguageMode();
      state = LanguageModeState(languageMode: mode);
    }
  }

  /// 设置语言模式
  Future<void> setLanguageMode(AppLanguageMode mode) async {
    state = LanguageModeState(languageMode: mode);
    await _repository?.setLanguageMode(mode);
  }
}

/// 语言模式 Provider
final languageModeProvider = StateNotifierProvider<LanguageModeNotifier, LanguageModeState>((ref) {
  final repositoryAsync = ref.watch(settingsRepositoryProvider);
  final repository = repositoryAsync.valueOrNull;
  return LanguageModeNotifier(repository);
});
