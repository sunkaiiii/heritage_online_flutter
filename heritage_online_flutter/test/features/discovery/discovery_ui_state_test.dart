import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/features/discovery/discovery_ui_state.dart';

void main() {
  group('DiscoverySectionState', () {
    test('should have default values', () {
      const state = DiscoverySectionState();

      expect(state.isLoading, isFalse);
      expect(state.data, isNull);
      expect(state.error, isNull);
    });

    test('hasData should be false when data is null', () {
      const state = DiscoverySectionState();
      expect(state.hasData, isFalse);
    });

    test('hasData should be true when data is present', () {
      const state = DiscoverySectionState(data: 'test');
      expect(state.hasData, isTrue);
    });

    test('hasError should be false when error is null', () {
      const state = DiscoverySectionState();
      expect(state.hasError, isFalse);
    });

    test('hasError should be true when error is present and no data', () {
      const state = DiscoverySectionState(error: 'error');
      expect(state.hasError, isTrue);
    });

    test('hasError should be false when error is present but data exists', () {
      const state = DiscoverySectionState(data: 'test', error: 'error');
      expect(state.hasError, isFalse);
    });

    test('copyWith should work correctly', () {
      const state = DiscoverySectionState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, isTrue);
      expect(updated.data, isNull);
      expect(updated.error, isNull);
    });
  });

  group('DiscoveryUiState', () {
    test('should have default values', () {
      const state = DiscoveryUiState();

      expect(state.today.isLoading, isFalse);
      expect(state.trending.isLoading, isFalse);
      expect(state.weekly.isLoading, isFalse);
      expect(state.exploreIndex.isLoading, isFalse);
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
        today: DiscoverySectionState(isLoading: true),
      );
      expect(state.isAnyLoading, isTrue);
    });

    test('isAllFailed should be false by default', () {
      const state = DiscoveryUiState();
      expect(state.isAllFailed, isFalse);
    });

    test('isAllFailed should be true when all sections have error', () {
      const state = DiscoveryUiState(
        today: DiscoverySectionState(error: 'error'),
        trending: DiscoverySectionState(error: 'error'),
        weekly: DiscoverySectionState(error: 'error'),
        exploreIndex: DiscoverySectionState(error: 'error'),
        topics: DiscoverySectionState(error: 'error'),
        learningPaths: DiscoverySectionState(error: 'error'),
        collections: DiscoverySectionState(error: 'error'),
        regionAtlas: DiscoverySectionState(error: 'error'),
      );
      expect(state.isAllFailed, isTrue);
    });

    test('isAllFailed should be false when some sections have data', () {
      const state = DiscoveryUiState(
        today: DiscoverySectionState(error: 'error'),
        trending: DiscoverySectionState(data: 'test'),
        weekly: DiscoverySectionState(error: 'error'),
        exploreIndex: DiscoverySectionState(error: 'error'),
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
        today: const DiscoverySectionState(isLoading: true),
        serendipityLoading: true,
      );

      expect(updated.today.isLoading, isTrue);
      expect(updated.serendipityLoading, isTrue);
      expect(updated.trending.isLoading, isFalse);
    });
  });
}
