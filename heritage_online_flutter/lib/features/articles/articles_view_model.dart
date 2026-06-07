import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'articles_ui_state.dart';

/// 文章列表 ViewModel
class ArticlesViewModel extends StateNotifier<ArticlesUiState> {
  final HeritageRepository _repository;

  /// 搜索防抖定时器
  Timer? _searchDebounceTimer;
  static const _searchDebounceMs = 350;

  ArticlesViewModel(this._repository) : super(const ArticlesUiState()) {
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

  /// 加载文章列表（首页或重新搜索）
  Future<void> loadArticles() async {
    state = state.copyWith(isLoadingArticles: true, articlesError: null);

    try {
      final result = await _repository.articles(
        category: state.selectedCategory.wireName,
        page: 1,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        year: _parseYear(state.yearFilter),
      );

      state = state.copyWith(
        isLoadingArticles: false,
        articles: result.items,
        hasMore: result.hasMore,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingArticles: false,
        articlesError: e.toString(),
      );
    }
  }

  /// 加载更多文章
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.articles(
        category: state.selectedCategory.wireName,
        page: nextPage,
        pageSize: 20,
        keywords: state.searchKeywords.isNotEmpty ? state.searchKeywords : null,
        year: _parseYear(state.yearFilter),
      );

      state = state.copyWith(
        articles: [...state.articles, ...result.items],
        hasMore: result.hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
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
  int? _parseYear(String year) {
    if (year.isEmpty) return null;
    return int.tryParse(year);
  }
}

/// 文章列表 ViewModel Provider
final articlesViewModelProvider =
    StateNotifierProvider<ArticlesViewModel, ArticlesUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return ArticlesViewModel(repository);
});
