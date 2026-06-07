import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 设置页
class SettingsPage extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback onMyPageClick;

  const SettingsPage({
    super.key,
    required this.onBack,
    required this.onMyPageClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeModeState = ref.watch(themeModeProvider);
    final languageModeState = ref.watch(languageModeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          // 我的页入口
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.myTitle),
            subtitle: Text('${l10n.favoritesTab}、${l10n.recentTab}、${l10n.readingPathTab}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onMyPageClick,
          ),
          const Divider(),

          // 主题设置
          _buildSectionHeader(context, l10n.settingsAppearanceTitle),
          _buildThemeModeTile(context, ref, l10n, themeModeState.themeMode),
          const Divider(),

          // 语言设置
          _buildSectionHeader(context, l10n.settingsLanguageTitle),
          _buildLanguageModeTile(context, ref, l10n, languageModeState.languageMode),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildThemeModeTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppThemeMode currentMode,
  ) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.settingsThemeModeTitle),
      subtitle: Text(_getThemeModeLabel(l10n, currentMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeModePicker(context, ref, l10n, currentMode),
    );
  }

  Widget _buildLanguageModeTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppLanguageMode currentMode,
  ) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.settingsLanguageModeTitle),
      subtitle: Text(_getLanguageModeLabel(l10n, currentMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageModePicker(context, ref, l10n, currentMode),
    );
  }

  String _getThemeModeLabel(AppLocalizations l10n, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return l10n.settingsThemeSystem;
      case AppThemeMode.light:
        return l10n.settingsThemeLight;
      case AppThemeMode.dark:
        return l10n.settingsThemeDark;
    }
  }

  String _getLanguageModeLabel(AppLocalizations l10n, AppLanguageMode mode) {
    switch (mode) {
      case AppLanguageMode.system:
        return l10n.settingsLanguageSystem;
      case AppLanguageMode.simplifiedChinese:
        return l10n.settingsLanguageSimplifiedChinese;
      case AppLanguageMode.english:
        return l10n.settingsLanguageEnglish;
    }
  }

  void _showThemeModePicker(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppThemeMode currentMode,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.settingsThemeModeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...AppThemeMode.values.map((mode) {
                final isSelected = mode == currentMode;
                return ListTile(
                  title: Text(_getThemeModeLabel(l10n, mode)),
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageModePicker(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AppLanguageMode currentMode,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.settingsLanguageModeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...AppLanguageMode.values.map((mode) {
                final isSelected = mode == currentMode;
                return ListTile(
                  title: Text(_getLanguageModeLabel(l10n, mode)),
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onTap: () {
                    ref.read(languageModeProvider.notifier).setLanguageMode(mode);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
