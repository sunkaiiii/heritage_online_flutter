import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'heritage_theme.dart';
import 'theme_mode.dart';

/// 主题状态
class ThemeState {
  final AppThemeMode themeMode;

  const ThemeState({
    this.themeMode = AppThemeMode.system,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// 获取当前 ThemeMode
  ThemeMode get currentThemeMode => themeMode.toThemeMode();

  /// 获取当前 ThemeData（浅色）
  ThemeData get lightTheme => HeritageTheme.lightTheme;

  /// 获取当前 ThemeData（暗色）
  ThemeData get darkTheme => HeritageTheme.darkTheme;
}

/// 主题状态管理
class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  /// 设置主题模式
  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// 切换到浅色主题
  void setLightTheme() {
    setThemeMode(AppThemeMode.light);
  }

  /// 切换到暗色主题
  void setDarkTheme() {
    setThemeMode(AppThemeMode.dark);
  }

  /// 切换到系统主题
  void setSystemTheme() {
    setThemeMode(AppThemeMode.system);
  }
}

/// 主题状态 Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
