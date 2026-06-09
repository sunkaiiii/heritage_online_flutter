import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/reading_path/reading_path.dart';
import 'package:heritage_online_flutter/core/saved/saved.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 我的页
class MyPage extends ConsumerWidget {
  final VoidCallback onBack;

  const MyPage({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _FavoritesTab(),
            _RecentTab(),
            _ReadingPathTab(),
          ],
        ),
      ),
    );
  }
}

/// 收藏 Tab
class _FavoritesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return EmptyState(message: l10n.favoritesEmptyMessage);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return _SavedContentCard(
          entity: item,
          onRemove: () {
            final repo = ref.read(savedContentRepositoryProvider);
            final target = SavedContentTarget(
              id: item.targetId,
              sourceId: item.targetSourceId,
              sourceUrl: item.targetSourceUrl,
            );
            repo.removeFavorite(target);
            // 刷新
            ref.invalidate(favoritesProvider);
          },
        );
      },
    );
  }
}

/// 最近浏览 Tab
class _RecentTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final recent = ref.watch(recentlyViewedProvider);

    if (recent.isEmpty) {
      return EmptyState(message: l10n.recentEmptyMessage);
    }

    return Column(
      children: [
        // 清空按钮
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  final repo = ref.read(savedContentRepositoryProvider);
                  repo.clearRecent();
                  ref.invalidate(recentlyViewedProvider);
                },
                child: Text(l10n.actionClearRecent),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recent.length,
            itemBuilder: (context, index) {
              final item = recent[index];
              return _SavedContentCard(
                entity: item,
                onRemove: () {
                  final repo = ref.read(savedContentRepositoryProvider);
                  final target = SavedContentTarget(
                    id: item.targetId,
                    sourceId: item.targetSourceId,
                    sourceUrl: item.targetSourceUrl,
                  );
                  repo.removeRecent(target);
                  ref.invalidate(recentlyViewedProvider);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 阅读路径 Tab
class _ReadingPathTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pathEvents = ref.watch(readingPathProvider);

    if (pathEvents.isEmpty) {
      return EmptyState(message: l10n.readingPathEmpty);
    }

    return Column(
      children: [
        // 清空按钮
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  final repo = ref.read(readingPathRepositoryProvider);
                  repo.clear();
                  ref.invalidate(readingPathProvider);
                },
                child: Text(l10n.readingPathClear),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pathEvents.length,
            itemBuilder: (context, index) {
              final event = pathEvents[index];
              return _ReadingPathCard(event: event);
            },
          ),
        ),
      ],
    );
  }
}

/// 阅读路径卡片
class _ReadingPathCard extends StatelessWidget {
  final ReadingPathEvent event;

  const _ReadingPathCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.arrow_forward),
        title: Text(
          event.toTitle ?? l10n.commonEmpty,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${localizedContentType(context, event.fromType) ?? event.fromType ?? ""} → ${localizedContentType(context, event.toType) ?? event.toType}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _getSourceLabel(context, event.source),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Text(
          _getSourceLabel(context, event.source),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () => _navigateToDetail(context),
      ),
    );
  }

  String _getSourceLabel(BuildContext context, String source) {
    return localizedReadingPathSource(context, source);
  }

  void _navigateToDetail(BuildContext context) {
    final toType = event.toType;
    // 回跳规则（spec 5.5）：如果有 toSourceId 或 toSourceUrl，把 id 置空
    final hasExternalKey = (event.toSourceId?.isNotEmpty == true) ||
        (event.toSourceUrl?.isNotEmpty == true);

    if (toType == 'article') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ArticleDetailPage(
            articleId: hasExternalKey ? null : _nonNull(event.toId),
            sourceId: _nonNull(event.toSourceId),
            sourceUrl: _nonNull(event.toSourceUrl),
            category: event.toCategory?.isNotEmpty == true
                ? ArticleCategory.fromWireName(event.toCategory!)
                : ArticleCategory.news,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (toType == 'directoryItem') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DirectoryDetailPage(
            itemId: hasExternalKey ? null : _nonNull(event.toId),
            sourceId: _nonNull(event.toSourceId),
            kind: event.toKind?.isNotEmpty == true
                ? DirectoryItemKind.fromWireName(event.toKind!)
                : DirectoryItemKind.nationalProject,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (toType == 'inheritor') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InheritorDetailPage(
            inheritorId: hasExternalKey ? null : _nonNull(event.toId),
            sourceId: _nonNull(event.toSourceId),
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  /// 空字符串视为 null
  String? _nonNull(String? value) =>
      value?.isNotEmpty == true ? value : null;
}

/// 保存内容卡片
class _SavedContentCard extends StatelessWidget {
  final SavedContentEntity entity;
  final VoidCallback onRemove;

  const _SavedContentCard({
    required this.entity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contentType = SavedContentType.fromWireName(entity.contentType);

    return Dismissible(
      key: Key(entity.contentKey),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: ListCard(
        onTap: () => _navigateToDetail(context, contentType),
        image: SizedBox(
          width: 60,
          height: 60,
          child: ImagePlaceholder(
            text: entity.title?.isNotEmpty == true
                ? entity.title!.substring(0, 1)
                : '',
          ),
        ),
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MetaChip(text: _getContentTypeLabel(l10n, contentType)),
            const SizedBox(height: 4),
            Text(
              entity.title ?? l10n.commonEmpty,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (entity.summary != null && entity.summary!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                entity.summary!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getContentTypeLabel(AppLocalizations l10n, SavedContentType type) {
    switch (type) {
      case SavedContentType.article:
        return l10n.contentTypeArticle;
      case SavedContentType.directoryItem:
        return l10n.contentTypeDirectory;
      case SavedContentType.inheritor:
        return l10n.contentTypeInheritor;
    }
  }

  void _navigateToDetail(BuildContext context, SavedContentType type) {
    switch (type) {
      case SavedContentType.article:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(
              articleId: _nonNull(entity.targetId),
              sourceId: _nonNull(entity.targetSourceId),
              sourceUrl: _nonNull(entity.targetSourceUrl),
              category: entity.targetCategory?.isNotEmpty == true
                  ? ArticleCategory.fromWireName(entity.targetCategory!)
                  : ArticleCategory.news,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
        break;
      case SavedContentType.directoryItem:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DirectoryDetailPage(
              itemId: _nonNull(entity.targetId),
              sourceId: _nonNull(entity.targetSourceId),
              kind: entity.targetKind?.isNotEmpty == true
                  ? DirectoryItemKind.fromWireName(entity.targetKind!)
                  : DirectoryItemKind.nationalProject,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
        break;
      case SavedContentType.inheritor:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InheritorDetailPage(
              inheritorId: _nonNull(entity.targetId),
              sourceId: _nonNull(entity.targetSourceId),
              onBack: () => Navigator.of(context).pop(),
            ),
          ),
        );
        break;
    }
  }

  /// 空字符串视为 null
  String? _nonNull(String? value) =>
      value?.isNotEmpty == true ? value : null;
}
