import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/cache/list_cache_repository.dart';
import 'package:heritage_online_flutter/features/directory/directory_ui_state.dart';
import 'package:heritage_online_flutter/features/directory/directory_view_model.dart';

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

  group('DirectoryViewModel', () {
    test('should load items successfully with empty result', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingItems, false);
      expect(state.items, isEmpty);
      expect(state.hasMore, false);
      expect(state.itemsError, isNull);
    });

    test('should handle loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingItems, false);
      expect(state.items, isEmpty);
      expect(state.itemsError, isNotNull);
    });

    test('should change kind', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.selectKind(DirectoryItemKind.unescoEntry);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedKind, DirectoryItemKind.unescoEntry);
    });

    test('should not reload when selecting same kind', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.selectKind(DirectoryItemKind.nationalProject);
      expect(viewModel.state.selectedKind, DirectoryItemKind.nationalProject);
    });

    test('should update search keywords', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.updateSearchKeywords('昆曲');
      expect(viewModel.state.searchKeywords, '昆曲');
    });

    test('should apply filters', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.applyFilters(region: '北京', category: '传统技艺');
      expect(viewModel.state.regionFilter, '北京');
      expect(viewModel.state.categoryFilter, '传统技艺');
    });

    test('should clear all filters', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.applyFilters(region: '北京', year: '2024');
      viewModel.clearFilters();

      expect(viewModel.state.regionFilter, '');
      expect(viewModel.state.yearFilter, '');
    });

    test('should clear single filter field', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.applyFilters(region: '北京', category: '传统技艺');
      viewModel.clearFilterField('region');

      expect(viewModel.state.regionFilter, '');
      expect(viewModel.state.categoryFilter, '传统技艺');
    });

    test('should switch tabs', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.selectTab(DirectoryTab.statistics);
      expect(viewModel.state.selectedTab, DirectoryTab.statistics);
    });
  });
}
