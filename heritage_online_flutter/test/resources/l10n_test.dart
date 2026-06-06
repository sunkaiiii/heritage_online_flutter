import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

void main() {
  group('AppLocalizations', () {
    test('should have supported locales', () {
      final locales = AppLocalizations.supportedLocales;
      expect(locales, isNotEmpty);
      expect(locales.any((l) => l.languageCode == 'zh'), isTrue);
      expect(locales.any((l) => l.languageCode == 'en'), isTrue);
    });

    test('should have localizations delegates', () {
      final delegates = AppLocalizations.localizationsDelegates;
      expect(delegates, isNotEmpty);
      expect(delegates.contains(AppLocalizations.delegate), isTrue);
    });

    test('should lookup English translations', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(l10n.appTitle, 'Heritage Online');
      expect(l10n.tabArticles, 'Articles');
      expect(l10n.tabDirectory, 'Directory');
      expect(l10n.tabInheritors, 'Inheritors');
      expect(l10n.tabDiscovery, 'Discovery');
      expect(l10n.commonRetry, 'Retry');
      expect(l10n.commonLoading, 'Loading...');
      expect(l10n.commonError, 'Something went wrong');
      expect(l10n.commonEmpty, 'No data available');
      expect(l10n.commonSeeAll, 'See All');
      expect(l10n.settingsTitle, 'Settings');
      expect(l10n.settingsLanguage, 'Language');
      expect(l10n.settingsTheme, 'Theme');
      expect(l10n.settingsThemeLight, 'Light');
      expect(l10n.settingsThemeDark, 'Dark');
      expect(l10n.settingsThemeSystem, 'System');
    });

    test('should lookup Chinese translations', () {
      final l10n = lookupAppLocalizations(const Locale('zh'));
      expect(l10n.appTitle, '非遗在线');
      expect(l10n.tabArticles, '文章');
      expect(l10n.tabDirectory, '名录');
      expect(l10n.tabInheritors, '传承人');
      expect(l10n.tabDiscovery, '发现');
      expect(l10n.commonRetry, '重试');
      expect(l10n.commonLoading, '加载中...');
      expect(l10n.commonError, '出错了');
      expect(l10n.commonEmpty, '暂无数据');
      expect(l10n.commonSeeAll, '查看全部');
      expect(l10n.settingsTitle, '设置');
      expect(l10n.settingsLanguage, '语言');
      expect(l10n.settingsTheme, '主题');
      expect(l10n.settingsThemeLight, '浅色');
      expect(l10n.settingsThemeDark, '深色');
      expect(l10n.settingsThemeSystem, '跟随系统');
    });
  });
}
