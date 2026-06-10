import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/timeline_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/discovery/timeline/timeline_ui_state.dart';
import 'package:heritage_online_flutter/features/discovery/timeline/timeline_view_model.dart';
import 'package:heritage_online_flutter/ui/utils/content_navigator.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 时间线页面
class TimelineDetailPage extends ConsumerWidget {
  final VoidCallback onBack;

  const TimelineDetailPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(timelineViewModelProvider);
    final viewModel = ref.read(timelineViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.discoveryTimeline),
      ),
      body: PageBackground(
        child: _buildBody(context, l10n, state, viewModel),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    TimelineUiState state,
    TimelineViewModel viewModel,
  ) {
    // 年份加载失败
    if (state.yearsError != null && state.years.isEmpty) {
      return ErrorRetryRow(
        message: l10n.commonError,
        onRetry: () => viewModel.retryLoadYears(),
      );
    }

    // 年份加载中
    if (state.isLoadingYears) {
      return const LoadingPlaceholder();
    }

    return Column(
      children: [
        // 年份选择器
        _YearSelector(
          years: state.years,
          selectedYear: state.selectedYear,
          onYearSelected: (year) => viewModel.selectYear(year),
        ),

        // 类型筛选 — 选中年份后始终显示
        if (state.selectedYear != null)
          _TypeFilterRow(
            facets: state.facets,
            selectedTypes: state.selectedTypes,
            onTypeToggled: (type) => viewModel.toggleType(type),
          ),

        // 内容区域
        Expanded(
          child: _buildContent(context, l10n, state, viewModel),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    TimelineUiState state,
    TimelineViewModel viewModel,
  ) {
    // 未选择年份
    if (state.needsYearSelection) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.date_range,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.timelineSelectYear,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // 条目加载中
    if (state.isLoadingItems) {
      return const LoadingPlaceholder();
    }

    // 条目加载失败
    if (state.itemsError != null && state.items.isEmpty) {
      return ErrorRetryRow(
        message: l10n.commonError,
        onRetry: () => viewModel.retryLoadItems(),
      );
    }

    // 条目为空
    if (state.items.isEmpty) {
      return EmptyState(message: l10n.timelineNoItems);
    }

    // 时间线列表
    return _TimelineItemsList(
      items: state.items,
      hasMore: state.hasMore,
      isLoadingMore: state.isLoadingMore,
      loadMoreError: state.loadMoreError,
      onLoadMore: () => viewModel.loadMore(),
      selectedYear: state.selectedYear,
    );
  }
}

/// 年份选择器
class _YearSelector extends StatelessWidget {
  final List<TimelineYearBucketDto> years;
  final int? selectedYear;
  final ValueChanged<int> onYearSelected;

  const _YearSelector({
    required this.years,
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (years.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final yb = years[index];
          final isSelected = selectedYear == yb.year;

          return ChoiceChip(
            selected: isSelected,
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${yb.year}',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  l10n.timelineYearStats(
                    yb.total,
                    yb.articleCount,
                    yb.directoryItemCount,
                    yb.inheritorCount,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            onSelected: (_) => onYearSelected(yb.year),
          );
        },
      ),
    );
  }
}

/// 类型筛选行
class _TypeFilterRow extends StatelessWidget {
  final List<FacetBucketDto> facets;
  final Set<SearchResultType> selectedTypes;
  final ValueChanged<SearchResultType> onTypeToggled;

  const _TypeFilterRow({
    required this.facets,
    required this.selectedTypes,
    required this.onTypeToggled,
  });

  @override
  Widget build(BuildContext context) {
    // 如果没有 facets 数据，使用默认三类型
    final displayFacets = facets.isNotEmpty
        ? facets
        : [
            const FacetBucketDto(key: 'article', count: 0),
            const FacetBucketDto(key: 'directoryItem', count: 0),
            const FacetBucketDto(key: 'inheritor', count: 0),
          ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: displayFacets.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final facet = displayFacets[index];
          final key = facet.key;
          if (key == null) return const SizedBox.shrink();

          final type = SearchResultType.fromWireName(key);
          final label = facet.count > 0
              ? '${localizedContentType(context, key) ?? key} (${facet.count})'
              : (localizedContentType(context, key) ?? key);
          final isSelected = selectedTypes.contains(type);

          return FilterChip(
            selected: isSelected,
            label: Text(label),
            onSelected: (_) => onTypeToggled(type),
          );
        },
      ),
    );
  }
}

/// 时间线条目列表
class _TimelineItemsList extends StatelessWidget {
  final List<TimelineItemDto> items;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;
  final VoidCallback onLoadMore;
  final int? selectedYear;

  const _TimelineItemsList({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    this.loadMoreError,
    required this.onLoadMore,
    this.selectedYear,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 24),
      itemCount: items.length + (hasMore || loadMoreError != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          // 底部加载更多区域
          return _buildLoadMoreArea(context);
        }

        final item = items[index];
        return _TimelineItemRow(
          item: item,
          onTap: () => _navigateToDetail(context, item),
        );
      },
    );
  }

  Widget _buildLoadMoreArea(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ErrorRetryRow(
          message: l10n.commonError,
          onRetry: onLoadMore,
        ),
      );
    }

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: OutlinedButton(
            onPressed: onLoadMore,
            child: Text(l10n.timelineLoadMore),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _navigateToDetail(BuildContext context, TimelineItemDto item) {
    ContentNavigator.toDetail(
      context,
      type: item.type ?? '',
      id: item.id,
      sourceId: item.sourceId,
      sourceUrl: item.sourceUrl,
      category: item.category,
      kind: item.kind,
    );
  }
}

/// 时间线条目行（纵向时间线样式）
class _TimelineItemRow extends StatelessWidget {
  final TimelineItemDto item;
  final VoidCallback onTap;

  const _TimelineItemRow({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左侧时间线指示器
          SizedBox(
            width: 56,
            child: Column(
              children: [
                // 年份数字
                if (item.year != null)
                  Text(
                    '${item.year}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                // 日期
                if (item.date != null && item.date!.isNotEmpty)
                  Text(
                    item.date!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                // 连接线
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),

          // 右侧内容卡片
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 8),
              child: ContentCard(
                onTap: onTap,
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图片
                    if (imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: ListImage(
                            imageUrl: imageUrl,
                            fallbackText: item.title ?? '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

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
                              if (item.category != null &&
                                  item.category!.isNotEmpty)
                                MetaChip(text: item.category!),
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
                          if (item.summary != null &&
                              item.summary!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.summary!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          // 地区和种类标签
                          if (item.region != null || item.kind != null) ...[
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 2,
                              children: [
                                if (item.region != null &&
                                    item.region!.isNotEmpty)
                                  MetaChip(text: item.region!),
                                if (item.kind != null &&
                                    item.kind!.isNotEmpty)
                                  MetaChip(text: item.kind!),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
