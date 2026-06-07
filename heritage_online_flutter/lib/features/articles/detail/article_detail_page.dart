import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 文章详情页 - 占位
class ArticleDetailPage extends StatelessWidget {
  final String articleId;
  final VoidCallback onBack;

  const ArticleDetailPage({
    super.key,
    required this.articleId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.articleDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: l10n.actionFavorite,
            onPressed: () {},
          ),
        ],
      ),
      body: PageBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.article, size: 64),
              const SizedBox(height: 16),
              Text(
                l10n.articleDetailTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'ID: $articleId',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
