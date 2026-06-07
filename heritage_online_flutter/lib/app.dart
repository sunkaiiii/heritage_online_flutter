import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings.dart';
import 'package:heritage_online_flutter/core/theme/heritage_theme.dart';
import 'package:heritage_online_flutter/features/app_shell.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 应用根组件
class HeritageApp extends ConsumerWidget {
  const HeritageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeState = ref.watch(themeModeProvider);
    final languageModeState = ref.watch(languageModeProvider);

    return MaterialApp(
      title: 'Heritage Online',
      debugShowCheckedModeBanner: false,

      // 本地化配置
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: languageModeState.currentLocale,

      // 主题配置 - 使用 HeritageTheme
      theme: HeritageTheme.lightTheme,
      darkTheme: HeritageTheme.darkTheme,
      themeMode: themeModeState.currentThemeMode,

      // App Shell
      home: const AppShell(),
    );
  }
}
