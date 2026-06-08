import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/utils/year_filter_parser.dart';

import 'inheritors_ui_state.dart';

/// 传承人列表 ViewModel
class InheritorsViewModel extends StateNotifier<InheritorsUiState> {
  final HeritageRepository _repository;

  /// 搜索防抖定时器
  Timer? _searchDebounceTimer;
  static const _searchDebounceMs = 350;

  /// 请求版本号，用于防止旧请求覆盖新请求
  int _requestVersion = 0;

  InheritorsViewModel(this._repository) : super(const InheritorsUiState()) {
    loadInheritors();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  /// 加载传承人列表
  Future<void> loadInheritors() async {
    final requestVersion = ++_requestVersion;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.inheritors(
        page: 1,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        region: state.regionFilter.isNotEmpty ? state.regionFilter : null,
        category: state.categoryFilter.isNotEmpty ? state.categoryFilter : null,
        year: _parseYear(state.yearFilter),
        gender: state.genderFilter.isNotEmpty ? state.genderFilter : null,
      );

      if (requestVersion != _requestVersion) return;

      state = state.copyWith(
        isLoading: false,
        inheritors: result.items,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      if (requestVersion != _requestVersion) return;

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 加载更多传承人
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    final requestVersion = _requestVersion;
    state = state.copyWith(isLoadingMore: true, appendError: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.inheritors(
        page: nextPage,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        region: state.regionFilter.isNotEmpty ? state.regionFilter : null,
        category: state.categoryFilter.isNotEmpty ? state.categoryFilter : null,
        year: _parseYear(state.yearFilter),
        gender: state.genderFilter.isNotEmpty ? state.genderFilter : null,
      );

      // 丢弃过期请求（筛选条件已变化）
      if (requestVersion != _requestVersion) return;

      state = state.copyWith(
        inheritors: [...state.inheritors, ...result.items],
        hasMore: result.hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      if (requestVersion != _requestVersion) return;

      state = state.copyWith(
        isLoadingMore: false,
        appendError: e.toString(),
      );
    }
  }

  /// 重试加载更多
  void retryLoadMore() {
    state = state.copyWith(appendError: null);
    loadMore();
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
    loadInheritors();
  }

  /// 应用筛选
  void applyFilters({
    String? region,
    String? category,
    String? year,
    String? gender,
  }) {
    state = state.copyWith(
      regionFilter: region ?? state.regionFilter,
      categoryFilter: category ?? state.categoryFilter,
      yearFilter: year ?? state.yearFilter,
      genderFilter: gender ?? state.genderFilter,
    );
    loadInheritors();
  }

  /// 清空筛选
  void clearFilters() {
    state = state.copyWith(
      searchKeywords: '',
      regionFilter: '',
      categoryFilter: '',
      yearFilter: '',
      genderFilter: '',
    );
    loadInheritors();
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
      case 'gender':
        state = state.copyWith(genderFilter: '');
        break;
    }
    loadInheritors();
  }

  /// 刷新
  Future<void> refresh() async {
    await loadInheritors();
  }

  /// 将字符串年份转换为 int
  int? _parseYear(String year) => YearFilterParser.parse(year);
}

/// 传承人列表 ViewModel Provider
final inheritorsViewModelProvider =
    StateNotifierProvider<InheritorsViewModel, InheritorsUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return InheritorsViewModel(repository);
});
