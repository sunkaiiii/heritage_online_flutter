import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

import 'search_ui_state.dart';

/// 搜索页 ViewModel
class SearchViewModel extends StateNotifier<SearchUiState> {
  final HeritageRepository _repository;

  Timer? _suggestionDebounceTimer;
  static const _suggestionDebounceMs = 200;
  static const _pageSize = 20;

  /// 竞态保护：搜索请求版本号
  int _searchRequestVersion = 0;

  SearchViewModel(this._repository) : super(const SearchUiState());

  @override
  void dispose() {
    _suggestionDebounceTimer?.cancel();
    super.dispose();
  }

  /// 更新搜索关键词
  void updateQuery(String query) {
    state = state.copyWith(query: query);

    // 防抖加载 suggestions（不应被 results 是否为空限制）
    _suggestionDebounceTimer?.cancel();
    if (query.trim().isNotEmpty) {
      _suggestionDebounceTimer = Timer(
        const Duration(milliseconds: _suggestionDebounceMs),
        () => _loadSuggestions(query.trim()),
      );
    } else {
      state = state.copyWith(suggestions: []);
    }
  }

  /// 执行搜索
  void search() {
    final query = state.query.trim();
    if (query.isEmpty) return;

    _suggestionDebounceTimer?.cancel();

    final version = ++_searchRequestVersion;

    state = state.copyWith(
      isSearching: true,
      page: 1,
      results: [],
      suggestions: [],
      error: null,
    );

    _performSearch(query, page: 1, version: version);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.query.isEmpty) return;

    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true);

    try {
      final data = await _repository.searchV2(
        keywords: state.query.trim(),
        types: state.selectedTypes.map((t) => t.wireName).toList(),
        page: nextPage,
        pageSize: _pageSize,
        region: state.regionFilter.isNotEmpty ? state.regionFilter : null,
        category: state.categoryFilter.isNotEmpty ? state.categoryFilter : null,
        year: state.yearFilter,
        kind: state.kindFilter?.wireName,
        hasImage: state.hasImageFilter,
      );

      final items = _parseResults(data);
      final hasMore = (data['hasMore'] as bool?) ?? false;

      state = state.copyWith(
        isLoadingMore: false,
        results: [...state.results, ...items],
        page: nextPage,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: e.toString(),
      );
    }
  }

  /// 选择建议
  void selectSuggestion(String text) {
    state = state.copyWith(query: text, suggestions: []);
    search();
  }

  // ==================== 筛选操作 ====================

  /// 切换类型筛选
  void toggleType(SearchResultType type) {
    final newTypes = Set<SearchResultType>.from(state.selectedTypes);
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }
    state = state.copyWith(selectedTypes: newTypes);
    search();
  }

  /// 更新地区筛选
  void updateRegionFilter(String? region) {
    state = state.copyWith(regionFilter: region ?? '');
    search();
  }

  /// 更新类别筛选
  void updateCategoryFilter(String? category) {
    state = state.copyWith(categoryFilter: category ?? '');
    search();
  }

  /// 更新年份筛选
  void updateYearFilter(int? year) {
    state = state.copyWith(yearFilter: year);
    search();
  }

  /// 更新种类筛选
  void updateKindFilter(DirectoryItemKind? kind) {
    state = state.copyWith(kindFilter: kind);
    search();
  }

  /// 更新有图筛选
  void updateHasImageFilter(bool? hasImage) {
    state = state.copyWith(hasImageFilter: hasImage);
    search();
  }

  /// 清空单个筛选
  void clearFilter(SearchFilterField field) {
    switch (field) {
      case SearchFilterField.types:
        state = state.copyWith(selectedTypes: {});
      case SearchFilterField.region:
        state = state.copyWith(regionFilter: '');
      case SearchFilterField.category:
        state = state.copyWith(categoryFilter: '');
      case SearchFilterField.year:
        state = state.copyWith(yearFilter: null);
      case SearchFilterField.kind:
        state = state.copyWith(kindFilter: null);
      case SearchFilterField.hasImage:
        state = state.copyWith(hasImageFilter: null);
    }
    search();
  }

  /// 清空全部筛选
  void clearAllFilters() {
    state = state.copyWith(
      selectedTypes: {},
      regionFilter: '',
      categoryFilter: '',
      yearFilter: null,
      kindFilter: null,
      hasImageFilter: null,
    );
    search();
  }

  /// 清空错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  // ==================== 内部方法 ====================

  /// 加载搜索建议
  Future<void> _loadSuggestions(String prefix) async {
    state = state.copyWith(isLoadingSuggestions: true);

    try {
      final data = await _repository.searchSuggestions(prefix);
      final suggestions = data.map((e) {
        if (e is Map<String, dynamic>) {
          return SearchSuggestionDto(text: e['text']?.toString());
        }
        return SearchSuggestionDto(text: e?.toString());
      }).toList();

      state = state.copyWith(
        suggestions: suggestions,
        isLoadingSuggestions: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingSuggestions: false);
    }
  }

  /// 执行搜索（带版本号竞态保护）
  Future<void> _performSearch(String query, {required int page, required int version}) async {
    try {
      final data = await _repository.searchV2(
        keywords: query,
        types: state.selectedTypes.map((t) => t.wireName).toList(),
        page: page,
        pageSize: _pageSize,
        region: state.regionFilter.isNotEmpty ? state.regionFilter : null,
        category: state.categoryFilter.isNotEmpty ? state.categoryFilter : null,
        year: state.yearFilter,
        kind: state.kindFilter?.wireName,
        hasImage: state.hasImageFilter,
      );

      // 竞态保护：忽略过时响应
      if (version != _searchRequestVersion) return;

      final items = _parseResults(data);
      final hasMore = (data['hasMore'] as bool?) ?? false;
      final total = (data['total'] as int?) ?? 0;

      state = state.copyWith(
        isSearching: false,
        results: items,
        page: page,
        hasMore: hasMore,
        total: total,
      );
    } catch (e) {
      // 竞态保护：忽略过时错误
      if (version != _searchRequestVersion) return;

      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  /// 解析搜索结果
  List<SearchResultItemDto> _parseResults(dynamic data) {
    final items = (data['items'] as List?) ?? [];
    return items.map((item) {
      final map = item as Map<String, dynamic>;
      return SearchResultItemDto(
        id: map['id']?.toString(),
        type: map['type']?.toString(),
        title: map['title']?.toString(),
        summary: map['summary']?.toString(),
        category: map['category']?.toString(),
        kind: map['kind']?.toString(),
        region: map['region']?.toString(),
        sourceId: map['sourceId']?.toString(),
        sourceUrl: map['sourceUrl']?.toString(),
        imageUrl: map['imageUrl']?.toString(),
      );
    }).toList();
  }
}

/// 搜索筛选字段枚举，用于单个清除
enum SearchFilterField { types, region, category, year, kind, hasImage }

/// 搜索页 ViewModel Provider
final searchViewModelProvider =
    StateNotifierProvider.autoDispose<SearchViewModel, SearchUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return SearchViewModel(repository);
});
