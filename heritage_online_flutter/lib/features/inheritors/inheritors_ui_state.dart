import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';

/// 筛选字段类型
enum InheritorFilterField {
  search,
  region,
  category,
  year,
  gender,
}

/// 筛选 chip 数据
class InheritorFilterChipData {
  final InheritorFilterField field;
  final String value;

  const InheritorFilterChipData({required this.field, required this.value});
}

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

  /// 活跃筛选数量（包含搜索词）
  int get activeFilterCount {
    int count = searchKeywords.isNotEmpty ? 1 : 0;
    count += [regionFilter, categoryFilter, yearFilter, genderFilter]
        .where((f) => f.isNotEmpty)
        .length;
    return count;
  }

  /// 是否有活跃筛选
  bool get hasActiveFilters => activeFilterCount > 0 || searchKeywords.isNotEmpty;

  /// 获取筛选 chips 列表（typed）
  List<InheritorFilterChipData> get activeFilterChips {
    final chips = <InheritorFilterChipData>[];
    if (searchKeywords.isNotEmpty) {
      chips.add(InheritorFilterChipData(field: InheritorFilterField.search, value: searchKeywords));
    }
    if (regionFilter.isNotEmpty) {
      chips.add(InheritorFilterChipData(field: InheritorFilterField.region, value: regionFilter));
    }
    if (categoryFilter.isNotEmpty) {
      chips.add(InheritorFilterChipData(field: InheritorFilterField.category, value: categoryFilter));
    }
    if (yearFilter.isNotEmpty) {
      chips.add(InheritorFilterChipData(field: InheritorFilterField.year, value: yearFilter));
    }
    if (genderFilter.isNotEmpty) {
      chips.add(InheritorFilterChipData(field: InheritorFilterField.gender, value: genderFilter));
    }
    return chips;
  }
}
