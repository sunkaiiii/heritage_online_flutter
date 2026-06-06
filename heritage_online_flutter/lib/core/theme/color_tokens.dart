import 'package:flutter/material.dart';

/// Heritage Online 颜色 Token
/// 所有页面必须使用 Material colorScheme token，不允许在业务页面写死颜色
class HeritageColors {
  HeritageColors._();

  // ==================== 浅色主题 ====================

  /// 主品牌色、强调按钮、底栏选中文字
  static const Color lightPrimary = Color(0xFF8F372F);

  /// primary 上的文字/图标
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  /// 选中态背景、轻量强调容器
  static const Color lightPrimaryContainer = Color(0xFFFFDAD4);

  /// primaryContainer 上文字
  static const Color lightOnPrimaryContainer = Color(0xFF3A0905);

  /// 次级强调
  static const Color lightSecondary = Color(0xFF6B5852);

  /// 次级 chip/card 背景
  static const Color lightSecondaryContainer = Color(0xFFEFE2DC);

  /// 少量第三强调，如统计/趋势
  static const Color lightTertiary = Color(0xFF735C23);

  /// 第三强调容器
  static const Color lightTertiaryContainer = Color(0xFFFFE1A6);

  /// 全页背景
  static const Color lightBackground = Color(0xFFFCF8F5);

  /// 默认 surface
  static const Color lightSurface = Color(0xFFFCF8F5);

  /// 最高亮容器
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);

  /// 普通卡片和底部导航背景
  static const Color lightSurfaceContainerLow = Color(0xFFFBF3EF);

  /// 中层容器
  static const Color lightSurfaceContainer = Color(0xFFF5ECE7);

  /// chip、图片占位、强调容器
  static const Color lightSurfaceContainerHigh = Color(0xFFEFE3DE);

  /// 最深浅色容器
  static const Color lightSurfaceContainerHighest = Color(0xFFE8DAD4);

  /// 正文标题文字
  static const Color lightOnSurface = Color(0xFF211A18);

  /// 次级正文、meta 文案
  static const Color lightOnSurfaceVariant = Color(0xFF51443F);

  /// 边框
  static const Color lightOutline = Color(0xFF83736D);

  /// 分割线、轻边框
  static const Color lightOutlineVariant = Color(0xFFD6C2BA);

  // ==================== 暗色主题 ====================

  /// 暗色主强调
  static const Color darkPrimary = Color(0xFFFFB4AA);

  /// primary 上文字
  static const Color darkOnPrimary = Color(0xFF561E19);

  /// 暗色选中态背景
  static const Color darkPrimaryContainer = Color(0xFF733028);

  /// primaryContainer 上文字
  static const Color darkOnPrimaryContainer = Color(0xFFFFDAD4);

  /// 次级强调
  static const Color darkSecondary = Color(0xFFD8C2BA);

  /// 次级容器
  static const Color darkSecondaryContainer = Color(0xFF51403A);

  /// 第三强调
  static const Color darkTertiary = Color(0xFFE2C47C);

  /// 第三强调容器
  static const Color darkTertiaryContainer = Color(0xFF594419);

  /// 全页背景
  static const Color darkBackground = Color(0xFF16100E);

  /// 默认 surface
  static const Color darkSurface = Color(0xFF16100E);

  /// 最暗容器
  static const Color darkSurfaceContainerLowest = Color(0xFF100B09);

  /// 普通卡片和底部导航背景
  static const Color darkSurfaceContainerLow = Color(0xFF241D1A);

  /// 中层容器
  static const Color darkSurfaceContainer = Color(0xFF2A211E);

  /// chip、图片占位
  static const Color darkSurfaceContainerHigh = Color(0xFF362B27);

  /// 最亮暗色容器
  static const Color darkSurfaceContainerHighest = Color(0xFF433631);

  /// 正文标题文字
  static const Color darkOnSurface = Color(0xFFEDE0DC);

  /// 次级正文、meta 文案
  static const Color darkOnSurfaceVariant = Color(0xFFD6C2BA);

  /// 边框
  static const Color darkOutline = Color(0xFF9F8D86);

  /// 分割线、轻边框
  static const Color darkOutlineVariant = Color(0xFF5D4C45);
}
