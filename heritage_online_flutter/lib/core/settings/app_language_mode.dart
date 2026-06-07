import 'package:flutter/material.dart' show Locale;

/// 应用语言模式
enum AppLanguageMode {
  /// 跟随系统
  system('system', null),

  /// 简体中文
  simplifiedChinese('zh-Hans', 'zh-Hans'),

  /// English
  english('en', 'en');

  /// 存储键
  final String storageKey;

  /// 语言标签（null 表示跟随系统）
  final String? languageTag;

  const AppLanguageMode(this.storageKey, this.languageTag);

  /// 从存储键创建
  static AppLanguageMode fromStorageKey(String? value) {
    return AppLanguageMode.values.firstWhere(
      (mode) => mode.storageKey == value,
      orElse: () => AppLanguageMode.system,
    );
  }

  /// 转换为 Locale
  Locale? toLocale() {
    if (languageTag == null) return null;
    return Locale(languageTag!);
  }
}
