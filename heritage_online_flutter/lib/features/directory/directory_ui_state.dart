import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

/// 名录 Tab 类型
enum DirectoryTab {
  list,
  statistics,
}

/// 筛选字段类型
enum DirectoryFilterField {
  search,
  region,
  category,
  year,
  listType,
}

/// 筛选 chip 数据
class FilterChipData {
  final DirectoryFilterField field;
  final String value;

  const FilterChipData({required this.field, required this.value});
}

/// 名录统计状态
class DirectoryStatisticsState {
  final bool isLoading;
  final DirectoryItemKind? loadedKind;
  final DirectoryStatisticsOverviewDto? overview;
  final DirectoryStatisticDimensionDto? yearBreakdown;
  final DirectoryStatisticDimensionDto? categoryBreakdown;
  final DirectoryStatisticDimensionDto? regionBreakdown;
  final String? error;

  const DirectoryStatisticsState({
    this.isLoading = false,
    this.loadedKind,
    this.overview,
    this.yearBreakdown,
    this.categoryBreakdown,
    this.regionBreakdown,
    this.error,
  });

  DirectoryStatisticsState copyWith({
    bool? isLoading,
    DirectoryItemKind? loadedKind,
    DirectoryStatisticsOverviewDto? overview,
    DirectoryStatisticDimensionDto? yearBreakdown,
    DirectoryStatisticDimensionDto? categoryBreakdown,
    DirectoryStatisticDimensionDto? regionBreakdown,
    String? error,
  }) {
    return DirectoryStatisticsState(
      isLoading: isLoading ?? this.isLoading,
      loadedKind: loadedKind ?? this.loadedKind,
      overview: overview ?? this.overview,
      yearBreakdown: yearBreakdown ?? this.yearBreakdown,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      regionBreakdown: regionBreakdown ?? this.regionBreakdown,
      error: error,
    );
  }
}

/// 名录列表 UI 状态
class DirectoryUiState {
  final DirectoryItemKind selectedKind;
  final String searchKeywords;
  final String regionFilter;
  final String categoryFilter;
  final String yearFilter;
  final String listTypeFilter;
  final DirectoryTab selectedTab;
  final DirectoryStatisticsState statisticsState;
  final bool isLoadingItems;
  final List<DirectoryItemSummaryDto> items;
  final String? itemsError;
  final bool isLoadingMore;
  final String? itemsAppendError;
  final bool hasMore;
  final int currentPage;

  const DirectoryUiState({
    this.selectedKind = DirectoryItemKind.nationalProject,
    this.searchKeywords = '',
    this.regionFilter = '',
    this.categoryFilter = '',
    this.yearFilter = '',
    this.listTypeFilter = '',
    this.selectedTab = DirectoryTab.list,
    this.statisticsState = const DirectoryStatisticsState(),
    this.isLoadingItems = true,
    this.items = const [],
    this.itemsError,
    this.isLoadingMore = false,
    this.itemsAppendError,
    this.hasMore = false,
    this.currentPage = 1,
  });

  DirectoryUiState copyWith({
    DirectoryItemKind? selectedKind,
    String? searchKeywords,
    String? regionFilter,
    String? categoryFilter,
    String? yearFilter,
    String? listTypeFilter,
    DirectoryTab? selectedTab,
    DirectoryStatisticsState? statisticsState,
    bool? isLoadingItems,
    List<DirectoryItemSummaryDto>? items,
    String? itemsError,
    bool? isLoadingMore,
    String? itemsAppendError,
    bool? hasMore,
    int? currentPage,
  }) {
    return DirectoryUiState(
      selectedKind: selectedKind ?? this.selectedKind,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      regionFilter: regionFilter ?? this.regionFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      yearFilter: yearFilter ?? this.yearFilter,
      listTypeFilter: listTypeFilter ?? this.listTypeFilter,
      selectedTab: selectedTab ?? this.selectedTab,
      statisticsState: statisticsState ?? this.statisticsState,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
      items: items ?? this.items,
      itemsError: itemsError,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      itemsAppendError: itemsAppendError,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  /// 活跃筛选数量（包含搜索词）
  int get activeFilterCount {
    int count = searchKeywords.isNotEmpty ? 1 : 0;
    count += [regionFilter, categoryFilter, yearFilter, listTypeFilter]
        .where((f) => f.isNotEmpty)
        .length;
    return count;
  }

  /// 是否有活跃筛选
  bool get hasActiveFilters => activeFilterCount > 0 || searchKeywords.isNotEmpty;

  /// 获取筛选 chips 列表（typed）
  List<FilterChipData> get activeFilterChips {
    final chips = <FilterChipData>[];
    if (searchKeywords.isNotEmpty) {
      chips.add(FilterChipData(field: DirectoryFilterField.search, value: searchKeywords));
    }
    if (regionFilter.isNotEmpty) {
      chips.add(FilterChipData(field: DirectoryFilterField.region, value: regionFilter));
    }
    if (categoryFilter.isNotEmpty) {
      chips.add(FilterChipData(field: DirectoryFilterField.category, value: categoryFilter));
    }
    if (yearFilter.isNotEmpty) {
      chips.add(FilterChipData(field: DirectoryFilterField.year, value: yearFilter));
    }
    if (listTypeFilter.isNotEmpty) {
      chips.add(FilterChipData(field: DirectoryFilterField.listType, value: listTypeFilter));
    }
    return chips;
  }
}
