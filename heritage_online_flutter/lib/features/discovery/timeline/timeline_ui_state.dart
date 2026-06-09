import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/timeline_dtos.dart';

/// 时间线页 UI 状态
class TimelineUiState {
  /// 年份列表是否加载中
  final bool isLoadingYears;

  /// 年份列表
  final List<TimelineYearBucketDto> years;

  /// 当前选中的年份
  final int? selectedYear;

  /// 内容列表是否加载中（切换年份/筛选时）
  final bool isLoadingItems;

  /// 时间线条目列表
  final List<TimelineItemDto> items;

  /// 当前页码
  final int page;

  /// 是否有更多数据
  final bool hasMore;

  /// Facets（类型筛选项）
  final List<FacetBucketDto> facets;

  /// 选中的类型筛选
  final Set<SearchResultType> selectedTypes;

  /// 是否正在加载更多
  final bool isLoadingMore;

  /// 年份加载错误
  final String? yearsError;

  /// 条目加载错误
  final String? itemsError;

  /// 加载更多错误
  final String? loadMoreError;

  const TimelineUiState({
    this.isLoadingYears = true,
    this.years = const [],
    this.selectedYear,
    this.isLoadingItems = false,
    this.items = const [],
    this.page = 1,
    this.hasMore = false,
    this.facets = const [],
    this.selectedTypes = const {},
    this.isLoadingMore = false,
    this.yearsError,
    this.itemsError,
    this.loadMoreError,
  });

  /// 是否需要用户先选择年份
  bool get needsYearSelection => selectedYear == null && !isLoadingItems;

  /// 是否有活跃的类型筛选
  bool get hasActiveTypeFilter => selectedTypes.isNotEmpty;

  TimelineUiState copyWith({
    bool? isLoadingYears,
    List<TimelineYearBucketDto>? years,
    int? selectedYear,
    bool clearSelectedYear = false,
    bool? isLoadingItems,
    List<TimelineItemDto>? items,
    int? page,
    bool? hasMore,
    List<FacetBucketDto>? facets,
    Set<SearchResultType>? selectedTypes,
    bool? isLoadingMore,
    String? yearsError,
    bool clearYearsError = false,
    String? itemsError,
    bool clearItemsError = false,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return TimelineUiState(
      isLoadingYears: isLoadingYears ?? this.isLoadingYears,
      years: years ?? this.years,
      selectedYear: clearSelectedYear ? null : (selectedYear ?? this.selectedYear),
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      facets: facets ?? this.facets,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      yearsError: clearYearsError ? null : (yearsError ?? this.yearsError),
      itemsError: clearItemsError ? null : (itemsError ?? this.itemsError),
      loadMoreError: clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}
