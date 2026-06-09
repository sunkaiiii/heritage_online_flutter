import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_ui_state.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_view_model.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 合集详情页
class CollectionDetailPage extends ConsumerWidget {
  final String? collectionId;
  final String? topicType;
  final String? topicKey;
  final VoidCallback onBack;

  const CollectionDetailPage({
    super.key,
    this.collectionId,
    this.topicType,
    this.topicKey,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = CollectionDetailParams(
      id: collectionId,
      type: topicType,
      topicKey: topicKey,
    );
    final state = ref.watch(collectionDetailViewModelProvider(params));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(state.collection?.title ?? l10n.discoveryFeaturedCollections),
      ),
      body: PageBackground(
        child: _buildBody(context, l10n, state, ref, params),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    CollectionDetailUiState state,
    WidgetRef ref,
    CollectionDetailParams params,
  ) {
    if (state.isLoading) {
      return const LoadingPlaceholder();
    }

    if (state.error != null) {
      return ErrorRetryRow(
        message: l10n.commonError,
        onRetry: () =>
            ref.read(collectionDetailViewModelProvider(params).notifier).retry(),
      );
    }

    final collection = state.collection;
    if (collection == null) {
      return EmptyState(message: l10n.commonEmpty);
    }

    if (collection.items.isEmpty) {
      return EmptyState(message: l10n.collectionEmptyItems);
    }

    return _CollectionContent(
      collection: collection,
      l10n: l10n,
      onItemTap: (item) => _navigateToItemDetail(context, item),
    );
  }

  void _navigateToItemDetail(BuildContext context, CollectionItemDto item) {
    final type = item.type ?? '';
    final itemId = item.id;

    if (type == 'article') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleDetailPage(
            articleId: itemId?.isNotEmpty == true ? itemId : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl?.isNotEmpty == true ? item.sourceUrl : null,
            category: item.category?.isNotEmpty == true
                ? ArticleCategory.fromWireName(item.category!)
                : ArticleCategory.news,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (type == 'directoryItem') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DirectoryDetailPage(
            itemId: itemId?.isNotEmpty == true ? itemId : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            kind: item.kind?.isNotEmpty == true
                ? DirectoryItemKind.fromWireName(item.kind!)
                : DirectoryItemKind.nationalProject,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (type == 'inheritor') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InheritorDetailPage(
            inheritorId: itemId?.isNotEmpty == true ? itemId : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }
}

/// 合集内容
class _CollectionContent extends StatelessWidget {
  final CollectionDto collection;
  final AppLocalizations l10n;
  final ValueChanged<CollectionItemDto> onItemTap;

  const _CollectionContent({
    required this.collection,
    required this.l10n,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // 标题和副标题
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (collection.subtitle != null &&
                  collection.subtitle!.isNotEmpty) ...[
                Text(
                  collection.subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),

        // 标签行
        if (collection.type != null ||
            collection.tags.isNotEmpty ||
            collection.generatedAt != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (collection.type != null && collection.type!.isNotEmpty)
                  MetaChip(
                    text: localizedContentType(context, collection.type!) ??
                        collection.type!,
                  ),
                ...collection.tags.map((tag) => MetaChip(text: tag)),
                if (collection.generatedAt != null &&
                    collection.generatedAt!.isNotEmpty)
                  MetaChip(text: collection.generatedAt!),
              ],
            ),
          ),

        // 条目数量
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.collectionItemCount(collection.items.length),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),

        // 条目列表
        ...collection.items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: _CollectionItemRow(
              item: item,
              onTap: () => onItemTap(item),
            ),
          ),
        ),
      ],
    );
  }
}

/// 合集条目行
class _CollectionItemRow extends StatelessWidget {
  final CollectionItemDto item;
  final VoidCallback onTap;

  const _CollectionItemRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

    return ContentCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: imageUrl != null
                  ? ListImage(
                      imageUrl: imageUrl,
                      fallbackText: item.title?.isNotEmpty == true
                          ? item.title!.substring(0, 1)
                          : '',
                    )
                  : ImagePlaceholder(
                      text: item.title?.isNotEmpty == true
                          ? item.title!.substring(0, 1)
                          : '',
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // 文本内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 类型和分类标签
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    if (item.type != null)
                      MetaChip(
                        text: localizedContentType(context, item.type!) ??
                            item.type!,
                      ),
                    if (item.category != null && item.category!.isNotEmpty)
                      MetaChip(text: item.category!),
                    if (item.kind != null && item.kind!.isNotEmpty)
                      MetaChip(
                        text: localizedDirectoryKind(context, item.kind!) ??
                            item.kind!,
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // 标题
                Text(
                  item.title ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // 摘要
                if (item.summary != null && item.summary!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.summary!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // 地区和年份
                if (item.region != null || item.publishedYear != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.region != null && item.region!.isNotEmpty)
                        Text(
                          item.region!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      if (item.region != null &&
                          item.region!.isNotEmpty &&
                          item.publishedYear != null)
                        Text(
                          ' · ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      if (item.publishedYear != null)
                        Text(
                          '${item.publishedYear}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
