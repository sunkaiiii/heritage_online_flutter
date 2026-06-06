import 'package:flutter/material.dart';

/// 应用主题模式
enum AppThemeMode {
  /// 跟随系统
  system,

  /// 浅色模式
  light,

  /// 暗色模式
  dark;

  /// 转换为 Flutter 的 ThemeMode
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  /// 从 Flutter 的 ThemeMode 转换
  static AppThemeMode fromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppThemeMode.system;
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
    }
  }
}
