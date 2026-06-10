import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/cache/list_cache_repository.dart';
import 'package:heritage_online_flutter/features/inheritors/inheritors_view_model.dart';

import '../../core/data/fake_heritage_repository.dart';

void main() {
  late FakeHeritageRepository repository;
  late ListCacheRepository listCache;

  setUp(() async {
    repository = FakeHeritageRepository();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    listCache = ListCacheRepository(prefs: prefs);
  });

  group('InheritorsViewModel', () {
    test('should load inheritors successfully with empty result', () async {
      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.inheritors, isEmpty);
      expect(state.hasMore, false);
      expect(state.error, isNull);
    });

    test('should handle loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.inheritors, isEmpty);
      expect(state.error, isNotNull);
    });

    test('should update search keywords', () async {
      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.updateSearchKeywords('张');
      expect(viewModel.state.searchKeywords, '张');
    });

    test('should apply filters', () async {
      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.applyFilters(region: '四川', gender: 'male');
      expect(viewModel.state.regionFilter, '四川');
      expect(viewModel.state.genderFilter, 'male');
    });

    test('should clear all filters', () async {
      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.applyFilters(region: '四川', category: '传统技艺', gender: 'male');
      viewModel.clearFilters();

      expect(viewModel.state.regionFilter, '');
      expect(viewModel.state.categoryFilter, '');
      expect(viewModel.state.genderFilter, '');
    });

    test('should clear single filter field', () async {
      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.applyFilters(region: '四川', gender: 'male');
      viewModel.clearFilterField('gender');

      expect(viewModel.state.regionFilter, '四川');
      expect(viewModel.state.genderFilter, '');
    });
  });
}
