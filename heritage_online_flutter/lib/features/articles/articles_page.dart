import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/articles_view_model.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

import 'articles_ui_state.dart';

/// 文章列表页
class ArticlesPage extends ConsumerStatefulWidget {
  final VoidCallback? onSettingsSelected;
  final ValueChanged<bool>? onDetailChanged;

  const ArticlesPage({
    super.key,
    this.onSettingsSelected,
    this.onDetailChanged,
  });

  @override
  ConsumerState<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends ConsumerState<ArticlesPage> {
  /// 是否显示年份筛选 sheet
  bool _showFilterSheet = false;

  /// 滚动控制器，用于检测分页触发
  final ScrollController _scrollController = ScrollController();

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

  /// 检测滚动位置，触发加载更多
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 距离底部 200px 时触发加载更多
      final state = ref.read(articlesViewModelProvider);
      if (state.hasMore && !state.isLoadingMore && state.articlesAppendError == null) {
        ref.read(articlesViewModelProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(articlesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.articlesHeaderTitle),
            Text(
              l10n.articlesHeaderSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          FilterButton(
            activeFilterCount: state.hasActiveFilters ? 1 : 0,
            tooltip: l10n.filterButton,
            onPressed: () =>
                setState(() => _showFilterSheet = true),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.actionRefresh,
            onPressed: () =>
                ref.read(articlesViewModelProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsTitle,
            onPressed: widget.onSettingsSelected,
          ),
        ],
      ),
      body: Stack(
        children: [
          PageBackground(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(articlesViewModelProvider.notifier).refresh(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Banner 区
                  _buildBannerSection(context, ref, state, l10n),

                  // 搜索框
                  _buildSearchSection(context, ref, state, l10n),

                  // 分类 chips
                  _buildCategoryChips(context, ref, state, l10n),

                  // "最新文章" 区块标题
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(title: l10n.articlesLatestTitle),
                    ),
                  ),

                  // 活跃筛选 chips
                  if (state.hasActiveFilters)
                    _buildActiveFilters(context, ref, state, l10n),

                  // 文章列表
                  _buildArticleList(context, ref, state, l10n),
                ],
              ),
            ),
          ),
          // 年份筛选 BottomSheet
          if (_showFilterSheet)
            _YearFilterSheet(
              initialYear: state.yearFilter,
              onApply: (year) {
                setState(() => _showFilterSheet = false);
                ref.read(articlesViewModelProvider.notifier).setYearFilter(year);
                ref.read(articlesViewModelProvider.notifier).applyFilters();
              },
              onClear: () {
                setState(() => _showFilterSheet = false);
                ref.read(articlesViewModelProvider.notifier).clearFilters();
              },
              onDismiss: () => setState(() => _showFilterSheet = false),
              l10n: l10n,
            ),
        ],
      ),
    );
  }

  // ==================== Banner ====================

  Widget _buildBannerSection(
    BuildContext context,
    WidgetRef ref,
    ArticlesUiState state,
    AppLocalizations l10n,
  ) {
    if (state.isLoadingBanners && state.banners.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 160,
          child: LoadingPlaceholder(),
        ),
      );
    }

    if (state.bannerError != null && state.banners.isEmpty) {
      return SliverToBoxAdapter(
        child: ErrorRetryRow(
          message: state.bannerError!,
          onRetry: () =>
              ref.read(articlesViewModelProvider.notifier).loadBanners(),
        ),
      );
    }

    if (state.banners.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 160,
        child: PageView.builder(
          itemCount: state.banners.length,
          itemBuilder: (context, index) {
            final banner = state.banners[index];
            final imageUrl = ImageUrlSelector.getListUrl(banner.bestImage);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListImage(
                  imageUrl: imageUrl,
                  fallbackText: l10n.articlesHeaderTitle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==================== 搜索框 ====================

  Widget _buildSearchSection(
    BuildContext context,
    WidgetRef ref,
    ArticlesUiState state,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SearchField(
          value: state.searchKeywords,
          onChanged: (value) =>
              ref.read(articlesViewModelProvider.notifier).updateSearchKeywords(value),
          label: l10n.articlesSearchLabel,
          placeholder: l10n.articlesSearchPlaceholder,
          onSearch: (_) =>
              ref.read(articlesViewModelProvider.notifier).search(),
        ),
      ),
    );
  }

  // ==================== 分类 Chips ====================

  Widget _buildCategoryChips(
    BuildContext context,
    WidgetRef ref,
    ArticlesUiState state,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: Text(l10n.categoryNews),
              selected: state.selectedCategory == ArticleCategory.news,
              onSelected: (_) => ref
                  .read(articlesViewModelProvider.notifier)
                  .selectCategory(ArticleCategory.news),
            ),
            FilterChip(
              label: Text(l10n.categoryForum),
              selected: state.selectedCategory == ArticleCategory.forum,
              onSelected: (_) => ref
                  .read(articlesViewModelProvider.notifier)
                  .selectCategory(ArticleCategory.forum),
            ),
            FilterChip(
              label: Text(l10n.categorySpecialTopic),
              selected: state.selectedCategory == ArticleCategory.specialTopic,
              onSelected: (_) => ref
                  .read(articlesViewModelProvider.notifier)
                  .selectCategory(ArticleCategory.specialTopic),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 活跃筛选 Chips ====================

  Widget _buildActiveFilters(
    BuildContext context,
    WidgetRef ref,
    ArticlesUiState state,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Wrap(
          spacing: 8,
          children: state.activeFilterChips.map((chip) => Chip(
                label: Text(chip),
                onDeleted: () =>
                    ref.read(articlesViewModelProvider.notifier).clearFilters(),
              )).toList(),
        ),
      ),
    );
  }

  // ==================== 文章列表 ====================

  Widget _buildArticleList(
    BuildContext context,
    WidgetRef ref,
    ArticlesUiState state,
    AppLocalizations l10n,
  ) {
    // 首屏 loading
    if (state.isLoadingArticles && state.articles.isEmpty) {
      return const SliverFillRemaining(
        child: LoadingPlaceholder(),
      );
    }

    // 错误
    if (state.articlesError != null && state.articles.isEmpty) {
      return SliverFillRemaining(
        child: ErrorRetryRow(
          message: state.articlesError!,
          onRetry: () =>
              ref.read(articlesViewModelProvider.notifier).loadArticles(),
        ),
      );
    }

    // 空状态
    if (state.articles.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(message: l10n.commonEmpty),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // 加载更多 footer
          if (index == state.articles.length) {
            // append loading
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            // append error
            if (state.articlesAppendError != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ErrorRetryRow(
                  message: state.articlesAppendError!,
                  onRetry: () =>
                      ref.read(articlesViewModelProvider.notifier).retryLoadMore(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final article = state.articles[index];
          final categoryLabel = localizedArticleCategory(
            context,
            article.category.wireName,
          );
          final imageUrl = ImageUrlSelector.getListUrl(article.coverImage);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListCard(
              onTap: () {
                widget.onDetailChanged?.call(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailPage(
                      articleId: article.id?.isNotEmpty == true ? article.id : null,
                      sourceId: article.sourceId?.isNotEmpty == true ? article.sourceId : null,
                      sourceUrl: article.sourceUrl?.isNotEmpty == true ? article.sourceUrl : null,
                      category: article.category,
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
                        fallbackText: article.title ?? '',
                      )
                    : ImagePlaceholder(
                        text: article.title?.isNotEmpty == true
                            ? article.title!.substring(0, 1)
                            : '',
                      ),
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (categoryLabel != null)
                    MetaChip(text: categoryLabel),
                  const SizedBox(height: 6),
                  Text(
                    article.title ?? l10n.commonEmpty,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.summary != null &&
                      article.summary!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      article.summary!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (article.publishedAt != null &&
                      article.publishedAt!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      article.publishedAt!,
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
        childCount: state.articles.length +
            (state.isLoadingMore || state.articlesAppendError != null ? 1 : 0),
      ),
    );
  }
}

// ==================== 年份筛选 BottomSheet ====================

class _YearFilterSheet extends StatefulWidget {
  final String initialYear;
  final ValueChanged<String> onApply;
  final VoidCallback onClear;
  final VoidCallback onDismiss;
  final AppLocalizations l10n;

  const _YearFilterSheet({
    required this.initialYear,
    required this.onApply,
    required this.onClear,
    required this.onDismiss,
    required this.l10n,
  });

  @override
  State<_YearFilterSheet> createState() => _YearFilterSheetState();
}

class _YearFilterSheetState extends State<_YearFilterSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialYear);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // 触发 UI 刷新以更新校验状态
  }

  bool get _isValidYear {
    final text = _controller.text.trim();
    if (text.isEmpty) return true; // 空年份允许，表示不限
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
                    controller: _controller,
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
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: widget.onClear,
                        child: Text(widget.l10n.filterClear),
                      ),
                      FilledButton(
                        onPressed:
                            _isValidYear
                                ? () =>
                                    widget.onApply(_controller.text.trim())
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
