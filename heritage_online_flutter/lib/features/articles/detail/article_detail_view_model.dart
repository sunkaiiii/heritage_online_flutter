// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/cache/detail_cache_repository.dart';
import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/saved/saved.dart';
import 'package:heritage_online_flutter/core/cache/detail_cache_provider.dart';

import 'article_detail_ui_state.dart';

/// 文章详情 ViewModel
class ArticleDetailViewModel extends StateNotifier<ArticleDetailUiState> {
  final HeritageRepository _repository;
  final SavedContentNotifier _savedNotifier;
  final DetailCacheRepository _cacheRepository;
  final String? articleId;
  final String? sourceId;
  final String? sourceUrl;
  final ArticleCategory category;

  ArticleDetailViewModel({
    required HeritageRepository repository,
    required SavedContentNotifier savedNotifier,
    required DetailCacheRepository cacheRepository,
    this.articleId,
    this.sourceId,
    this.sourceUrl,
    this.category = ArticleCategory.news,
  })  : _repository = repository,
        _savedNotifier = savedNotifier,
        _cacheRepository = cacheRepository,
        super(const ArticleDetailUiState()) {
    loadArticle();
  }

  /// 加载文章详情（缓存优先）
  Future<void> loadArticle() async {
    state = state.copyWith(isLoading: true, error: null, isStale: false);

    final lookup = ArticleDetailLookup(
      articleId: articleId,
      sourceId: sourceId,
      sourceUrl: sourceUrl,
      category: category,
    );

    // 1. 尝试从缓存加载（alias-aware）
    final cached = _cacheRepository.getArticleCacheWithFallback(
      articleId: articleId, sourceId: sourceId, sourceUrl: sourceUrl, category: category.wireName,
    );
    if (cached != null) {
      try {
        final article = ArticleDetailDto.fromJson(cached);
        final isFavorite = _checkIsFavorite(article);
        final isStale = _cacheRepository.isArticleStale(
          articleId: articleId, sourceId: sourceId, sourceUrl: sourceUrl, category: category.wireName,
        );

        state = state.copyWith(
          isLoading: false,
          article: article,
          isFavorite: isFavorite,
          isStale: isStale,
        );
      } catch (_) {
        // 缓存解析失败，忽略
      }
    }

    // 2. 从网络刷新
    try {
      final article = await _repository.articleDetail(lookup);

      final isFavorite = _checkIsFavorite(article);

      state = state.copyWith(
        isLoading: false,
        article: article,
        isFavorite: isFavorite,
        isStale: false,
        error: null,
      );

      // 3. 更新缓存（保存所有 alias key）
      _cacheRepository.saveArticleCacheWithAliases(
        id: article.id, sourceId: sourceId, sourceUrl: article.sourceUrl,
        category: article.category.wireName, json: article.toJson(),
      );

      // 记录浏览
      _recordViewed(article);
    } catch (e) {
      // 4. 网络失败：如果有缓存数据则显示 stale 提示，否则显示错误
      if (state.article != null) {
        state = state.copyWith(
          isLoading: false,
          isStale: true,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// 切换收藏状态
  void toggleFavorite() {
    final article = state.article;
    if (article == null) return;

    final snapshot = _buildSnapshot(article);
    _savedNotifier.toggleFavorite(snapshot);

    final isFavorite = _checkIsFavorite(article);
    state = state.copyWith(isFavorite: isFavorite);
  }

  SavedContentTarget _buildTarget(dynamic article) {
    return SavedContentTarget(
      id: article.id,
      sourceId: sourceId,
      sourceUrl: article.sourceUrl,
      category: article.category.wireName,
    );
  }

  SavedContentSnapshot _buildSnapshot(dynamic article) {
    return SavedContentSnapshot(
      contentType: SavedContentType.article,
      id: article.id,
      title: article.title,
      summary: article.summary,
      coverImageJson: article.coverImage != null ? 'true' : null,
      category: article.category.wireName,
      sourceUrl: article.sourceUrl,
      target: _buildTarget(article),
    );
  }

  bool _checkIsFavorite(dynamic article) {
    final target = _buildTarget(article);
    return _savedNotifier.isFavoriteWithType(SavedContentType.article, target);
  }

  void _recordViewed(dynamic article) {
    final snapshot = _buildSnapshot(article);
    _savedNotifier.recordViewed(snapshot);
  }
}

/// 文章详情 ViewModel Provider
final articleDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<ArticleDetailViewModel, ArticleDetailUiState, ArticleDetailParams>(
  (ref, params) {
    final repository = ref.watch(heritageRepositoryProvider);
    final savedNotifier = ref.watch(savedContentNotifierProvider.notifier);
    final cacheRepository = ref.watch(detailCacheRepositoryProvider);
    return ArticleDetailViewModel(
      repository: repository,
      savedNotifier: savedNotifier,
      cacheRepository: cacheRepository,
      articleId: params.articleId,
      sourceId: params.sourceId,
      sourceUrl: params.sourceUrl,
      category: params.category,
    );
  },
);

/// 文章详情参数
class ArticleDetailParams {
  final String? articleId;
  final String? sourceId;
  final String? sourceUrl;
  final ArticleCategory category;

  const ArticleDetailParams({
    this.articleId,
    this.sourceId,
    this.sourceUrl,
    this.category = ArticleCategory.news,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArticleDetailParams &&
        other.articleId == articleId &&
        other.sourceId == sourceId &&
        other.sourceUrl == sourceUrl &&
        other.category == category;
  }

  @override
  int get hashCode {
    return articleId.hashCode ^
        sourceId.hashCode ^
        sourceUrl.hashCode ^
        category.hashCode;
  }
}
