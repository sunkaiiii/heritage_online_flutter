import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/theme/theme.dart';
import 'package:heritage_online_flutter/features/app_shell.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 应用根组件
class HeritageApp extends ConsumerWidget {
  const HeritageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Heritage Online',
      debugShowCheckedModeBanner: false,

      // 本地化配置（使用生成的 delegates 和 locales，保证一致性）
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // 主题配置 - 使用 HeritageTheme
      theme: themeState.lightTheme,
      darkTheme: themeState.darkTheme,
      themeMode: themeState.currentThemeMode,

      // App Shell
      home: const AppShell(),
    );
  }
}
