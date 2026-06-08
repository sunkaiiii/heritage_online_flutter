import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/features/inheritors/inheritors_ui_state.dart';

void main() {
  group('InheritorsUiState', () {
    test('should have default values', () {
      const state = InheritorsUiState();

      expect(state.searchKeywords, '');
      expect(state.regionFilter, '');
      expect(state.categoryFilter, '');
      expect(state.yearFilter, '');
      expect(state.genderFilter, '');
      expect(state.isLoading, isTrue);
      expect(state.inheritors, isEmpty);
      expect(state.error, isNull);
      expect(state.isLoadingMore, isFalse);
      expect(state.appendError, isNull);
      expect(state.hasMore, isFalse);
      expect(state.currentPage, 1);
    });

    test('activeFilterCount should be 0 by default', () {
      const state = InheritorsUiState();
      expect(state.activeFilterCount, 0);
    });

    test('activeFilterCount should count non-empty filters', () {
      const state = InheritorsUiState(
        regionFilter: '北京',
        genderFilter: 'male',
      );
      expect(state.activeFilterCount, 2);
    });

    test('hasActiveFilters should be false by default', () {
      const state = InheritorsUiState();
      expect(state.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters should be true with search keywords', () {
      const state = InheritorsUiState(searchKeywords: 'test');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters should be true with filters', () {
      const state = InheritorsUiState(genderFilter: 'male');
      expect(state.hasActiveFilters, isTrue);
    });

    test('activeFilterChips should return correct chips', () {
      const state = InheritorsUiState(
        searchKeywords: 'test',
        regionFilter: '北京',
        genderFilter: 'male',
      );
      final chips = state.activeFilterChips;
      expect(chips, contains('test'));
      expect(chips, contains('地区: 北京'));
      expect(chips, contains('性别: male'));
    });

    test('copyWith should work correctly', () {
      const state = InheritorsUiState();
      final updated = state.copyWith(
        searchKeywords: 'test',
        genderFilter: 'male',
      );

      expect(updated.searchKeywords, 'test');
      expect(updated.genderFilter, 'male');
      expect(updated.regionFilter, '');
    });

    test('copyWith should preserve values when not specified', () {
      const state = InheritorsUiState(searchKeywords: 'test');
      final updated = state.copyWith(genderFilter: 'male');

      expect(updated.searchKeywords, 'test');
      expect(updated.genderFilter, 'male');
    });

    test('copyWith should allow clearing error', () {
      const state = InheritorsUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });
}
