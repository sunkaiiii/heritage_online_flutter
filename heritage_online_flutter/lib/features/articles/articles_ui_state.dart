import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

/// 文章列表 UI 状态
class ArticlesUiState {
  final ArticleCategory selectedCategory;
  final String searchKeywords;
  final String yearFilter;
  final bool isLoadingBanners;
  final List<HomeBannerDto> banners;
  final String? bannerError;
  final bool isLoadingArticles;
  final List<ArticleSummaryDto> articles;
  final String? articlesError;
  final bool isLoadingMore;
  final String? articlesAppendError;
  final bool hasMore;
  final int currentPage;

  const ArticlesUiState({
    this.selectedCategory = ArticleCategory.news,
    this.searchKeywords = '',
    this.yearFilter = '',
    this.isLoadingBanners = true,
    this.banners = const [],
    this.bannerError,
    this.isLoadingArticles = true,
    this.articles = const [],
    this.articlesError,
    this.isLoadingMore = false,
    this.articlesAppendError,
    this.hasMore = false,
    this.currentPage = 1,
  });

  ArticlesUiState copyWith({
    ArticleCategory? selectedCategory,
    String? searchKeywords,
    String? yearFilter,
    bool? isLoadingBanners,
    List<HomeBannerDto>? banners,
    String? bannerError,
    bool? isLoadingArticles,
    List<ArticleSummaryDto>? articles,
    String? articlesError,
    bool? isLoadingMore,
    String? articlesAppendError,
    bool? hasMore,
    int? currentPage,
  }) {
    return ArticlesUiState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      yearFilter: yearFilter ?? this.yearFilter,
      isLoadingBanners: isLoadingBanners ?? this.isLoadingBanners,
      banners: banners ?? this.banners,
      bannerError: bannerError,
      isLoadingArticles: isLoadingArticles ?? this.isLoadingArticles,
      articles: articles ?? this.articles,
      articlesError: articlesError,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      articlesAppendError: articlesAppendError,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  /// 是否有活跃的筛选
  bool get hasActiveFilters =>
      searchKeywords.isNotEmpty || yearFilter.isNotEmpty;

  /// 获取筛选 chips 列表
  List<String> get activeFilterChips {
    final chips = <String>[];
    if (searchKeywords.isNotEmpty) chips.add(searchKeywords);
    // Note: yearFilter label is localized in the page, here we store raw data
    if (yearFilter.isNotEmpty) chips.add(yearFilter);
    return chips;
  }
}
