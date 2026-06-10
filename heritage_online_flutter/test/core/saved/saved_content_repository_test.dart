import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/saved/saved_content_repository.dart';
import 'package:heritage_online_flutter/core/saved/saved_content_types.dart';

void main() {
  late SharedPreferences prefs;
  late SavedContentRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = SavedContentRepository(prefs: prefs);
  });

  group('SavedContentRepository', () {
    group('Favorites', () {
      test('should return empty list by default', () {
        final favorites = repository.getFavorites();
        expect(favorites, isEmpty);
      });

      test('should add favorite', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.toggleFavorite(snapshot);
        final favorites = repository.getFavorites();

        expect(favorites.length, 1);
        expect(favorites[0].contentKey, 'article|news|id:article-1');
        expect(favorites[0].isFavorite, isTrue);
        expect(favorites[0].title, 'Test Article');
      });

      test('should remove favorite when toggled again', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.toggleFavorite(snapshot);
        repository.toggleFavorite(snapshot);
        final favorites = repository.getFavorites();

        expect(favorites.length, 1);
        expect(favorites[0].isFavorite, isFalse);
      });

      test('should check favorite status with new key format', () {
        const target = SavedContentTarget(id: 'article-1', category: 'news');
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          category: 'news',
          target: target,
        );

        // isFavorite uses old key format (just id), need notifier for new format
        expect(repository.isFavorite(target), isFalse);

        repository.toggleFavorite(snapshot);
        // After toggle, isFavorite with plain target still uses old format
        // The notifier provides isFavoriteWithType for new format
        final favorites = repository.getFavorites();
        expect(favorites.length, 1);
        expect(favorites[0].contentKey, 'article|news|id:article-1');
      });

      test('should remove favorite by target', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.toggleFavorite(snapshot);
        repository.removeFavorite(const SavedContentTarget(id: 'article-1'));
        final favorites = repository.getFavorites();

        // removeFavorite uses old key format (just id), so it should still work
        expect(favorites.isEmpty, isTrue);
      });

      test('should not create favorite with missing lookup key', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          target: SavedContentTarget(),
        );

        repository.toggleFavorite(snapshot);
        final favorites = repository.getFavorites();

        // No valid lookup key, should not add
        expect(favorites.isEmpty, isTrue);
      });

      test('article id 1 and directory id 1 should not conflict', () {
        const articleSnapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: '1',
          category: 'news',
          target: SavedContentTarget(id: '1', category: 'news'),
        );
        const directorySnapshot = SavedContentSnapshot(
          contentType: SavedContentType.directoryItem,
          id: '1',
          target: SavedContentTarget(id: '1', kind: 'nationalProject'),
        );

        repository.toggleFavorite(articleSnapshot);
        repository.toggleFavorite(directorySnapshot);
        final favorites = repository.getFavorites();

        expect(favorites.length, 2);
        // Keys should be different
        expect(favorites[0].contentKey, isNot(favorites[1].contentKey));
        expect(favorites[0].contentKey, 'article|news|id:1');
        expect(favorites[1].contentKey, 'directoryItem|nationalProject|id:1');
      });

      test('same sourceId different category should not conflict', () {
        const snapshot1 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          category: 'news',
          target: SavedContentTarget(sourceId: 'src-1', category: 'news'),
        );
        const snapshot2 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          category: 'forum',
          target: SavedContentTarget(sourceId: 'src-1', category: 'forum'),
        );

        repository.toggleFavorite(snapshot1);
        repository.toggleFavorite(snapshot2);
        final favorites = repository.getFavorites();

        expect(favorites.length, 2);
        expect(favorites[0].contentKey, 'article|news|sourceId:src-1');
        expect(favorites[1].contentKey, 'article|forum|sourceId:src-1');
      });
    });

    group('Recently Viewed', () {
      test('should return empty list by default', () {
        final recent = repository.getRecentlyViewed();
        expect(recent, isEmpty);
      });

      test('should record viewed', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent.length, 1);
        expect(recent[0].contentKey, 'article|news|id:article-1');
        expect(recent[0].title, 'Test Article');
      });

      test('should not duplicate when viewing same content', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.recordViewed(snapshot);
        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent.length, 1);
      });

      test('should sort by lastViewedAt descending', () async {
        const snapshot1 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Article 1',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );
        const snapshot2 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-2',
          title: 'Article 2',
          category: 'news',
          target: SavedContentTarget(id: 'article-2', category: 'news'),
        );

        repository.recordViewed(snapshot1);
        await Future.delayed(const Duration(milliseconds: 10));
        repository.recordViewed(snapshot2);
        final recent = repository.getRecentlyViewed();

        expect(recent.length, 2);
        expect(recent[0].contentKey, 'article|news|id:article-2');
        expect(recent[1].contentKey, 'article|news|id:article-1');
      });

      test('should remove recent by target', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.recordViewed(snapshot);
        repository.removeRecent(const SavedContentTarget(id: 'article-1'));
        final recent = repository.getRecentlyViewed();

        expect(recent.isEmpty, isTrue);
      });

      test('should not record with missing lookup key', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          target: SavedContentTarget(),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent.isEmpty, isTrue);
      });
    });

    group('Persistence', () {
      test('favorites should persist across instances', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.toggleFavorite(snapshot);

        final newRepo = SavedContentRepository(prefs: prefs);
        final favorites = newRepo.getFavorites();

        expect(favorites.length, 1);
        expect(favorites[0].isFavorite, isTrue);
      });

      test('recent should persist across instances', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.recordViewed(snapshot);

        final newRepo = SavedContentRepository(prefs: prefs);
        final recent = newRepo.getRecentlyViewed();

        expect(recent.length, 1);
      });
    });

    group('Content Types', () {
      test('should handle article type', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          category: 'news',
          target: SavedContentTarget(id: 'article-1', category: 'news'),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent[0].contentType, 'article');
      });

      test('should handle directoryItem type', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.directoryItem,
          id: 'dir-1',
          target: SavedContentTarget(id: 'dir-1', kind: 'nationalProject'),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent[0].contentType, 'directoryItem');
      });

      test('should handle inheritor type', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.inheritor,
          id: 'inh-1',
          target: SavedContentTarget(id: 'inh-1'),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent[0].contentType, 'inheritor');
      });
    });
  });
}
