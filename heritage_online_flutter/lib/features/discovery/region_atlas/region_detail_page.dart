import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/explore_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_atlas_ui_state.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_atlas_view_model.dart';
import 'package:heritage_online_flutter/ui/utils/content_navigator.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 地区详情页
class RegionDetailPage extends ConsumerWidget {
  final String region;
  final VoidCallback onBack;
  final ValueChanged<String>? onRegionTap;

  const RegionDetailPage({
    super.key,
    required this.region,
    required this.onBack,
    this.onRegionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(regionDetailViewModelProvider(region));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(state.detail?.displayName ?? region),
      ),
      body: PageBackground(
        child: _buildBody(context, l10n, state, ref),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    RegionDetailUiState state,
    WidgetRef ref,
  ) {
    if (state.isLoading) {
      return const LoadingPlaceholder();
    }

    if (state.error != null) {
      return ErrorRetryRow(
        message: l10n.commonError,
        onRetry: () =>
            ref.read(regionDetailViewModelProvider(region).notifier).retry(),
      );
    }

    final detail = state.detail;
    if (detail == null) {
      return EmptyState(message: l10n.commonEmpty);
    }

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(regionDetailViewModelProvider(region).notifier).retry(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 统计卡片
          if (detail.stats != null) _StatsRow(stats: detail.stats!, l10n: l10n),
          const SizedBox(height: 20),

          // 类别分布
          if (detail.categoryBreakdown.isNotEmpty) ...[
            SectionHeader(title: l10n.regionAtlasCategoryBreakdown),
            const SizedBox(height: 8),
            _BreakdownRow(items: detail.categoryBreakdown),
            const SizedBox(height: 20),
          ],

          // 种类分布
          if (detail.kindBreakdown.isNotEmpty) ...[
            SectionHeader(title: l10n.regionAtlasKindBreakdown),
            const SizedBox(height: 8),
            _BreakdownRow(items: detail.kindBreakdown),
            const SizedBox(height: 20),
          ],

          // 精选名录
          if (detail.featuredDirectoryItems.isNotEmpty) ...[
            SectionHeader(title: l10n.regionAtlasFeaturedDirectory),
            const SizedBox(height: 8),
            ...detail.featuredDirectoryItems.map(
              (item) => _DirectoryItemRow(
                item: item,
                onTap: () => _navigateToDirectoryDetail(context, item),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 精选传承人
          if (detail.featuredInheritors.isNotEmpty) ...[
            SectionHeader(title: l10n.regionAtlasFeaturedInheritors),
            const SizedBox(height: 8),
            ...detail.featuredInheritors.map(
              (item) => _InheritorRow(
                item: item,
                onTap: () => _navigateToInheritorDetail(context, item),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 相关文章
          if (detail.relatedArticles.isNotEmpty) ...[
            SectionHeader(title: l10n.regionAtlasRelatedArticles),
            const SizedBox(height: 8),
            ...detail.relatedArticles.map(
              (item) => _ArticleRow(
                item: item,
                onTap: () => _navigateToArticleDetail(context, item),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 时间线
          if (detail.timeline.isNotEmpty) ...[
            SectionHeader(title: l10n.exploreTopicTimeline),
            const SizedBox(height: 8),
            ...detail.timeline.map(
              (item) => _TimelineRow(item: item),
            ),
            const SizedBox(height: 20),
          ],

          // 相关地区
          if (detail.relatedRegions.isNotEmpty) ...[
            SectionHeader(title: l10n.regionAtlasRelatedRegions),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: detail.relatedRegions.map((regionLink) {
                return ActionChip(
                  label: Text(regionLink.title ?? regionLink.key ?? ''),
                  onPressed: () {
                    if (onRegionTap != null && regionLink.key != null) {
                      onRegionTap!(regionLink.key!);
                    }
                  },
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _navigateToArticleDetail(BuildContext context, ArticleSummaryDto item) {
    ContentNavigator.toArticle(
      context,
      id: item.id,
      sourceId: item.sourceId,
      sourceUrl: item.sourceUrl,
      category: item.category.wireName,
    );
  }

  void _navigateToDirectoryDetail(
      BuildContext context, DirectoryItemSummaryDto item) {
    ContentNavigator.toDirectory(
      context,
      id: item.id,
      sourceId: item.sourceId,
      kind: item.kind.wireName,
    );
  }

  void _navigateToInheritorDetail(
      BuildContext context, InheritorSummaryDto item) {
    ContentNavigator.toInheritor(
      context,
      id: item.id,
      sourceId: item.sourceId,
    );
  }
}

/// 统计卡片行
class _StatsRow extends StatelessWidget {
  final RegionAtlasDetailStatsDto stats;
  final AppLocalizations l10n;

  const _StatsRow({required this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatChip(context, '${stats.directoryItemCount}',
            l10n.regionAtlasDirectoryItems),
        const SizedBox(width: 8),
        _buildStatChip(context, '${stats.inheritorCount}',
            l10n.regionAtlasInheritors),
        const SizedBox(width: 8),
        _buildStatChip(context, '${stats.total}', l10n.regionAtlasTotal),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breakdown 横向滚动行
class _BreakdownRow extends StatelessWidget {
  final List<FacetBucketDto> items;

  const _BreakdownRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.key ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${item.count}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 名录项行
class _DirectoryItemRow extends StatelessWidget {
  final DirectoryItemSummaryDto item;
  final VoidCallback onTap;

  const _DirectoryItemRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListCard(
        onTap: onTap,
        image: SizedBox(
          width: 56,
          height: 56,
          child: imageUrl != null
              ? ListImage(imageUrl: imageUrl, fallbackText: item.title ?? '')
              : ImagePlaceholder(
                  text: item.title?.isNotEmpty == true
                      ? item.title!.substring(0, 1)
                      : '',
                ),
        ),
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: [
                if (item.kind != DirectoryItemKind.nationalProject)
                  MetaChip(text: localizedDirectoryKind(context, item.kind.wireName) ?? item.kind.wireName),
                if (item.region != null && item.region!.isNotEmpty)
                  MetaChip(text: item.region!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 传承人行
class _InheritorRow extends StatelessWidget {
  final InheritorSummaryDto item;
  final VoidCallback onTap;

  const _InheritorRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListCard(
        onTap: onTap,
        image: SizedBox(
          width: 56,
          height: 56,
          child: imageUrl != null
              ? ListImage(imageUrl: imageUrl, fallbackText: item.name ?? '')
              : ImagePlaceholder(
                  text: item.name?.isNotEmpty == true
                      ? item.name!.substring(0, 1)
                      : '',
                ),
        ),
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.projectName != null) ...[
              const SizedBox(height: 2),
              Text(
                item.projectName!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: [
                if (item.category != null && item.category!.isNotEmpty)
                  MetaChip(text: item.category!),
                if (item.region != null && item.region!.isNotEmpty)
                  MetaChip(text: item.region!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 文章行
class _ArticleRow extends StatelessWidget {
  final ArticleSummaryDto item;
  final VoidCallback onTap;

  const _ArticleRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListCard(
        onTap: onTap,
        image: SizedBox(
          width: 56,
          height: 56,
          child: imageUrl != null
              ? ListImage(imageUrl: imageUrl, fallbackText: item.title ?? '')
              : ImagePlaceholder(
                  text: item.title?.isNotEmpty == true
                      ? item.title!.substring(0, 1)
                      : '',
                ),
        ),
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.category != ArticleCategory.news)
              MetaChip(
                  text: localizedArticleCategory(
                          context, item.category.wireName) ??
                      item.category.wireName),
            Text(
              item.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.summary != null && item.summary!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                item.summary!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 时间线条目行
class _TimelineRow extends StatelessWidget {
  final ExploreTopicItemDto item;

  const _TimelineRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ContentCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (item.year != null) ...[
              MetaChip(text: '${item.year}'),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item.title ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
