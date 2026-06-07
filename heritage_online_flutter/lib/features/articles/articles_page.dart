import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 文章列表页 - 占位
class ArticlesPage extends StatelessWidget {
  final VoidCallback? onSettingsSelected;
  final ValueChanged<bool>? onDetailChanged;

  const ArticlesPage({
    super.key,
    this.onSettingsSelected,
    this.onDetailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.articlesHeaderTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsTitle,
            onPressed: onSettingsSelected,
          ),
        ],
      ),
      body: Center(
        child: Text(l10n.tabArticles),
      ),
    );
  }
}
