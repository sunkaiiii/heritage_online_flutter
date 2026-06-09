import 'package:heritage_online_flutter/core/network/dto/enums.dart';

/// 搜索 Facets
class SearchFacetsDto {
  final List<FacetBucketDto> types;
  final List<FacetBucketDto> categories;
  final List<FacetBucketDto> regions;
  final List<FacetBucketDto> kinds;
  final List<FacetBucketDto> years;

  const SearchFacetsDto({
    this.types = const [],
    this.categories = const [],
    this.regions = const [],
    this.kinds = const [],
    this.years = const [],
  });
}

/// Facet Bucket
class FacetBucketDto {
  final String? key;
  final int count;

  const FacetBucketDto({this.key, this.count = 0});
}

/// 搜索结果项
class SearchResultItemDto {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? category;
  final String? kind;
  final String? region;
  final String? sourceId;
  final String? sourceUrl;
  final String? imageUrl;

  const SearchResultItemDto({
    this.id,
    this.type,
    this.title,
    this.summary,
    this.category,
    this.kind,
    this.region,
    this.sourceId,
    this.sourceUrl,
    this.imageUrl,
  });
}

/// 搜索建议
class SearchSuggestionDto {
  final String? text;

  const SearchSuggestionDto({this.text});
}

/// 搜索页 UI 状态
class SearchUiState {
  final String query;
  final bool isSearching;
  final List<SearchResultItemDto> results;
  final int page;
  final bool hasMore;
  final int total;
  final SearchFacetsDto? facets;
  final Set<SearchResultType> selectedTypes;
  final String regionFilter;
  final String categoryFilter;
  final int? yearFilter;
  final DirectoryItemKind? kindFilter;
  final bool? hasImageFilter;
  final List<SearchSuggestionDto> suggestions;
  final bool isLoadingSuggestions;
  final bool isLoadingMore;
  final String? error;
  final String? loadMoreError;

  const SearchUiState({
    this.query = '',
    this.isSearching = false,
    this.results = const [],
    this.page = 1,
    this.hasMore = false,
    this.total = 0,
    this.facets,
    this.selectedTypes = const {},
    this.regionFilter = '',
    this.categoryFilter = '',
    this.yearFilter,
    this.kindFilter,
    this.hasImageFilter,
    this.suggestions = const [],
    this.isLoadingSuggestions = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
  });

  bool get hasActiveFilters =>
      selectedTypes.isNotEmpty ||
      regionFilter.isNotEmpty ||
      categoryFilter.isNotEmpty ||
      yearFilter != null ||
      kindFilter != null ||
      hasImageFilter != null;

  int get activeFilterCount {
    int count = 0;
    if (selectedTypes.isNotEmpty) count++;
    if (regionFilter.isNotEmpty) count++;
    if (categoryFilter.isNotEmpty) count++;
    if (yearFilter != null) count++;
    if (kindFilter != null) count++;
    if (hasImageFilter != null) count++;
    return count;
  }

  SearchUiState copyWith({
    String? query,
    bool? isSearching,
    List<SearchResultItemDto>? results,
    int? page,
    bool? hasMore,
    int? total,
    SearchFacetsDto? facets,
    Set<SearchResultType>? selectedTypes,
    String? regionFilter,
    String? categoryFilter,
    int? yearFilter,
    DirectoryItemKind? kindFilter,
    bool? hasImageFilter,
    List<SearchSuggestionDto>? suggestions,
    bool? isLoadingSuggestions,
    bool? isLoadingMore,
    String? error,
    String? loadMoreError,
  }) {
    return SearchUiState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
      facets: facets ?? this.facets,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      regionFilter: regionFilter ?? this.regionFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      yearFilter: yearFilter ?? this.yearFilter,
      kindFilter: kindFilter ?? this.kindFilter,
      hasImageFilter: hasImageFilter ?? this.hasImageFilter,
      suggestions: suggestions ?? this.suggestions,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      loadMoreError: loadMoreError,
    );
  }
}
