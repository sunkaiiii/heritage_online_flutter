import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/inheritors_ui_state.dart';
import 'package:heritage_online_flutter/features/inheritors/inheritors_view_model.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 传承人列表页
class InheritorsPage extends ConsumerStatefulWidget {
  final ValueChanged<bool>? onDetailChanged;

  const InheritorsPage({
    super.key,
    this.onDetailChanged,
  });

  @override
  ConsumerState<InheritorsPage> createState() => _InheritorsPageState();
}

class _InheritorsPageState extends ConsumerState<InheritorsPage> {
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
      final state = ref.read(inheritorsViewModelProvider);
      if (state.hasMore && !state.isLoadingMore && state.appendError == null) {
        ref.read(inheritorsViewModelProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(inheritorsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.inheritorsTitle),
            Text(
              l10n.inheritorsSubtitle,
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
                ref.read(inheritorsViewModelProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageBackground(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(inheritorsViewModelProvider.notifier).refresh(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 搜索框
                  _buildSearchSection(context, ref, state, l10n),

                  // 性别筛选
                  _buildGenderFilter(context, ref, state, l10n),

                  // 活跃筛选
                  if (state.hasActiveFilters)
                    _buildActiveFilters(context, ref, state, l10n),

                  // 传承人列表
                  _buildInheritorList(context, ref, state, l10n),
                ],
              ),
            ),
          ),
          // 筛选 BottomSheet
          if (_showFilterSheet)
            _InheritorFilterSheet(
              initialRegion: state.regionFilter,
              initialCategory: state.categoryFilter,
              initialYear: state.yearFilter,
              onApply: (region, category, year) {
                setState(() => _showFilterSheet = false);
                ref.read(inheritorsViewModelProvider.notifier).applyFilters(
                      region: region,
                      category: category,
                      year: year,
                    );
              },
              onClear: () {
                setState(() => _showFilterSheet = false);
                ref.read(inheritorsViewModelProvider.notifier).clearFilters();
              },
              onDismiss: () => setState(() => _showFilterSheet = false),
              l10n: l10n,
            ),
        ],
      ),
    );
  }

  // ==================== 搜索框 ====================

  Widget _buildSearchSection(
    BuildContext context,
    WidgetRef ref,
    InheritorsUiState state,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SearchField(
          value: state.searchKeywords,
          onChanged: (value) =>
              ref.read(inheritorsViewModelProvider.notifier).updateSearchKeywords(value),
          label: l10n.inheritorsSearchLabel,
          placeholder: l10n.inheritorsSearchPlaceholder,
          onSearch: (_) =>
              ref.read(inheritorsViewModelProvider.notifier).search(),
        ),
      ),
    );
  }

  // ==================== 性别筛选 ====================

  Widget _buildGenderFilter(
    BuildContext context,
    WidgetRef ref,
    InheritorsUiState state,
    AppLocalizations l10n,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: Text(l10n.filterGenderMale),
              selected: state.genderFilter == 'male',
              onSelected: (_) {
                final newGender = state.genderFilter == 'male' ? '' : 'male';
                ref.read(inheritorsViewModelProvider.notifier)
                    .applyFilters(gender: newGender);
              },
            ),
            FilterChip(
              label: Text(l10n.filterGenderFemale),
              selected: state.genderFilter == 'female',
              onSelected: (_) {
                final newGender = state.genderFilter == 'female' ? '' : 'female';
                ref.read(inheritorsViewModelProvider.notifier)
                    .applyFilters(gender: newGender);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 活跃筛选 ====================

  Widget _buildActiveFilters(
    BuildContext context,
    WidgetRef ref,
    InheritorsUiState state,
    AppLocalizations l10n,
  ) {
    final chips = <String>[];
    if (state.searchKeywords.isNotEmpty) chips.add(state.searchKeywords);
    if (state.regionFilter.isNotEmpty) chips.add('${l10n.filterFieldRegion}: ${state.regionFilter}');
    if (state.categoryFilter.isNotEmpty) chips.add('${l10n.filterFieldCategory}: ${state.categoryFilter}');
    if (state.yearFilter.isNotEmpty) chips.add('${l10n.filterFieldYear}: ${state.yearFilter}');
    if (state.genderFilter.isNotEmpty) {
      final genderLabel = state.genderFilter == 'male' ? l10n.filterGenderMale : l10n.filterGenderFemale;
      chips.add(genderLabel);
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Wrap(
          spacing: 8,
          children: chips.map((chip) => Chip(
                label: Text(chip),
                onDeleted: () =>
                    ref.read(inheritorsViewModelProvider.notifier).clearFilters(),
              )).toList(),
        ),
      ),
    );
  }

  // ==================== 传承人列表 ====================

  Widget _buildInheritorList(
    BuildContext context,
    WidgetRef ref,
    InheritorsUiState state,
    AppLocalizations l10n,
  ) {
    // 首屏 loading
    if (state.isLoading && state.inheritors.isEmpty) {
      return const SliverFillRemaining(
        child: LoadingPlaceholder(),
      );
    }

    // 错误
    if (state.error != null && state.inheritors.isEmpty) {
      return SliverFillRemaining(
        child: ErrorRetryRow(
          message: state.error!,
          onRetry: () =>
              ref.read(inheritorsViewModelProvider.notifier).loadInheritors(),
        ),
      );
    }

    // 空状态
    if (state.inheritors.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(message: l10n.inheritorsEmptyMessage),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Footer
          if (index == state.inheritors.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.appendError != null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ErrorRetryRow(
                  message: state.appendError!,
                  onRetry: () =>
                      ref.read(inheritorsViewModelProvider.notifier).retryLoadMore(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final inheritor = state.inheritors[index];
          final imageUrl = ImageUrlSelector.getListUrl(inheritor.coverImage);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListCard(
              onTap: () {
                widget.onDetailChanged?.call(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InheritorDetailPage(
                      inheritorId: inheritor.id?.isNotEmpty == true ? inheritor.id : null,
                      sourceId: inheritor.sourceId?.isNotEmpty == true ? inheritor.sourceId : null,
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
                        fallbackText: inheritor.name ?? '',
                      )
                    : ImagePlaceholder(
                        text: inheritor.name?.isNotEmpty == true
                            ? inheritor.name!.substring(0, 1)
                            : '',
                      ),
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inheritor.name ?? l10n.unnamedInheritor,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (inheritor.projectName != null &&
                      inheritor.projectName!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      inheritor.projectName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (inheritor.region != null &&
                      inheritor.region!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      inheritor.region!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                  if (inheritor.category != null &&
                      inheritor.category!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    MetaChip(text: inheritor.category!),
                  ],
                ],
              ),
            ),
          );
        },
        childCount: state.inheritors.length +
            (state.isLoadingMore || state.appendError != null ? 1 : 0),
      ),
    );
  }
}

// ==================== 筛选 BottomSheet ====================

class _InheritorFilterSheet extends StatefulWidget {
  final String initialRegion;
  final String initialCategory;
  final String initialYear;
  final void Function(String region, String category, String year) onApply;
  final VoidCallback onClear;
  final VoidCallback onDismiss;
  final AppLocalizations l10n;

  const _InheritorFilterSheet({
    required this.initialRegion,
    required this.initialCategory,
    required this.initialYear,
    required this.onApply,
    required this.onClear,
    required this.onDismiss,
    required this.l10n,
  });

  @override
  State<_InheritorFilterSheet> createState() => _InheritorFilterSheetState();
}

class _InheritorFilterSheetState extends State<_InheritorFilterSheet> {
  late final TextEditingController _regionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _regionController = TextEditingController(text: widget.initialRegion);
    _categoryController = TextEditingController(text: widget.initialCategory);
    _yearController = TextEditingController(text: widget.initialYear);
    _yearController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _regionController.dispose();
    _categoryController.dispose();
    _yearController.removeListener(_onChanged);
    _yearController.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

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
          onTap: () {},
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
                      errorText: _isValidYear ? null : widget.l10n.filterInvalidYear,
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
                        onPressed: _isValidYear
                            ? () => widget.onApply(
                                  _regionController.text.trim(),
                                  _categoryController.text.trim(),
                                  _yearController.text.trim(),
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
