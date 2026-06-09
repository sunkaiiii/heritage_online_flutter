import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

import 'timeline_ui_state.dart';

/// 时间线页 ViewModel
class TimelineViewModel extends StateNotifier<TimelineUiState> {
  final HeritageRepository _repository;

  static const _pageSize = 20;

  /// 竞态保护：items 请求版本号
  int _itemsRequestVersion = 0;

  TimelineViewModel(this._repository) : super(const TimelineUiState()) {
    _loadYears();
  }

  /// 选择年份
  void selectYear(int year) {
    if (state.selectedYear == year) return;

    state = state.copyWith(
      selectedYear: year,
      isLoadingItems: true,
      items: [],
      page: 1,
      hasMore: false,
      facets: [],
      selectedTypes: {},
      clearItemsError: true,
      clearLoadMoreError: true,
    );

    _loadItems(reset: true);
  }

  /// 切换类型筛选（支持多选）
  void toggleType(SearchResultType type) {
    if (state.selectedYear == null) return;

    final newTypes = Set<SearchResultType>.from(state.selectedTypes);
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }

    state = state.copyWith(
      selectedTypes: newTypes,
      isLoadingItems: true,
      items: [],
      page: 1,
      hasMore: false,
      clearItemsError: true,
      clearLoadMoreError: true,
    );

    _loadItems(reset: true);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.selectedYear == null) return;

    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);

    try {
      final response = await _repository.timelineV2(
        year: state.selectedYear,
        types: state.selectedTypes.map((t) => t.wireName).toList(),
        page: nextPage,
        pageSize: _pageSize,
      );

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...response.items],
        page: nextPage,
        hasMore: response.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: e.toString(),
      );
    }
  }

  /// 清除错误
  void clearYearsError() {
    state = state.copyWith(clearYearsError: true);
  }

  /// 清除条目错误
  void clearItemsError() {
    state = state.copyWith(clearItemsError: true);
  }

  /// 重试加载年份
  void retryLoadYears() {
    state = state.copyWith(isLoadingYears: true, clearYearsError: true);
    _loadYears();
  }

  /// 重试加载条目
  void retryLoadItems() {
    if (state.selectedYear == null) return;
    state = state.copyWith(isLoadingItems: true, clearItemsError: true);
    _loadItems(reset: true);
  }

  // ==================== 内部方法 ====================

  /// 加载年份列表
  Future<void> _loadYears() async {
    try {
      final years = await _repository.timelineYears();
      state = state.copyWith(
        isLoadingYears: false,
        years: years,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingYears: false,
        yearsError: e.toString(),
      );
    }
  }

  /// 加载条目（带竞态保护）
  Future<void> _loadItems({required bool reset}) async {
    final version = ++_itemsRequestVersion;

    try {
      final response = await _repository.timelineV2(
        year: state.selectedYear,
        types: state.selectedTypes.map((t) => t.wireName).toList(),
        page: 1,
        pageSize: _pageSize,
      );

      // 竞态保护：忽略过时响应
      if (version != _itemsRequestVersion) return;

      // 提取 facets 中的 types
      final typeFacets = response.facets?.types ?? [];

      state = state.copyWith(
        isLoadingItems: false,
        items: response.items,
        page: 1,
        hasMore: response.hasMore,
        facets: typeFacets,
      );
    } catch (e) {
      // 竞态保护：忽略过时错误
      if (version != _itemsRequestVersion) return;

      state = state.copyWith(
        isLoadingItems: false,
        itemsError: e.toString(),
      );
    }
  }
}

/// 时间线页 ViewModel Provider
final timelineViewModelProvider =
    StateNotifierProvider.autoDispose<TimelineViewModel, TimelineUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return TimelineViewModel(repository);
});
