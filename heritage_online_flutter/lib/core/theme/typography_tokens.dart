import 'package:flutter/material.dart';

/// Heritage Online Typography Token
/// 字体族使用系统默认，重点是字重、字号、行高
class HeritageTypography {
  HeritageTypography._();

  /// 少量大标题，当前较少使用
  /// 字重: SemiBold, 字号: 34, 行高: 42
  static const TextStyle displaySmall = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 34,
    height: 42 / 34,
  );

  /// 主页面 header title
  /// 字重: SemiBold, 字号: 30, 行高: 38
  static const TextStyle headlineLarge = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30,
    height: 38 / 30,
  );

  /// 详情页大标题或二级页标题
  /// 字重: SemiBold, 字号: 26, 行高: 34
  static const TextStyle headlineMedium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 26,
    height: 34 / 26,
  );

  /// 卡片组标题、详情小标题
  /// 字重: SemiBold, 字号: 22, 行高: 30
  static const TextStyle headlineSmall = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 30 / 22,
  );

  /// SectionHeader 标题
  /// 字重: SemiBold, 字号: 20, 行高: 28
  static const TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 28 / 20,
  );

  /// 卡片标题、列表 item 标题
  /// 字重: SemiBold, 字号: 16, 行高: 24
  static const TextStyle titleMedium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
  );

  /// 详情正文
  /// 字重: Normal, 字号: 16, 行高: 27
  static const TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 27 / 16,
  );

  /// 摘要、meta、列表正文
  /// 字重: Normal, 字号: 14, 行高: 22
  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 22 / 14,
  );

  /// chip、按钮、短标签
  /// 字重: SemiBold, 字号: 14, 行高: 20
  static const TextStyle labelLarge = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
  );

  /// 构建 Material Typography 对象
  static Typography get typography => Typography.material2021(
        black: _textTheme(Colors.black),
        white: _textTheme(Colors.white),
      );

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      displaySmall: displaySmall.copyWith(color: color),
      headlineLarge: headlineLarge.copyWith(color: color),
      headlineMedium: headlineMedium.copyWith(color: color),
      headlineSmall: headlineSmall.copyWith(color: color),
      titleLarge: titleLarge.copyWith(color: color),
      titleMedium: titleMedium.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      labelLarge: labelLarge.copyWith(color: color),
    );
  }
}
