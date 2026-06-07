import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 我的页 - 占位
class MyPage extends StatelessWidget {
  final VoidCallback onBack;

  const MyPage({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            tooltip: l10n.actionBack,
          ),
          title: Text(l10n.myTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.favoritesTab),
              Tab(text: l10n.recentTab),
              Tab(text: l10n.readingPathTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 收藏 - 占位
            Center(child: Text(l10n.commonEmpty)),
            // 最近浏览 - 占位
            Center(child: Text(l10n.commonEmpty)),
            // 阅读路径 - 占位
            Center(child: Text(l10n.commonEmpty)),
          ],
        ),
      ),
    );
  }
}
