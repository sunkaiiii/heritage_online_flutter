import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/cache/list_cache_provider.dart';
import 'package:heritage_online_flutter/core/cache/list_cache_repository.dart';
import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/utils/year_filter_parser.dart';

import 'articles_ui_state.dart';

/// 文章列表 ViewModel
class ArticlesViewModel extends StateNotifier<ArticlesUiState> {
  final HeritageRepository _repository;
  final ListCacheRepository _listCache;

  /// 搜索防抖定时器
  Timer? _searchDebounceTimer;
  static const _searchDebounceMs = 350;

  /// 请求版本号，用于防止旧请求覆盖新请求
  int _articlesRequestVersion = 0;

  ArticlesViewModel({
    required HeritageRepository repository,
    required ListCacheRepository listCache,
  })  : _repository = repository, // ignore: prefer_initializing_formals
        _listCache = listCache, // ignore: prefer_initializing_formals
        super(const ArticlesUiState()) {
    loadBanners();
    loadArticles();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  /// 加载 Banner
  Future<void> loadBanners() async {
    state = state.copyWith(isLoadingBanners: true, bannerError: null);

    try {
      final banners = await _repository.homeBanners();
      state = state.copyWith(
        isLoadingBanners: false,
        banners: banners,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingBanners: false,
        bannerError: e.toString(),
      );
    }
  }

  /// 加载文章列表（缓存优先，首页或重新搜索）
  Future<void> loadArticles() async {
    final requestVersion = ++_articlesRequestVersion;
    state = state.copyWith(isLoadingArticles: true, articlesError: null);

    // 构建 queryKey
    final queryKey = QueryKeyBuilder.articles(
      category: state.selectedCategory.wireName,
      keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
      year: _parseYear(state.yearFilter),
    );

    // 1. 尝试从缓存加载
    final cached = _listCache.getArticleCache(queryKey);
    if (cached != null && requestVersion == _articlesRequestVersion) {
      final items = cached.items
          .map((json) => ArticleSummaryDto.fromJson(json))
          .toList();
      state = state.copyWith(
        isLoadingArticles: false,
        articles: items,
        hasMore: cached.hasMore,
        currentPage: cached.currentPage,
      );
    }

    // 2. 从网络刷新
    try {
      final result = await _repository.articles(
        category: state.selectedCategory.wireName,
        page: 1,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        year: _parseYear(state.yearFilter),
      );

      // 丢弃过期请求的结果
      if (requestVersion != _articlesRequestVersion) return;

      state = state.copyWith(
        isLoadingArticles: false,
        articles: result.items,
        hasMore: result.hasMore,
        currentPage: 1,
        articlesError: null,
      );

      // 3. 更新缓存
      _listCache.saveArticleCache(
        queryKey,
        ListCacheEntry(
          items: result.items.map((e) => e.toJson()).toList(),
          hasMore: result.hasMore,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // 丢弃过期请求的错误
      if (requestVersion != _articlesRequestVersion) return;

      // 4. 网络失败：如果有缓存则保留，否则显示错误
      if (state.articles.isNotEmpty) {
        state = state.copyWith(isLoadingArticles: false);
      } else {
        state = state.copyWith(
          isLoadingArticles: false,
          articlesError: e.toString(),
        );
      }
    }
  }

  /// 加载更多文章
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    final requestVersion = _articlesRequestVersion;
    state = state.copyWith(isLoadingMore: true, articlesAppendError: null);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.articles(
        category: state.selectedCategory.wireName,
        page: nextPage,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        year: _parseYear(state.yearFilter),
      );

      // 丢弃过期请求（筛选条件已变化）
      if (requestVersion != _articlesRequestVersion) return;

      final allItems = [...state.articles, ...result.items];

      state = state.copyWith(
        articles: allItems,
        hasMore: result.hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
      );

      // 追加到缓存
      final queryKey = QueryKeyBuilder.articles(
        category: state.selectedCategory.wireName,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        year: _parseYear(state.yearFilter),
      );
      _listCache.appendArticleCache(
        queryKey,
        ListCacheEntry(
          items: result.items.map((e) => e.toJson()).toList(),
          hasMore: result.hasMore,
          currentPage: nextPage,
          cachedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // append 失败不清空已有列表，但标记 append error
      state = state.copyWith(
        isLoadingMore: false,
        articlesAppendError: e.toString(),
      );
    }
  }

  /// 重试加载更多（从 append error 恢复）
  void retryLoadMore() {
    state = state.copyWith(articlesAppendError: null);
    loadMore();
  }

  /// 选择分类
  void selectCategory(ArticleCategory category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    loadArticles();
  }

  /// 更新搜索关键词（带防抖）
  void updateSearchKeywords(String keywords) {
    state = state.copyWith(searchKeywords: keywords);
    // 防抖 350ms 后自动搜索
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(
      const Duration(milliseconds: _searchDebounceMs),
      () => search(),
    );
  }

  /// 执行搜索
  void search() {
    loadArticles();
  }

  /// 设置年份筛选
  void setYearFilter(String year) {
    state = state.copyWith(yearFilter: year);
  }

  /// 应用筛选
  void applyFilters() {
    loadArticles();
  }

  /// 清空筛选
  void clearFilters() {
    state = state.copyWith(searchKeywords: '', yearFilter: '');
    loadArticles();
  }

  /// 刷新
  Future<void> refresh() async {
    await Future.wait([
      loadBanners(),
      loadArticles(),
    ]);
  }

  /// 将字符串年份转换为 int
  int? _parseYear(String year) => YearFilterParser.parse(year);
}

/// 文章列表 ViewModel Provider
final articlesViewModelProvider =
    StateNotifierProvider<ArticlesViewModel, ArticlesUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  final listCache = ref.watch(listCacheRepositoryProvider);
  return ArticlesViewModel(repository: repository, listCache: listCache);
});
