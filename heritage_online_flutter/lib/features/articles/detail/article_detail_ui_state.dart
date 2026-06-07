import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';

/// 文章详情 UI 状态
class ArticleDetailUiState {
  final bool isLoading;
  final ArticleDetailDto? article;
  final String? error;
  final bool isFavorite;

  const ArticleDetailUiState({
    this.isLoading = true,
    this.article,
    this.error,
    this.isFavorite = false,
  });

  ArticleDetailUiState copyWith({
    bool? isLoading,
    ArticleDetailDto? article,
    String? error,
    bool? isFavorite,
  }) {
    return ArticleDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      article: article ?? this.article,
      error: error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
