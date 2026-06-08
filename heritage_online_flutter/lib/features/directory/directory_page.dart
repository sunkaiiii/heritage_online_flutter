import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/directory/directory_ui_state.dart';
import 'package:heritage_online_flutter/features/directory/directory_view_model.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 名录列表页
class DirectoryPage extends ConsumerStatefulWidget {
  final ValueChanged<bool>? onDetailChanged;

  const DirectoryPage({
    super.key,
    this.onDetailChanged,
  });

  @override
  ConsumerState<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends ConsumerState<DirectoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFilterSheet = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(directoryViewModelProvider);
      if (state.hasMore && !state.isLoadingMore && state.itemsAppendError == null) {
        ref.read(directoryViewModelProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(directoryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.directoryTitle),
            Text(
              l10n.directorySubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          FilterButton(
            activeFilterCount: state.activeFilterCount,
            tooltip: l10n.filterButton,
            onPressed: () => setState(() => _showFilterSheet = true),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.actionRefresh,
            onPressed: () =>
                ref.read(directoryViewModelProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageBackground(
            child: Column(
              children: [
                // Tab 切换：名录 / 统计
                _buildTabBar(context, state, l10n),

                // 内容区域
                Expanded(
                  child: state.selectedTab == DirectoryTab.list
                      ? _buildListTab(context, ref, state, l10n)
                      : _buildStatisticsTab(context, ref, state, l10n),
                ),
              ],
            ),
          ),
          // 筛选 BottomSheet
          if (_showFilterSheet)
            _DirectoryFilterSheet(
              initialRegion: state.regionFilter,
              initialCategory: state.categoryFilter,
              initialYear: state.yearFilter,
              initialListType: state.listTypeFilter,
              onApply: (region, category, year, listType) {
                setState(() => _showFilterSheet = false);
                ref.read(directoryViewModelProvider.notifier).applyFilters(
                      region: region,
                      category: category,
                      year: year,
                      listType: listType,
                    );
              },
              onClear: () {
                setState(() => _showFilterSheet = false);
                ref.read(directoryViewModelProvider.notifier).clearFilters();
              },
              onDismiss: () => setState(() => _showFilterSheet = false),
              l10n: l10n,
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    DirectoryUiState state,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            label: l10n.directoryTabList,
            isSelected: state.selectedTab == DirectoryTab.list,
            onTap: () => ref.read(directoryViewModelProvider.notifier).selectTab(DirectoryTab.list),
          ),
          _buildTab(
            context,
            label: l10n.directoryTabStatistics,
            isSelected: state.selectedTab == DirectoryTab.statistics,
            onTap: () => ref.read(directoryViewModelProvider.notifier).selectTab(DirectoryTab.statistics),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }

  // ==================== 名录 Tab ====================

  Widget _buildListTab(
    BuildContext context,
    WidgetRef ref,
    DirectoryUiState state,
    AppLocalizations l10n,
  ) {
    return RefreshIndicator(
      onRefresh: () => ref.read(directoryViewModelProvider.notifier).refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 搜索框
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SearchField(
                value: state.searchKeywords,
                onChanged: (value) => ref.read(directoryViewModelProvider.notifier).updateSearchKeywords(value),
                label: l10n.directorySearchLabel,
                placeholder: l10n.directorySearchPlaceholder,
                onSearch: (_) => ref.read(directoryViewModelProvider.notifier).search(),
              ),
            ),
          ),

          // Kind chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildKindChips(context, state, l10n),
            ),
          ),

          // 活跃筛选
          if (state.hasActiveFilters)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: _buildActiveFilters(context, ref, state),
              ),
            ),

          // 名录列表
          _buildItemList(context, ref, state, l10n),
        ],
      ),
    );
  }

  Widget _buildKindChips(
    BuildContext context,
    DirectoryUiState state,
    AppLocalizations l10n,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DirectoryItemKind.values.map((kind) {
        final label = localizedDirectoryKind(context, kind.wireName) ?? kind.wireName;
        return FilterChip(
          label: Text(label),
          selected: state.selectedKind == kind,
          onSelected: (_) => ref.read(directoryViewModelProvider.notifier).selectKind(kind),
        );
      }).toList(),
    );
  }

  Widget _buildActiveFilters(
    BuildContext context,
    WidgetRef ref,
    DirectoryUiState state,
  ) {
    return Wrap(
      spacing: 8,
      children: state.activeFilterChips.map((chip) => Chip(
            label: Text(chip),
            onDeleted: () => ref.read(directoryViewModelProvider.notifier).clearFilters(),
          )).toList(),
    );
  }

  Widget _buildItemList(
    BuildContext context,
    WidgetRef ref,
    DirectoryUiState state,
    AppLocalizations l10n,
  ) {
    // 首屏 loading
    if (state.isLoadingItems && state.items.isEmpty) {
      return const SliverFillRemaining(
        child: LoadingPlaceholder(),
      );
    }

    // 错误
    if (state.itemsError != null && state.items.isEmpty) {
      return SliverFillRemaining(
        child: ErrorRetryRow(
          message: state.itemsError!,
          onRetry: () => ref.read(directoryViewModelProvider.notifier).loadItems(),
        ),
      );
    }

    // 空状态
    if (state.items.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(message: l10n.commonEmpty),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Footer
          if (index == state.items.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.itemsAppendError != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ErrorRetryRow(
                  message: state.itemsAppendError!,
                  onRetry: () => ref.read(directoryViewModelProvider.notifier).retryLoadMore(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final item = state.items[index];
          final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListCard(
              onTap: () {
                widget.onDetailChanged?.call(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DirectoryDetailPage(
                      itemId: item.id?.isNotEmpty == true ? item.id : null,
                      sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
                      kind: item.kind,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),
                ).whenComplete(() => widget.onDetailChanged?.call(false));
              },
              image: SizedBox(
                width: 80,
                height: 80,
                child: imageUrl != null
                    ? ListImage(
                        imageUrl: imageUrl,
                        fallbackText: item.title ?? '',
                      )
                    : ImagePlaceholder(
                        text: item.title?.isNotEmpty == true
                            ? item.title!.substring(0, 1)
                            : '',
                      ),
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MetaChip(
                    text: localizedDirectoryKind(context, item.kind.wireName) ?? item.kind.wireName,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title ?? l10n.commonEmpty,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.summary != null && item.summary!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.summary!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (item.region != null && item.region!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.region!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        childCount: state.items.length + (state.isLoadingMore || state.itemsAppendError != null ? 1 : 0),
      ),
    );
  }

  // ==================== 统计 Tab ====================

  Widget _buildStatisticsTab(
    BuildContext context,
    WidgetRef ref,
    DirectoryUiState state,
    AppLocalizations l10n,
  ) {
    final stats = state.statisticsState;

    // Loading
    if (stats.isLoading && stats.overview == null) {
      return const LoadingPlaceholder();
    }

    // Error
    if (stats.error != null && stats.overview == null) {
      return ErrorRetryRow(
        message: stats.error!,
        onRetry: () => ref.read(directoryViewModelProvider.notifier).refreshStatistics(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.read(directoryViewModelProvider.notifier).refreshStatistics(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 总览
          if (stats.overview != null) ...[
            _buildOverviewCard(context, stats.overview!, state.selectedKind, l10n),
            const SizedBox(height: 16),
          ],

          // 年份分布
          if (stats.yearBreakdown != null) ...[
            _buildBreakdownCard(context, stats.yearBreakdown!, l10n.directoryStatisticsYearBreakdown, l10n),
            const SizedBox(height: 16),
          ],

          // 类别分布
          if (stats.categoryBreakdown != null) ...[
            _buildBreakdownCard(context, stats.categoryBreakdown!, l10n.directoryStatisticsCategoryBreakdown, l10n),
            const SizedBox(height: 16),
          ],

          // 地区排行
          if (stats.regionBreakdown != null) ...[
            _buildBreakdownCard(context, stats.regionBreakdown!, l10n.directoryStatisticsRegionBreakdown, l10n),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    DirectoryStatisticsOverviewDto overview,
    DirectoryItemKind kind,
    AppLocalizations l10n,
  ) {
    final kindLabel = localizedDirectoryKind(context, kind.wireName) ?? kind.wireName;
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.directoryStatisticsOverviewFormat(kindLabel),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.directoryStatisticsTotalItems(overview.total),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (overview.generatedAt != null && overview.generatedAt!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.directoryStatisticsGeneratedAt(
                overview.generatedAt!.length >= 10
                    ? overview.generatedAt!.substring(0, 10)
                    : overview.generatedAt!,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            l10n.directoryStatisticsDimensions(overview.dimensions.length),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(
    BuildContext context,
    DirectoryStatisticDimensionDto breakdown,
    String title,
    AppLocalizations l10n,
  ) {
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...breakdown.items.take(10).map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name ?? item.key ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '${item.value}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ==================== 筛选 BottomSheet ====================

class _DirectoryFilterSheet extends StatefulWidget {
  final String initialRegion;
  final String initialCategory;
  final String initialYear;
  final String initialListType;
  final void Function(String region, String category, String year, String listType) onApply;
  final VoidCallback onClear;
  final VoidCallback onDismiss;
  final AppLocalizations l10n;

  const _DirectoryFilterSheet({
    required this.initialRegion,
    required this.initialCategory,
    required this.initialYear,
    required this.initialListType,
    required this.onApply,
    required this.onClear,
    required this.onDismiss,
    required this.l10n,
  });

  @override
  State<_DirectoryFilterSheet> createState() => _DirectoryFilterSheetState();
}

class _DirectoryFilterSheetState extends State<_DirectoryFilterSheet> {
  late final TextEditingController _regionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _yearController;
  late final TextEditingController _listTypeController;

  @override
  void initState() {
    super.initState();
    _regionController = TextEditingController(text: widget.initialRegion);
    _categoryController = TextEditingController(text: widget.initialCategory);
    _yearController = TextEditingController(text: widget.initialYear);
    _listTypeController = TextEditingController(text: widget.initialListType);
    _yearController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _regionController.dispose();
    _categoryController.dispose();
    _yearController.removeListener(_onChanged);
    _yearController.dispose();
    _listTypeController.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {}); // 触发 UI 刷新以更新年份校验状态
  }

  bool get _isValidYear {
    final text = _yearController.text.trim();
    if (text.isEmpty) return true;
    if (text.length != 4) return false;
    return int.tryParse(text) != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.54),
        child: GestureDetector(
          onTap: () {}, // 阻止点击穿透
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.l10n.filterTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _regionController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.filterFieldRegion,
                      hintText: widget.l10n.filterPlaceholderRegion,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.filterFieldCategory,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _yearController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.filterFieldYear,
                      hintText: widget.l10n.filterPlaceholderYear,
                      errorText: _isValidYear
                          ? null
                          : widget.l10n.filterInvalidYear,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _listTypeController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.filterFieldListType,
                      hintText: widget.l10n.filterPlaceholderListType,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: widget.onClear,
                        child: Text(widget.l10n.filterClear),
                      ),
                      FilledButton(
                        onPressed: _isValidYear
                            ? () => widget.onApply(
                                  _regionController.text.trim(),
                                  _categoryController.text.trim(),
                                  _yearController.text.trim(),
                                  _listTypeController.text.trim(),
                                )
                            : null,
                        child: Text(widget.l10n.filterApply),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
