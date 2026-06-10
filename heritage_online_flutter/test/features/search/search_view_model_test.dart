import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/search/search_view_model.dart';

import '../../core/data/fake_heritage_repository.dart';

void main() {
  late FakeHeritageRepository repository;

  setUp(() {
    repository = FakeHeritageRepository();
  });

  tearDown(() {});

  group('SearchViewModel', () {
    test('should have empty initial state', () {
      final viewModel = SearchViewModel(repository);

      final state = viewModel.state;
      expect(state.query, '');
      expect(state.results, isEmpty);
      expect(state.isSearching, false);
      expect(state.error, isNull);
    });

    test('should update query', () {
      final viewModel = SearchViewModel(repository);

      viewModel.updateQuery('test');
      expect(viewModel.state.query, 'test');
    });

    test('should not search with empty query', () {
      final viewModel = SearchViewModel(repository);

      viewModel.search();
      expect(viewModel.state.isSearching, false);
    });

    test('should handle search error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      final viewModel = SearchViewModel(repository);
      viewModel.updateQuery('test');
      viewModel.search();

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.isSearching, false);
      expect(viewModel.state.error, isNotNull);
    });

    test('should toggle type filter', () {
      final viewModel = SearchViewModel(repository);

      viewModel.toggleType(SearchResultType.article);
      expect(viewModel.state.selectedTypes, contains(SearchResultType.article));

      viewModel.toggleType(SearchResultType.article);
      expect(
          viewModel.state.selectedTypes, isNot(contains(SearchResultType.article)));
    });

    test('should clear all filters', () {
      final viewModel = SearchViewModel(repository);

      viewModel.toggleType(SearchResultType.article);
      viewModel.updateRegionFilter('北京');
      viewModel.clearAllFilters();

      expect(viewModel.state.selectedTypes, isEmpty);
      expect(viewModel.state.regionFilter, '');
    });

    test('should update region filter', () {
      final viewModel = SearchViewModel(repository);

      viewModel.updateRegionFilter('北京');
      expect(viewModel.state.regionFilter, '北京');
    });

    test('should update year filter', () {
      final viewModel = SearchViewModel(repository);

      viewModel.updateYearFilter(2024);
      expect(viewModel.state.yearFilter, 2024);
    });

    test('should update kind filter', () {
      final viewModel = SearchViewModel(repository);

      viewModel.updateKindFilter(DirectoryItemKind.unescoEntry);
      expect(viewModel.state.kindFilter, DirectoryItemKind.unescoEntry);
    });

    test('should update hasImage filter', () {
      final viewModel = SearchViewModel(repository);

      viewModel.updateHasImageFilter(true);
      expect(viewModel.state.hasImageFilter, true);
    });

    test('should clear single filter field', () {
      final viewModel = SearchViewModel(repository);

      viewModel.updateRegionFilter('北京');
      viewModel.updateYearFilter(2024);
      viewModel.clearFilter(SearchFilterField.region);

      expect(viewModel.state.regionFilter, '');
      expect(viewModel.state.yearFilter, 2024);
    });
  });
}
