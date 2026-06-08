import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

import 'article_detail_ui_state.dart';

/// 文章详情 ViewModel
class ArticleDetailViewModel extends StateNotifier<ArticleDetailUiState> {
  final HeritageRepository repository;
  final String? articleId;
  final String? sourceId;
  final String? sourceUrl;
  final ArticleCategory category;

  ArticleDetailViewModel({
    required this.repository,
    this.articleId,
    this.sourceId,
    this.sourceUrl,
    this.category = ArticleCategory.news,
  }) : super(const ArticleDetailUiState()) {
    loadArticle();
  }

  /// 加载文章详情
  Future<void> loadArticle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lookup = ArticleDetailLookup(
        articleId: articleId,
        sourceId: sourceId,
        sourceUrl: sourceUrl,
        category: category,
      );

      final article = await repository.articleDetail(lookup);
      state = state.copyWith(
        isLoading: false,
        article: article,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 切换收藏状态
  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }
}

/// 文章详情 ViewModel Provider
final articleDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<ArticleDetailViewModel, ArticleDetailUiState, ArticleDetailParams>(
  (ref, params) {
    final repository = ref.watch(heritageRepositoryProvider);
    return ArticleDetailViewModel(
      repository: repository,
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
