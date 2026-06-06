import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'theme_mode.dart';
import 'typography_tokens.dart';

/// Heritage Online 主题
/// 完整落地第 10 章的颜色、字体、圆角和基础布局规则
class HeritageTheme {
  HeritageTheme._();

  /// 浅色主题 ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: HeritageColors.lightPrimary,
    onPrimary: HeritageColors.lightOnPrimary,
    primaryContainer: HeritageColors.lightPrimaryContainer,
    onPrimaryContainer: HeritageColors.lightOnPrimaryContainer,
    secondary: HeritageColors.lightSecondary,
    onSecondary: Colors.white,
    secondaryContainer: HeritageColors.lightSecondaryContainer,
    onSecondaryContainer: Color(0xFF261915),
    tertiary: HeritageColors.lightTertiary,
    onTertiary: Colors.white,
    tertiaryContainer: HeritageColors.lightTertiaryContainer,
    onTertiaryContainer: Color(0xFF261A00),
    surface: HeritageColors.lightSurface,
    onSurface: HeritageColors.lightOnSurface,
    surfaceContainerLowest: HeritageColors.lightSurfaceContainerLowest,
    surfaceContainerLow: HeritageColors.lightSurfaceContainerLow,
    surfaceContainer: HeritageColors.lightSurfaceContainer,
    surfaceContainerHigh: HeritageColors.lightSurfaceContainerHigh,
    surfaceContainerHighest: HeritageColors.lightSurfaceContainerHighest,
    onSurfaceVariant: HeritageColors.lightOnSurfaceVariant,
    outline: HeritageColors.lightOutline,
    outlineVariant: HeritageColors.lightOutlineVariant,
    inverseSurface: Color(0xFF372E2B),
    onInverseSurface: Color(0xFFFFEDE8),
    inversePrimary: HeritageColors.darkPrimary,
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
  );

  /// 暗色主题 ColorScheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: HeritageColors.darkPrimary,
    onPrimary: HeritageColors.darkOnPrimary,
    primaryContainer: HeritageColors.darkPrimaryContainer,
    onPrimaryContainer: HeritageColors.darkOnPrimaryContainer,
    secondary: HeritageColors.darkSecondary,
    onSecondary: Color(0xFF3B2A25),
    secondaryContainer: HeritageColors.darkSecondaryContainer,
    onSecondaryContainer: Color(0xFFF5DED6),
    tertiary: HeritageColors.darkTertiary,
    onTertiary: Color(0xFF3F2E00),
    tertiaryContainer: HeritageColors.darkTertiaryContainer,
    onTertiaryContainer: HeritageColors.lightTertiaryContainer,
    surface: HeritageColors.darkSurface,
    onSurface: HeritageColors.darkOnSurface,
    surfaceContainerLowest: HeritageColors.darkSurfaceContainerLowest,
    surfaceContainerLow: HeritageColors.darkSurfaceContainerLow,
    surfaceContainer: HeritageColors.darkSurfaceContainer,
    surfaceContainerHigh: HeritageColors.darkSurfaceContainerHigh,
    surfaceContainerHighest: HeritageColors.darkSurfaceContainerHighest,
    onSurfaceVariant: HeritageColors.darkOnSurfaceVariant,
    outline: HeritageColors.darkOutline,
    outlineVariant: HeritageColors.darkOutlineVariant,
    inverseSurface: HeritageColors.lightOnSurface,
    onInverseSurface: Color(0xFF372E2B),
    inversePrimary: HeritageColors.lightPrimary,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
  );

  /// 构建浅色 ThemeData
  static ThemeData get lightTheme => _buildTheme(lightColorScheme);

  /// 构建暗色 ThemeData
  static ThemeData get darkTheme => _buildTheme(darkColorScheme);

  /// 根据 AppThemeMode 获取主题模式
  static ThemeMode getThemeMode(AppThemeMode mode) => mode.toThemeMode();

  /// 构建 ThemeData
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isLight = colorScheme.brightness == Brightness.light;
    // 浅色用 black text theme，暗色用 white text theme
    final baseTextTheme = isLight
        ? HeritageTypography.typography.black
        : HeritageTypography.typography.white;
    // 将 colorScheme 的颜色应用到文字主题：
    // displayColor → display/headline/title 层级
    // bodyColor → body/label/title 层级
    final textTheme = baseTextTheme.apply(
      displayColor: colorScheme.onSurface,
      bodyColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      brightness: colorScheme.brightness,

      // 页面背景
      scaffoldBackgroundColor: colorScheme.surface,

      // 卡片主题
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.zero,
      ),

      // AppBar 主题
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      // 底部导航栏主题
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          );
        }),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Chip 主题
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),

      // 分割线主题
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // 对话框主题
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // 底部弹窗主题
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ),
    );
  }
}
