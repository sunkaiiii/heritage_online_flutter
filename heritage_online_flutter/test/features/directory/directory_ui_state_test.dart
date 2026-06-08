import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/directory/directory_ui_state.dart';

void main() {
  group('DirectoryUiState', () {
    test('should have default values', () {
      const state = DirectoryUiState();

      expect(state.selectedKind, DirectoryItemKind.nationalProject);
      expect(state.searchKeywords, '');
      expect(state.regionFilter, '');
      expect(state.categoryFilter, '');
      expect(state.yearFilter, '');
      expect(state.listTypeFilter, '');
      expect(state.selectedTab, DirectoryTab.list);
      expect(state.isLoadingItems, isTrue);
      expect(state.items, isEmpty);
      expect(state.itemsError, isNull);
      expect(state.isLoadingMore, isFalse);
      expect(state.itemsAppendError, isNull);
      expect(state.hasMore, isFalse);
      expect(state.currentPage, 1);
    });

    test('activeFilterCount should be 0 by default', () {
      const state = DirectoryUiState();
      expect(state.activeFilterCount, 0);
    });

    test('activeFilterCount should count non-empty filters', () {
      const state = DirectoryUiState(
        regionFilter: '北京',
        categoryFilter: '传统技艺',
      );
      expect(state.activeFilterCount, 2);
    });

    test('hasActiveFilters should be false by default', () {
      const state = DirectoryUiState();
      expect(state.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters should be true with search keywords', () {
      const state = DirectoryUiState(searchKeywords: 'test');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters should be true with filters', () {
      const state = DirectoryUiState(regionFilter: '北京');
      expect(state.hasActiveFilters, isTrue);
    });

    test('activeFilterChips should return correct chips', () {
      const state = DirectoryUiState(
        searchKeywords: 'test',
        regionFilter: '北京',
        yearFilter: '2024',
      );
      final chips = state.activeFilterChips;
      expect(chips, contains('test'));
      expect(chips, contains('地区: 北京'));
      expect(chips, contains('年份: 2024'));
    });

    test('copyWith should work correctly', () {
      const state = DirectoryUiState();
      final updated = state.copyWith(
        selectedKind: DirectoryItemKind.unescoEntry,
        searchKeywords: 'test',
      );

      expect(updated.selectedKind, DirectoryItemKind.unescoEntry);
      expect(updated.searchKeywords, 'test');
      expect(updated.regionFilter, '');
    });

    test('copyWith should preserve values when not specified', () {
      const state = DirectoryUiState(searchKeywords: 'test');
      final updated = state.copyWith(regionFilter: '北京');

      expect(updated.searchKeywords, 'test');
      expect(updated.regionFilter, '北京');
    });
  });

  group('DirectoryStatisticsState', () {
    test('should have default values', () {
      const state = DirectoryStatisticsState();

      expect(state.isLoading, isFalse);
      expect(state.overview, isNull);
      expect(state.yearBreakdown, isNull);
      expect(state.categoryBreakdown, isNull);
      expect(state.regionBreakdown, isNull);
      expect(state.error, isNull);
    });

    test('copyWith should work correctly', () {
      const state = DirectoryStatisticsState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, isTrue);
      expect(updated.overview, isNull);
    });
  });
}
