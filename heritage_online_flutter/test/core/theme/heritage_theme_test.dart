import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/theme/theme.dart';

void main() {
  group('HeritageColors', () {
    test('light colors should be defined', () {
      expect(HeritageColors.lightPrimary, isNotNull);
      expect(HeritageColors.lightOnPrimary, isNotNull);
      expect(HeritageColors.lightPrimaryContainer, isNotNull);
      expect(HeritageColors.lightOnPrimaryContainer, isNotNull);
      expect(HeritageColors.lightSecondary, isNotNull);
      expect(HeritageColors.lightSecondaryContainer, isNotNull);
      expect(HeritageColors.lightTertiary, isNotNull);
      expect(HeritageColors.lightTertiaryContainer, isNotNull);
      expect(HeritageColors.lightBackground, isNotNull);
      expect(HeritageColors.lightSurface, isNotNull);
      expect(HeritageColors.lightSurfaceContainerLowest, isNotNull);
      expect(HeritageColors.lightSurfaceContainerLow, isNotNull);
      expect(HeritageColors.lightSurfaceContainer, isNotNull);
      expect(HeritageColors.lightSurfaceContainerHigh, isNotNull);
      expect(HeritageColors.lightSurfaceContainerHighest, isNotNull);
      expect(HeritageColors.lightOnSurface, isNotNull);
      expect(HeritageColors.lightOnSurfaceVariant, isNotNull);
      expect(HeritageColors.lightOutline, isNotNull);
      expect(HeritageColors.lightOutlineVariant, isNotNull);
    });

    test('dark colors should be defined', () {
      expect(HeritageColors.darkPrimary, isNotNull);
      expect(HeritageColors.darkOnPrimary, isNotNull);
      expect(HeritageColors.darkPrimaryContainer, isNotNull);
      expect(HeritageColors.darkOnPrimaryContainer, isNotNull);
      expect(HeritageColors.darkSecondary, isNotNull);
      expect(HeritageColors.darkSecondaryContainer, isNotNull);
      expect(HeritageColors.darkTertiary, isNotNull);
      expect(HeritageColors.darkTertiaryContainer, isNotNull);
      expect(HeritageColors.darkBackground, isNotNull);
      expect(HeritageColors.darkSurface, isNotNull);
      expect(HeritageColors.darkSurfaceContainerLowest, isNotNull);
      expect(HeritageColors.darkSurfaceContainerLow, isNotNull);
      expect(HeritageColors.darkSurfaceContainer, isNotNull);
      expect(HeritageColors.darkSurfaceContainerHigh, isNotNull);
      expect(HeritageColors.darkSurfaceContainerHighest, isNotNull);
      expect(HeritageColors.darkOnSurface, isNotNull);
      expect(HeritageColors.darkOnSurfaceVariant, isNotNull);
      expect(HeritageColors.darkOutline, isNotNull);
      expect(HeritageColors.darkOutlineVariant, isNotNull);
    });

    test('light primary should match spec color', () {
      // #8F372F
      expect(HeritageColors.lightPrimary, const Color(0xFF8F372F));
    });

    test('dark primary should match spec color', () {
      // #FFB4AA
      expect(HeritageColors.darkPrimary, const Color(0xFFFFB4AA));
    });

    test('light background should match spec color', () {
      // #FCF8F5
      expect(HeritageColors.lightBackground, const Color(0xFFFCF8F5));
    });

    test('dark background should match spec color', () {
      // #16100E
      expect(HeritageColors.darkBackground, const Color(0xFF16100E));
    });
  });

  group('HeritageTypography', () {
    test('displaySmall should have correct properties', () {
      expect(HeritageTypography.displaySmall.fontWeight, FontWeight.w600);
      expect(HeritageTypography.displaySmall.fontSize, 34);
    });

    test('headlineLarge should have correct properties', () {
      expect(HeritageTypography.headlineLarge.fontWeight, FontWeight.w600);
      expect(HeritageTypography.headlineLarge.fontSize, 30);
    });

    test('headlineMedium should have correct properties', () {
      expect(HeritageTypography.headlineMedium.fontWeight, FontWeight.w600);
      expect(HeritageTypography.headlineMedium.fontSize, 26);
    });

    test('headlineSmall should have correct properties', () {
      expect(HeritageTypography.headlineSmall.fontWeight, FontWeight.w600);
      expect(HeritageTypography.headlineSmall.fontSize, 22);
    });

    test('titleLarge should have correct properties', () {
      expect(HeritageTypography.titleLarge.fontWeight, FontWeight.w600);
      expect(HeritageTypography.titleLarge.fontSize, 20);
    });

    test('titleMedium should have correct properties', () {
      expect(HeritageTypography.titleMedium.fontWeight, FontWeight.w600);
      expect(HeritageTypography.titleMedium.fontSize, 16);
    });

    test('bodyLarge should have correct properties', () {
      expect(HeritageTypography.bodyLarge.fontWeight, FontWeight.w400);
      expect(HeritageTypography.bodyLarge.fontSize, 16);
    });

    test('bodyMedium should have correct properties', () {
      expect(HeritageTypography.bodyMedium.fontWeight, FontWeight.w400);
      expect(HeritageTypography.bodyMedium.fontSize, 14);
    });

    test('labelLarge should have correct properties', () {
      expect(HeritageTypography.labelLarge.fontWeight, FontWeight.w600);
      expect(HeritageTypography.labelLarge.fontSize, 14);
    });
  });

  group('HeritageShapes', () {
    test('extraSmall radius should be 4', () {
      expect(HeritageShapes.extraSmallRadius, 4.0);
    });

    test('small radius should be 8', () {
      expect(HeritageShapes.smallRadius, 8.0);
    });

    test('medium radius should be 8', () {
      expect(HeritageShapes.mediumRadius, 8.0);
    });

    test('large radius should be 8', () {
      expect(HeritageShapes.largeRadius, 8.0);
    });

    test('extraLarge radius should be 8', () {
      expect(HeritageShapes.extraLargeRadius, 8.0);
    });
  });

  group('HeritageTheme', () {
    test('lightTheme should be defined', () {
      expect(HeritageTheme.lightTheme, isNotNull);
    });

    test('darkTheme should be defined', () {
      expect(HeritageTheme.darkTheme, isNotNull);
    });

    test('lightTheme should use light color scheme', () {
      expect(HeritageTheme.lightTheme.colorScheme.brightness, Brightness.light);
    });

    test('darkTheme should use dark color scheme', () {
      expect(HeritageTheme.darkTheme.colorScheme.brightness, Brightness.dark);
    });

    test('lightTheme primary color should match spec', () {
      expect(HeritageTheme.lightTheme.colorScheme.primary, HeritageColors.lightPrimary);
    });

    test('darkTheme primary color should match spec', () {
      expect(HeritageTheme.darkTheme.colorScheme.primary, HeritageColors.darkPrimary);
    });

    test('lightTheme scaffold background should be surface', () {
      expect(HeritageTheme.lightTheme.scaffoldBackgroundColor, HeritageColors.lightSurface);
    });

    test('darkTheme scaffold background should be surface', () {
      expect(HeritageTheme.darkTheme.scaffoldBackgroundColor, HeritageColors.darkSurface);
    });

    test('lightTheme card color should be surfaceContainerLow', () {
      expect(HeritageTheme.lightTheme.cardTheme.color, HeritageColors.lightSurfaceContainerLow);
    });

    test('darkTheme card color should be surfaceContainerLow', () {
      expect(HeritageTheme.darkTheme.cardTheme.color, HeritageColors.darkSurfaceContainerLow);
    });

    test('lightTheme card elevation should be 0', () {
      expect(HeritageTheme.lightTheme.cardTheme.elevation, 0);
    });

    test('lightTheme card border radius should be 8', () {
      final shape = HeritageTheme.lightTheme.cardTheme.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(8));
    });
  });

  group('AppThemeMode', () {
    test('system should convert to ThemeMode.system', () {
      expect(AppThemeMode.system.toThemeMode(), ThemeMode.system);
    });

    test('light should convert to ThemeMode.light', () {
      expect(AppThemeMode.light.toThemeMode(), ThemeMode.light);
    });

    test('dark should convert to ThemeMode.dark', () {
      expect(AppThemeMode.dark.toThemeMode(), ThemeMode.dark);
    });

    test('fromThemeMode should convert correctly', () {
      expect(AppThemeMode.fromThemeMode(ThemeMode.system), AppThemeMode.system);
      expect(AppThemeMode.fromThemeMode(ThemeMode.light), AppThemeMode.light);
      expect(AppThemeMode.fromThemeMode(ThemeMode.dark), AppThemeMode.dark);
    });
  });

  group('ThemeState', () {
    test('default theme mode should be system', () {
      const state = ThemeState();
      expect(state.themeMode, AppThemeMode.system);
    });

    test('copyWith should update themeMode', () {
      const state = ThemeState();
      final updated = state.copyWith(themeMode: AppThemeMode.dark);
      expect(updated.themeMode, AppThemeMode.dark);
    });

    test('currentThemeMode should reflect themeMode', () {
      const state = ThemeState(themeMode: AppThemeMode.light);
      expect(state.currentThemeMode, ThemeMode.light);
    });
  });

  group('ThemeNotifier', () {
    test('initial state should have system theme mode', () {
      final notifier = ThemeNotifier();
      expect(notifier.state.themeMode, AppThemeMode.system);
    });

    test('setLightTheme should update to light', () {
      final notifier = ThemeNotifier();
      notifier.setLightTheme();
      expect(notifier.state.themeMode, AppThemeMode.light);
    });

    test('setDarkTheme should update to dark', () {
      final notifier = ThemeNotifier();
      notifier.setDarkTheme();
      expect(notifier.state.themeMode, AppThemeMode.dark);
    });

    test('setSystemTheme should update to system', () {
      final notifier = ThemeNotifier();
      notifier.setDarkTheme();
      notifier.setSystemTheme();
      expect(notifier.state.themeMode, AppThemeMode.system);
    });

    test('setThemeMode should update to specified mode', () {
      final notifier = ThemeNotifier();
      notifier.setThemeMode(AppThemeMode.dark);
      expect(notifier.state.themeMode, AppThemeMode.dark);
    });
  });

  group('Dark theme text readability', () {
    test('dark theme body text should have light color (not black)', () {
      final darkTheme = HeritageTheme.darkTheme;
      final bodyColor = darkTheme.textTheme.bodyLarge?.color;

      // 暗色主题的正文颜色不应是黑色或深色
      expect(bodyColor, isNotNull);
      // 亮度应足够高，确保在暗背景上可读
      expect(bodyColor!.computeLuminance(), greaterThan(0.3));
    });

    test('dark theme headline text should have light color', () {
      final darkTheme = HeritageTheme.darkTheme;
      final headlineColor = darkTheme.textTheme.headlineLarge?.color;

      expect(headlineColor, isNotNull);
      expect(headlineColor!.computeLuminance(), greaterThan(0.3));
    });

    test('dark theme title text should have light color', () {
      final darkTheme = HeritageTheme.darkTheme;
      final titleColor = darkTheme.textTheme.titleLarge?.color;

      expect(titleColor, isNotNull);
      expect(titleColor!.computeLuminance(), greaterThan(0.3));
    });

    test('light theme body text should have dark color (not white)', () {
      final lightTheme = HeritageTheme.lightTheme;
      final bodyColor = lightTheme.textTheme.bodyLarge?.color;

      expect(bodyColor, isNotNull);
      // 亮度应足够低，确保在浅背景上可读
      expect(bodyColor!.computeLuminance(), lessThan(0.5));
    });

    test('dark theme onSurface should contrast with surface', () {
      final scheme = HeritageTheme.darkTheme.colorScheme;
      final contrastRatio = _calculateContrastRatio(
        scheme.onSurface,
        scheme.surface,
      );

      // WCAG AA 标准：正文至少 4.5:1
      expect(contrastRatio, greaterThan(4.5));
    });

    test('light theme onSurface should contrast with surface', () {
      final scheme = HeritageTheme.lightTheme.colorScheme;
      final contrastRatio = _calculateContrastRatio(
        scheme.onSurface,
        scheme.surface,
      );

      // WCAG AA 标准：正文至少 4.5:1
      expect(contrastRatio, greaterThan(4.5));
    });
  });
}

/// 计算相对亮度对比度 (WCAG)
double _calculateContrastRatio(Color a, Color b) {
  final lumA = a.computeLuminance();
  final lumB = b.computeLuminance();
  final lighter = lumA > lumB ? lumA : lumB;
  final darker = lumA > lumB ? lumB : lumA;
  return (lighter + 0.05) / (darker + 0.05);
}
