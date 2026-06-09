import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/core/utils/year_filter_parser.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/features/search/search_ui_state.dart';
import 'package:heritage_online_flutter/features/search/search_view_model.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 全局搜索页
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// 筛选 sheet 中的年份输入控制器
  final TextEditingController _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _yearController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(searchViewModelProvider);
      if (state.hasMore && !state.isLoadingMore) {
        ref.read(searchViewModelProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(searchViewModelProvider);

    return Scaffold(
      appBar: _buildAppBar(context, ref, state, l10n),
      body: _buildBody(context, ref, state, l10n),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: l10n.searchPlaceholder,
          border: InputBorder.none,
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchViewModelProvider.notifier).updateQuery('');
                    setState(() {});
                  },
                )
              : null,
        ),
        onChanged: (value) {
          ref.read(searchViewModelProvider.notifier).updateQuery(value);
          setState(() {});
        },
        onSubmitted: (_) {
          ref.read(searchViewModelProvider.notifier).search();
        },
        textInputAction: TextInputAction.search,
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(searchViewModelProvider.notifier).search();
          },
          child: Text(l10n.searchLabel),
        ),
        // 筛选按钮
        IconButton(
          icon: Badge(
            isLabelVisible: state.hasActiveFilters,
            label: Text('${state.activeFilterCount}'),
            child: const Icon(Icons.filter_list),
          ),
          tooltip: l10n.searchFilter,
          onPressed: () => _showFilterSheet(context, ref, state, l10n),
        ),
      ],
    );
  }

  // ==================== 筛选 Bottom Sheet ====================

  void _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    _yearController.text = state.yearFilter?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.searchFilterTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(searchViewModelProvider.notifier)
                                .clearAllFilters();
                            Navigator.of(sheetContext).pop();
                          },
                          child: Text(l10n.searchFilterClearAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 地区筛选
                    SectionHeader(title: l10n.filterFieldRegion),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: l10n.filterPlaceholderRegion,
                        border: const OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                          text: state.regionFilter),
                      onSubmitted: (value) {
                        ref
                            .read(searchViewModelProvider.notifier)
                            .updateRegionFilter(value.trim().isEmpty ? null : value.trim());
                      },
                    ),
                    const SizedBox(height: 16),

                    // 类别筛选
                    SectionHeader(title: l10n.filterFieldCategory),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: l10n.filterFieldCategory,
                        border: const OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                          text: state.categoryFilter),
                      onSubmitted: (value) {
                        ref
                            .read(searchViewModelProvider.notifier)
                            .updateCategoryFilter(value.trim().isEmpty ? null : value.trim());
                      },
                    ),
                    const SizedBox(height: 16),

                    // 年份筛选
                    SectionHeader(title: l10n.filterFieldYear),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _yearController,
                      decoration: InputDecoration(
                        hintText: l10n.filterPlaceholderYear,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        final parsed =
                            YearFilterParser.parse(value.trim());
                        ref
                            .read(searchViewModelProvider.notifier)
                            .updateYearFilter(parsed);
                      },
                    ),
                    const SizedBox(height: 16),

                    // kind 筛选
                    SectionHeader(title: l10n.filterFieldKind),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: DirectoryItemKind.values.map((kind) {
                        final isSelected = state.kindFilter == kind;
                        return FilterChip(
                          label: Text(localizedDirectoryKind(
                              context, kind.wireName) ?? kind.wireName),
                          selected: isSelected,
                          onSelected: (_) {
                            ref
                                .read(searchViewModelProvider.notifier)
                                .updateKindFilter(isSelected ? null : kind);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // 有图筛选
                    SectionHeader(title: l10n.filterFieldHasImage),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: Text(l10n.filterHasImageYes),
                          selected: state.hasImageFilter == true,
                          onSelected: (_) {
                            final next = state.hasImageFilter == true
                                ? null
                                : true;
                            ref
                                .read(searchViewModelProvider.notifier)
                                .updateHasImageFilter(next);
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Text(l10n.filterHasImageNo),
                          selected: state.hasImageFilter == false,
                          onSelected: (_) {
                            final next = state.hasImageFilter == false
                                ? null
                                : false;
                            ref
                                .read(searchViewModelProvider.notifier)
                                .updateHasImageFilter(next);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 应用按钮
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                        },
                        child: Text(l10n.filterApply),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==================== Body ====================

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    // 显示 suggestions
    if (state.suggestions.isNotEmpty || state.isLoadingSuggestions) {
      return _buildSuggestions(context, ref, state, l10n);
    }

    // 搜索中
    if (state.isSearching) {
      return const LoadingPlaceholder();
    }

    // 错误
    if (state.error != null) {
      return ErrorRetryRow(
        message: state.error!,
        onRetry: () => ref.read(searchViewModelProvider.notifier).search(),
      );
    }

    // 有结果
    if (state.results.isNotEmpty) {
      return _buildResults(context, ref, state, l10n);
    }

    // 无搜索结果
    if (state.query.isNotEmpty) {
      return EmptyState(message: l10n.searchEmptyMessage);
    }

    // 初始状态
    return Center(
      child: Text(
        l10n.searchPlaceholder,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  // ==================== Suggestions ====================

  Widget _buildSuggestions(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        if (state.isLoadingSuggestions)
          const LinearProgressIndicator(),
        Expanded(
          child: ListView.builder(
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];
              return ListTile(
                leading: const Icon(Icons.search),
                title: Text(suggestion.text ?? ''),
                onTap: () {
                  _controller.text = suggestion.text ?? '';
                  ref.read(searchViewModelProvider.notifier)
                      .selectSuggestion(suggestion.text ?? '');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ==================== Results ====================

  Widget _buildResults(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        // 类型筛选 chips
        _buildTypeFilters(context, ref, state, l10n),

        // 结果数量 + 活跃筛选行
        _buildResultHeader(context, ref, state, l10n),

        // 结果列表
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount:
                state.results.length + (state.isLoadingMore ? 1 : 0) + (state.loadMoreError != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.results.length && state.loadMoreError != null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorRetryRow(
                    message: l10n.commonError,
                    onRetry: () =>
                        ref.read(searchViewModelProvider.notifier).loadMore(),
                  ),
                );
              }

              if (index >= state.results.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.results[index];
              return _buildResultItem(context, item, l10n);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultHeader(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 结果数量
          if (state.total > 0)
            Text(
              l10n.searchResultCount(state.total),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          // 活跃筛选 chips
          if (state.hasActiveFilters) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (state.selectedTypes.isNotEmpty)
                  _buildActiveFilterChip(
                    context,
                    ref,
                    label: state.selectedTypes
                        .map((t) => localizedContentType(context, t.wireName) ?? t.wireName)
                        .join('、'),
                    field: SearchFilterField.types,
                  ),
                if (state.regionFilter.isNotEmpty)
                  _buildActiveFilterChip(
                    context,
                    ref,
                    label: '${l10n.filterFieldRegion}: ${state.regionFilter}',
                    field: SearchFilterField.region,
                  ),
                if (state.categoryFilter.isNotEmpty)
                  _buildActiveFilterChip(
                    context,
                    ref,
                    label: '${l10n.filterFieldCategory}: ${state.categoryFilter}',
                    field: SearchFilterField.category,
                  ),
                if (state.yearFilter != null)
                  _buildActiveFilterChip(
                    context,
                    ref,
                    label: '${l10n.filterFieldYear}: ${state.yearFilter}',
                    field: SearchFilterField.year,
                  ),
                if (state.kindFilter != null)
                  _buildActiveFilterChip(
                    context,
                    ref,
                    label: '${l10n.filterFieldKind}: ${localizedDirectoryKind(context, state.kindFilter!.wireName)}',
                    field: SearchFilterField.kind,
                  ),
                if (state.hasImageFilter != null)
                  _buildActiveFilterChip(
                    context,
                    ref,
                    label: '${l10n.filterFieldHasImage}: ${state.hasImageFilter == true ? l10n.filterHasImageYes : l10n.filterHasImageNo}',
                    field: SearchFilterField.hasImage,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required SearchFilterField field,
  }) {
    return InputChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onDeleted: () {
        ref.read(searchViewModelProvider.notifier).clearFilter(field);
      },
    );
  }

  Widget _buildTypeFilters(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTypeChip(
            context,
            ref,
            state,
            SearchResultType.article,
            l10n.contentTypeArticle,
          ),
          const SizedBox(width: 8),
          _buildTypeChip(
            context,
            ref,
            state,
            SearchResultType.directoryItem,
            l10n.contentTypeDirectory,
          ),
          const SizedBox(width: 8),
          _buildTypeChip(
            context,
            ref,
            state,
            SearchResultType.inheritor,
            l10n.contentTypeInheritor,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    WidgetRef ref,
    SearchUiState state,
    SearchResultType type,
    String label,
  ) {
    final isSelected = state.selectedTypes.contains(type);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(searchViewModelProvider.notifier).toggleType(type);
      },
    );
  }

  // ==================== Result Item ====================

  Widget _buildResultItem(
    BuildContext context,
    SearchResultItemDto item,
    AppLocalizations l10n,
  ) {
    final type = item.type ?? '';
    final typeLabel = localizedContentType(context, type) ?? type;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListCard(
        onTap: () => _navigateToDetail(context, item),
        image: SizedBox(
          width: 60,
          height: 60,
          child: item.imageUrl != null && item.imageUrl!.isNotEmpty
              ? ListImage(
                  imageUrl: item.imageUrl!,
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
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: [
                MetaChip(text: typeLabel),
                if (item.category != null && item.category!.isNotEmpty)
                  MetaChip(
                    text: localizedArticleCategory(context, item.category!) ??
                        item.category!,
                  ),
                if (item.kind != null && item.kind!.isNotEmpty)
                  MetaChip(
                    text: localizedDirectoryKind(context, item.kind!) ??
                        item.kind!,
                  ),
                if (item.region != null && item.region!.isNotEmpty)
                  MetaChip(text: item.region!),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.title ?? l10n.commonEmpty,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.summary != null && item.summary!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                item.summary!,
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

  // ==================== Navigation ====================

  void _navigateToDetail(BuildContext context, SearchResultItemDto item) {
    final type = item.type ?? '';

    if (type == 'article') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ArticleDetailPage(
            articleId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId:
                item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl?.isNotEmpty == true
                ? item.sourceUrl
                : null,
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
          builder: (context) => DirectoryDetailPage(
            itemId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId:
                item.sourceId?.isNotEmpty == true ? item.sourceId : null,
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
          builder: (context) => InheritorDetailPage(
            inheritorId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId:
                item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }
}
