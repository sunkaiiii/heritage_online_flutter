import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/articles/articles_ui_state.dart';

void main() {
  group('ArticlesUiState', () {
    test('should have default values', () {
      const state = ArticlesUiState();

      expect(state.selectedCategory, ArticleCategory.news);
      expect(state.searchKeywords, '');
      expect(state.yearFilter, '');
      expect(state.isLoadingBanners, isTrue);
      expect(state.banners, isEmpty);
      expect(state.bannerError, isNull);
      expect(state.isLoadingArticles, isTrue);
      expect(state.articles, isEmpty);
      expect(state.articlesError, isNull);
      expect(state.hasMore, isFalse);
      expect(state.currentPage, 1);
    });

    test('hasActiveFilters should be false by default', () {
      const state = ArticlesUiState();
      expect(state.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters should be true with search keywords', () {
      const state = ArticlesUiState(searchKeywords: 'test');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters should be true with year filter', () {
      const state = ArticlesUiState(yearFilter: '2024');
      expect(state.hasActiveFilters, isTrue);
    });

    test('activeFilterChips should return empty by default', () {
      const state = ArticlesUiState();
      expect(state.activeFilterChips, isEmpty);
    });

    test('activeFilterChips should include search keywords', () {
      const state = ArticlesUiState(searchKeywords: 'test');
      expect(state.activeFilterChips, contains('test'));
    });

    test('activeFilterChips should include year filter', () {
      const state = ArticlesUiState(yearFilter: '2024');
      expect(state.activeFilterChips, contains('年份: 2024'));
    });

    test('copyWith should work correctly', () {
      const state = ArticlesUiState();
      final updated = state.copyWith(
        selectedCategory: ArticleCategory.forum,
        searchKeywords: 'test',
      );

      expect(updated.selectedCategory, ArticleCategory.forum);
      expect(updated.searchKeywords, 'test');
      expect(updated.yearFilter, '');
    });

    test('copyWith should preserve values when not specified', () {
      const state = ArticlesUiState(searchKeywords: 'test');
      final updated = state.copyWith(yearFilter: '2024');

      expect(updated.searchKeywords, 'test');
      expect(updated.yearFilter, '2024');
    });

    test('copyWith should allow clearing error', () {
      const state = ArticlesUiState(articlesError: 'error');
      final updated = state.copyWith(articlesError: null);

      expect(updated.articlesError, isNull);
    });
  });
}
