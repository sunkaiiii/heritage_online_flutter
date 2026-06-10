import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/cache/list_cache_repository.dart';
import 'package:heritage_online_flutter/features/articles/articles_view_model.dart';

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

  group('ArticlesViewModel', () {
    test('should load articles successfully with empty result', () async {
      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingArticles, false);
      expect(state.articles, isEmpty);
      expect(state.hasMore, false);
      expect(state.articlesError, isNull);
    });

    test('should handle loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoadingArticles, false);
      expect(state.articles, isEmpty);
      expect(state.articlesError, isNotNull);
    });

    test('should change category', () async {
      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.selectCategory(ArticleCategory.forum);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.selectedCategory, ArticleCategory.forum);
    });

    test('should not reload when selecting same category', () async {
      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.selectCategory(ArticleCategory.news);
      // Should not trigger a new load since it's the same category
      expect(viewModel.state.selectedCategory, ArticleCategory.news);
    });

    test('should update search keywords', () async {
      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.updateSearchKeywords('test');
      expect(viewModel.state.searchKeywords, 'test');
    });

    test('should clear filters', () async {
      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      viewModel.updateSearchKeywords('test');
      viewModel.setYearFilter('2024');
      viewModel.clearFilters();

      expect(viewModel.state.searchKeywords, '');
      expect(viewModel.state.yearFilter, '');
    });
  });
}
