import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/utils/year_filter_parser.dart';

import 'directory_ui_state.dart';

/// 名录列表 ViewModel
class DirectoryViewModel extends StateNotifier<DirectoryUiState> {
  final HeritageRepository _repository;

  /// 搜索防抖定时器
  Timer? _searchDebounceTimer;
  static const _searchDebounceMs = 350;

  /// 请求版本号，用于防止旧请求覆盖新请求
  int _itemsRequestVersion = 0;

  /// 统计请求版本号
  int _statisticsRequestVersion = 0;

  DirectoryViewModel(this._repository) : super(const DirectoryUiState()) {
    loadItems();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  /// 加载名录列表
  Future<void> loadItems() async {
    final requestVersion = ++_itemsRequestVersion;
    state = state.copyWith(isLoadingItems: true, itemsError: null);

    try {
      final result = await _repository.directoryItems(
        kind: state.selectedKind.wireName,
        page: 1,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        region: state.regionFilter.isNotEmpty ? state.regionFilter : null,
        category: state.categoryFilter.isNotEmpty ? state.categoryFilter : null,
        year: _parseYear(state.yearFilter),
        listType: state.listTypeFilter.isNotEmpty ? state.listTypeFilter : null,
      );

      if (requestVersion != _itemsRequestVersion) return;

      state = state.copyWith(
        isLoadingItems: false,
        items: result.items,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      if (requestVersion != _itemsRequestVersion) return;

      state = state.copyWith(
        isLoadingItems: false,
        itemsError: e.toString(),
      );
    }
  }

  /// 加载更多名录
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    final requestVersion = _itemsRequestVersion;
    state = state.copyWith(isLoadingMore: true, itemsAppendError: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.directoryItems(
        kind: state.selectedKind.wireName,
        page: nextPage,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        region: state.regionFilter.isNotEmpty ? state.regionFilter : null,
        category: state.categoryFilter.isNotEmpty ? state.categoryFilter : null,
        year: _parseYear(state.yearFilter),
        listType: state.listTypeFilter.isNotEmpty ? state.listTypeFilter : null,
      );

      // 丢弃过期请求（筛选条件已变化）
      if (requestVersion != _itemsRequestVersion) return;

      state = state.copyWith(
        items: [...state.items, ...result.items],
        hasMore: result.hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      if (requestVersion != _itemsRequestVersion) return;

      state = state.copyWith(
        isLoadingMore: false,
        itemsAppendError: e.toString(),
      );
    }
  }

  /// 重试加载更多
  void retryLoadMore() {
    state = state.copyWith(itemsAppendError: null);
    loadMore();
  }

  /// 选择名录种类
  void selectKind(DirectoryItemKind kind) {
    if (state.selectedKind == kind) return;
    // 切换 kind 时清空统计，避免显示旧 kind 的数据
    state = state.copyWith(
      selectedKind: kind,
      statisticsState: const DirectoryStatisticsState(),
    );
    loadItems();
    if (state.selectedTab == DirectoryTab.statistics) {
      loadStatistics();
    }
  }

  /// 选择 Tab
  void selectTab(DirectoryTab tab) {
    state = state.copyWith(selectedTab: tab);
    // 切到统计 tab 时，如果数据为空或 kind 不匹配，重新加载
    if (tab == DirectoryTab.statistics &&
        (state.statisticsState.overview == null ||
         state.statisticsState.loadedKind != state.selectedKind)) {
      loadStatistics();
    }
  }

  /// 更新搜索关键词（带防抖）
  void updateSearchKeywords(String keywords) {
    state = state.copyWith(searchKeywords: keywords);
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      const Duration(milliseconds: _searchDebounceMs),
      () => search(),
    );
  }

  /// 执行搜索
  void search() {
    loadItems();
  }

  /// 应用筛选
  void applyFilters({
    String? region,
    String? category,
    String? year,
    String? listType,
  }) {
    state = state.copyWith(
      regionFilter: region ?? state.regionFilter,
      categoryFilter: category ?? state.categoryFilter,
      yearFilter: year ?? state.yearFilter,
      listTypeFilter: listType ?? state.listTypeFilter,
    );
    loadItems();
  }

  /// 清空筛选
  void clearFilters() {
    state = state.copyWith(
      searchKeywords: '',
      regionFilter: '',
      categoryFilter: '',
      yearFilter: '',
      listTypeFilter: '',
    );
    loadItems();
  }

  /// 清空单个筛选字段
  void clearFilterField(String field) {
    switch (field) {
      case 'region':
        state = state.copyWith(regionFilter: '');
        break;
      case 'category':
        state = state.copyWith(categoryFilter: '');
        break;
      case 'year':
        state = state.copyWith(yearFilter: '');
        break;
      case 'listType':
        state = state.copyWith(listTypeFilter: '');
        break;
    }
    loadItems();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadItems();
  }

  /// 加载统计数据
  Future<void> loadStatistics() async {
    final requestVersion = ++_statisticsRequestVersion;
    final kind = state.selectedKind;

    state = state.copyWith(
      statisticsState: state.statisticsState.copyWith(isLoading: true, error: null),
    );

    try {
      // 并行加载统计数据
      final overviewFuture = _repository.directoryStatisticsOverview(kind: kind);
      final yearFuture = _repository.directoryStatisticsBreakdown(
        kind: kind,
        dimension: DirectoryStatisticDimension.publishedYear,
        limit: 50,
      );
      final categoryFuture = _repository.directoryStatisticsBreakdown(
        kind: kind,
        dimension: DirectoryStatisticDimension.category,
        limit: 12,
      );
      final regionFuture = _repository.directoryStatisticsBreakdown(
        kind: kind,
        dimension: DirectoryStatisticDimension.region,
        limit: 20,
      );

      final overview = await overviewFuture;
      final year = await yearFuture;
      final category = await categoryFuture;
      final region = await regionFuture;

      // 丢弃过期请求或 kind 已变化的结果
      if (requestVersion != _statisticsRequestVersion) return;
      if (state.selectedKind != kind) return;

      state = state.copyWith(
        statisticsState: DirectoryStatisticsState(
          isLoading: false,
          loadedKind: kind,
          overview: overview,
          yearBreakdown: year,
          categoryBreakdown: category,
          regionBreakdown: region,
        ),
      );
    } catch (e) {
      if (requestVersion != _statisticsRequestVersion) return;

      state = state.copyWith(
        statisticsState: state.statisticsState.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  /// 刷新统计
  void refreshStatistics() {
    loadStatistics();
  }

  /// 将字符串年份转换为 int
  int? _parseYear(String year) => YearFilterParser.parse(year);
}

/// 名录列表 ViewModel Provider
final directoryViewModelProvider =
    StateNotifierProvider<DirectoryViewModel, DirectoryUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return DirectoryViewModel(repository);
});
