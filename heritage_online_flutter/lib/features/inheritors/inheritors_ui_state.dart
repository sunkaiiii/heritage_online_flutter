import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';

/// 传承人列表 UI 状态
class InheritorsUiState {
  final String searchKeywords;
  final String regionFilter;
  final String categoryFilter;
  final String yearFilter;
  final String genderFilter;
  final bool isLoading;
  final List<InheritorSummaryDto> inheritors;
  final String? error;
  final bool isLoadingMore;
  final String? appendError;
  final bool hasMore;
  final int currentPage;

  const InheritorsUiState({
    this.searchKeywords = '',
    this.regionFilter = '',
    this.categoryFilter = '',
    this.yearFilter = '',
    this.genderFilter = '',
    this.isLoading = true,
    this.inheritors = const [],
    this.error,
    this.isLoadingMore = false,
    this.appendError,
    this.hasMore = false,
    this.currentPage = 1,
  });

  InheritorsUiState copyWith({
    String? searchKeywords,
    String? regionFilter,
    String? categoryFilter,
    String? yearFilter,
    String? genderFilter,
    bool? isLoading,
    List<InheritorSummaryDto>? inheritors,
    String? error,
    bool? isLoadingMore,
    String? appendError,
    bool? hasMore,
    int? currentPage,
  }) {
    return InheritorsUiState(
      searchKeywords: searchKeywords ?? this.searchKeywords,
      regionFilter: regionFilter ?? this.regionFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      yearFilter: yearFilter ?? this.yearFilter,
      genderFilter: genderFilter ?? this.genderFilter,
      isLoading: isLoading ?? this.isLoading,
      inheritors: inheritors ?? this.inheritors,
      error: error,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      appendError: appendError,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  /// 活跃筛选数量
  int get activeFilterCount {
    return [regionFilter, categoryFilter, yearFilter, genderFilter]
        .where((f) => f.isNotEmpty)
        .length;
  }

  /// 是否有活跃筛选
  bool get hasActiveFilters => activeFilterCount > 0 || searchKeywords.isNotEmpty;

  /// 获取筛选 chips 列表
  List<String> get activeFilterChips {
    final chips = <String>[];
    if (searchKeywords.isNotEmpty) chips.add(searchKeywords);
    if (regionFilter.isNotEmpty) chips.add('地区: $regionFilter');
    if (categoryFilter.isNotEmpty) chips.add('类别: $categoryFilter');
    if (yearFilter.isNotEmpty) chips.add('年份: $yearFilter');
    if (genderFilter.isNotEmpty) chips.add('性别: $genderFilter');
    return chips;
  }
}
