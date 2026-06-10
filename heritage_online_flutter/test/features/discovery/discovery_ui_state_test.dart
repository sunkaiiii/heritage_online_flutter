import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/discovery_dtos.dart';
import 'package:heritage_online_flutter/features/discovery/discovery_ui_state.dart';

void main() {
  group('DiscoverySectionState', () {
    test('should have default values', () {
      const state = DiscoverySectionState<String>();

      expect(state.isLoading, isFalse);
      expect(state.data, isNull);
      expect(state.error, isNull);
    });

    test('hasData should be false when data is null', () {
      const state = DiscoverySectionState<String>();
      expect(state.hasData, isFalse);
    });

    test('hasData should be true when data is present', () {
      const state = DiscoverySectionState<String>(data: 'test');
      expect(state.hasData, isTrue);
    });

    test('hasError should be false when error is null', () {
      const state = DiscoverySectionState<String>();
      expect(state.hasError, isFalse);
    });

    test('hasError should be true when error is present and no data', () {
      const state = DiscoverySectionState<String>(error: 'error');
      expect(state.hasError, isTrue);
    });

    test('hasError should be false when error is present but data exists', () {
      const state = DiscoverySectionState<String>(data: 'test', error: 'error');
      expect(state.hasError, isFalse);
    });

    test('copyWith should work correctly', () {
      const state = DiscoverySectionState<String>();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, isTrue);
      expect(updated.data, isNull);
    });
  });

  group('DiscoveryUiState', () {
    test('should have default values', () {
      const state = DiscoveryUiState();

      expect(state.today.isLoading, isFalse);
      expect(state.trending.isLoading, isFalse);
      expect(state.weekly.isLoading, isFalse);
      expect(state.topics.isLoading, isFalse);
      expect(state.learningPaths.isLoading, isFalse);
      expect(state.collections.isLoading, isFalse);
      expect(state.regionAtlas.isLoading, isFalse);
      expect(state.serendipityLoading, isFalse);
    });

    test('isAnyLoading should be false by default', () {
      const state = DiscoveryUiState();
      expect(state.isAnyLoading, isFalse);
    });

    test('isAnyLoading should be true when any section is loading', () {
      const state = DiscoveryUiState(
        today: DiscoverySectionState<DiscoveryTodayDto>(isLoading: true),
      );
      expect(state.isAnyLoading, isTrue);
    });

    test('isAllFailed should be false by default', () {
      const state = DiscoveryUiState();
      expect(state.isAllFailed, isFalse);
    });

    test('isAllFailed should be true when all sections have error', () {
      final state = DiscoveryUiState(
        today: DiscoverySectionState<DiscoveryTodayDto>(error: 'error'),
        trending: DiscoverySectionState<DiscoveryTrendingDto>(error: 'error'),
        weekly: DiscoverySectionState<DiscoveryWeeklyDto>(error: 'error'),
        topics: DiscoverySectionState(error: 'error'),
        learningPaths: DiscoverySectionState(error: 'error'),
        collections: DiscoverySectionState(error: 'error'),
        regionAtlas: DiscoverySectionState(error: 'error'),
      );
      expect(state.isAllFailed, isTrue);
    });

    test('isAllFailed should be false when some sections have data', () {
      final state = DiscoveryUiState(
        today: DiscoverySectionState<DiscoveryTodayDto>(error: 'error'),
        trending: DiscoverySectionState<DiscoveryTrendingDto>(data: DiscoveryTrendingDto()),
        weekly: DiscoverySectionState<DiscoveryWeeklyDto>(error: 'error'),
        topics: DiscoverySectionState(error: 'error'),
        learningPaths: DiscoverySectionState(error: 'error'),
        collections: DiscoverySectionState(error: 'error'),
        regionAtlas: DiscoverySectionState(error: 'error'),
      );
      expect(state.isAllFailed, isFalse);
    });

    test('copyWith should work correctly', () {
      const state = DiscoveryUiState();
      final updated = state.copyWith(
        today: DiscoverySectionState<DiscoveryTodayDto>(isLoading: true),
        serendipityLoading: true,
      );

      expect(updated.today.isLoading, isTrue);
      expect(updated.serendipityLoading, isTrue);
      expect(updated.trending.isLoading, isFalse);
    });
  });
}
