import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/search/search_ui_state.dart';

void main() {
  group('SearchUiState', () {
    test('should have default values', () {
      const state = SearchUiState();

      expect(state.query, '');
      expect(state.isSearching, isFalse);
      expect(state.results, isEmpty);
      expect(state.page, 1);
      expect(state.hasMore, isFalse);
      expect(state.total, 0);
      expect(state.facets, isNull);
      expect(state.selectedTypes, isEmpty);
      expect(state.regionFilter, '');
      expect(state.categoryFilter, '');
      expect(state.yearFilter, isNull);
      expect(state.kindFilter, isNull);
      expect(state.hasImageFilter, isNull);
      expect(state.suggestions, isEmpty);
      expect(state.isLoadingSuggestions, isFalse);
      expect(state.isLoadingMore, isFalse);
      expect(state.error, isNull);
      expect(state.loadMoreError, isNull);
    });

    test('hasActiveFilters should be false by default', () {
      const state = SearchUiState();
      expect(state.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters should be true with selectedTypes', () {
      const state = SearchUiState(
        selectedTypes: {SearchResultType.article},
      );
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters should be true with regionFilter', () {
      const state = SearchUiState(regionFilter: '北京');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters should be true with yearFilter', () {
      const state = SearchUiState(yearFilter: 2024);
      expect(state.hasActiveFilters, isTrue);
    });

    test('activeFilterCount should be 0 by default', () {
      const state = SearchUiState();
      expect(state.activeFilterCount, 0);
    });

    test('activeFilterCount should count selectedTypes as 1', () {
      const state = SearchUiState(
        selectedTypes: {SearchResultType.article, SearchResultType.directoryItem},
      );
      expect(state.activeFilterCount, 1);
    });

    test('activeFilterCount should count multiple filters', () {
      const state = SearchUiState(
        selectedTypes: {SearchResultType.article},
        regionFilter: '北京',
        yearFilter: 2024,
      );
      expect(state.activeFilterCount, 3);
    });

    test('copyWith should work correctly', () {
      const state = SearchUiState();
      final updated = state.copyWith(
        query: 'test',
        isSearching: true,
      );

      expect(updated.query, 'test');
      expect(updated.isSearching, isTrue);
      expect(updated.results, isEmpty);
    });

    test('copyWith should preserve values when not specified', () {
      const state = SearchUiState(query: 'test');
      final updated = state.copyWith(isSearching: true);

      expect(updated.query, 'test');
      expect(updated.isSearching, isTrue);
    });

    test('copyWith should allow clearing error', () {
      const state = SearchUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('SearchSuggestionDto', () {
    test('should create with text', () {
      const dto = SearchSuggestionDto(text: 'test');
      expect(dto.text, 'test');
    });

    test('should create with null text', () {
      const dto = SearchSuggestionDto();
      expect(dto.text, isNull);
    });
  });

  group('SearchResultItemDto', () {
    test('should create with all fields', () {
      const dto = SearchResultItemDto(
        id: '123',
        type: 'article',
        title: 'Test',
        summary: 'Summary',
        category: 'news',
        region: '北京',
        sourceId: 'source-123',
      );

      expect(dto.id, '123');
      expect(dto.type, 'article');
      expect(dto.title, 'Test');
      expect(dto.summary, 'Summary');
      expect(dto.category, 'news');
      expect(dto.region, '北京');
      expect(dto.sourceId, 'source-123');
    });

    test('should create with null fields', () {
      const dto = SearchResultItemDto();

      expect(dto.id, isNull);
      expect(dto.type, isNull);
      expect(dto.title, isNull);
    });
  });
}
