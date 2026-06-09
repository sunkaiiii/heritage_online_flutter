import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/timeline_dtos.dart';
import 'package:heritage_online_flutter/features/discovery/timeline/timeline_view_model.dart';

import '../../../core/data/fake_heritage_repository.dart';

void main() {
  late FakeHeritageRepository repository;
  late TimelineViewModel viewModel;

  setUp(() {
    repository = FakeHeritageRepository();
    viewModel = TimelineViewModel(repository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('TimelineViewModel', () {
    test('initial state after load should have empty years', () async {
      // _loadYears() runs in constructor; with fake repo it completes synchronously
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingYears, false);
      expect(state.years, isEmpty);
      expect(state.selectedYear, isNull);
      expect(state.items, isEmpty);
      expect(state.isLoadingItems, false);
      expect(state.yearsError, isNull);
    });

    test('should load years successfully', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(
          year: 2024,
          total: 100,
          articleCount: 50,
          directoryItemCount: 30,
          inheritorCount: 20,
        ),
        const TimelineYearBucketDto(
          year: 2023,
          total: 80,
          articleCount: 40,
          directoryItemCount: 25,
          inheritorCount: 15,
        ),
      ];

      // Re-create to trigger loadYears
      viewModel.dispose();
      viewModel = TimelineViewModel(repository);

      // Wait for async load
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingYears, false);
      expect(state.years.length, 2);
      expect(state.years[0].year, 2024);
      expect(state.years[0].total, 100);
      expect(state.years[1].year, 2023);
      expect(state.yearsError, isNull);
    });

    test('should handle years loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);

      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingYears, false);
      expect(state.years, isEmpty);
      expect(state.yearsError, isNotNull);
    });

    test('should select year and load items', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [
          TimelineItemDto(id: '1', type: 'article', title: '文章1', year: 2024),
          TimelineItemDto(id: '2', type: 'directoryItem', title: '名录1', year: 2024),
        ],
        page: 1,
        hasMore: false,
        total: 2,
        facets: TimelineV2FacetsDto(
          types: [
            FacetBucketDto(key: 'article', count: 1),
            FacetBucketDto(key: 'directoryItem', count: 1),
          ],
        ),
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);

      // Wait for items to load
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.selectedYear, 2024);
      expect(state.isLoadingItems, false);
      expect(state.items.length, 2);
      expect(state.items[0].title, '文章1');
      expect(state.items[1].type, 'directoryItem');
      expect(state.facets.length, 2);
    });

    test('should clear items when selecting a new year', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
        const TimelineYearBucketDto(year: 2023, total: 5),
      ];

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      // Select first year
      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      // Select second year — items should be cleared immediately
      viewModel.selectYear(2023);

      final state = viewModel.state;
      expect(state.selectedYear, 2023);
      expect(state.items, isEmpty); // cleared before new load
      expect(state.isLoadingItems, true);
    });

    test('should toggle type filter', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [
          TimelineItemDto(id: '1', type: 'article', title: '文章1'),
        ],
        facets: TimelineV2FacetsDto(
          types: [
            FacetBucketDto(key: 'article', count: 10),
            FacetBucketDto(key: 'directoryItem', count: 5),
          ],
        ),
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      // Select year first
      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      // Toggle type filter
      viewModel.toggleType(SearchResultType.article);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.selectedTypes, contains(SearchResultType.article));
    });

    test('should deselect type when toggled again', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [],
        facets: TimelineV2FacetsDto(
          types: [FacetBucketDto(key: 'article', count: 10)],
        ),
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      // Toggle on
      viewModel.toggleType(SearchResultType.article);
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.selectedTypes, contains(SearchResultType.article));

      // Toggle off
      viewModel.toggleType(SearchResultType.article);
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.selectedTypes, isNot(contains(SearchResultType.article)));
    });

    test('should load more items', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 40),
      ];

      // First page
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [
          TimelineItemDto(id: '1', type: 'article', title: '文章1'),
        ],
        page: 1,
        hasMore: true,
        total: 40,
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.hasMore, true);
      expect(viewModel.state.items.length, 1);

      // Set up second page response
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [
          TimelineItemDto(id: '2', type: 'article', title: '文章2'),
        ],
        page: 2,
        hasMore: false,
        total: 40,
      );

      await viewModel.loadMore();
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.items.length, 2);
      expect(state.items[1].title, '文章2');
      expect(state.hasMore, false);
      expect(state.isLoadingMore, false);
    });

    test('should not load more when already loading', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [TimelineItemDto(id: '1')],
        hasMore: true,
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      // Start first loadMore
      final future1 = viewModel.loadMore();
      // Try second loadMore immediately — should be skipped
      final future2 = viewModel.loadMore();

      await future1;
      await future2;

      // Only one additional item should be added
      // (the second call was a no-op)
    });

    test('should not load more when hasMore is false', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 1),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [TimelineItemDto(id: '1')],
        hasMore: false,
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      final itemsBefore = viewModel.state.items.length;
      await viewModel.loadMore();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.items.length, itemsBefore);
    });

    test('should handle items loading error', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      // Set error for timelineV2 call
      repository.shouldThrow = true;
      repository.mockError = Exception('Items load failed');

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingItems, false);
      expect(state.items, isEmpty);
      expect(state.itemsError, isNotNull);
    });

    test('should retry load years', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.yearsError, isNotNull);

      // Fix the error and retry
      repository.shouldThrow = false;
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];

      viewModel.retryLoadYears();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.yearsError, isNull);
      expect(viewModel.state.years.length, 1);
    });

    test('should not select same year twice', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [TimelineItemDto(id: '1')],
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      final itemsAfterFirstSelect = viewModel.state.items;

      // Select same year again — should be no-op
      viewModel.selectYear(2024);

      expect(viewModel.state.items, same(itemsAfterFirstSelect));
    });

    test('needsYearSelection should be true when no year selected', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.needsYearSelection, true);
    });

    test('needsYearSelection should be false after year selected', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 10),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(items: []);

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.needsYearSelection, false);
    });

    test('should handle load more error', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 40),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [TimelineItemDto(id: '1')],
        page: 1,
        hasMore: true,
        total: 40,
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      // Set error for next call
      repository.shouldThrow = true;
      repository.mockError = Exception('Load more failed');

      await viewModel.loadMore();
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingMore, false);
      expect(state.loadMoreError, isNotNull);
      // Original items should still be there
      expect(state.items.length, 1);
    });

    test('empty years list should show empty state without error', () async {
      repository.mockTimelineYears = [];

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingYears, false);
      expect(state.years, isEmpty);
      expect(state.yearsError, isNull);
    });

    test('selecting year with empty items should show empty state', () async {
      repository.mockTimelineYears = [
        const TimelineYearBucketDto(year: 2024, total: 0),
      ];
      repository.mockTimelineResponse = const TimelineV2ResponseDto(
        items: [],
        hasMore: false,
      );

      viewModel.dispose();
      viewModel = TimelineViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel.selectYear(2024);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.selectedYear, 2024);
      expect(state.items, isEmpty);
      expect(state.isLoadingItems, false);
      expect(state.itemsError, isNull);
    });
  });
}
