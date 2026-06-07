import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_ui_state.dart';

void main() {
  group('ArticleDetailUiState', () {
    test('should have default values', () {
      const state = ArticleDetailUiState();

      expect(state.isLoading, isTrue);
      expect(state.article, isNull);
      expect(state.error, isNull);
      expect(state.isFavorite, isFalse);
    });

    test('copyWith should update values', () {
      const state = ArticleDetailUiState();
      final updated = state.copyWith(
        isLoading: false,
        article: const ArticleDetailDto(id: '123', title: 'Test'),
      );

      expect(updated.isLoading, isFalse);
      expect(updated.article, isNotNull);
      expect(updated.article!.id, '123');
    });

    test('copyWith should preserve values when not specified', () {
      const state = ArticleDetailUiState(isFavorite: true);
      final updated = state.copyWith(isLoading: false);

      expect(updated.isFavorite, isTrue);
    });

    test('copyWith should allow clearing error', () {
      const state = ArticleDetailUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });
}
