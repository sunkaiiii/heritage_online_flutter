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
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.toggleFavorite(snapshot);
        final favorites = repository.getFavorites();

        expect(favorites.length, 1);
        expect(favorites[0].contentKey, 'article-1');
        expect(favorites[0].isFavorite, isTrue);
        expect(favorites[0].title, 'Test Article');
      });

      test('should remove favorite when toggled again', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.toggleFavorite(snapshot);
        repository.toggleFavorite(snapshot);
        final favorites = repository.getFavorites();

        expect(favorites.length, 1);
        expect(favorites[0].isFavorite, isFalse);
      });

      test('should check favorite status', () {
        const target = SavedContentTarget(id: 'article-1');
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          target: target,
        );

        expect(repository.isFavorite(target), isFalse);

        repository.toggleFavorite(snapshot);
        expect(repository.isFavorite(target), isTrue);

        repository.toggleFavorite(snapshot);
        expect(repository.isFavorite(target), isFalse);
      });

      test('should remove favorite by target', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.toggleFavorite(snapshot);
        repository.removeFavorite(const SavedContentTarget(id: 'article-1'));
        final favorites = repository.getFavorites();

        expect(favorites.isEmpty, isTrue);
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
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent.length, 1);
        expect(recent[0].contentKey, 'article-1');
        expect(recent[0].title, 'Test Article');
      });

      test('should not duplicate when viewing same content', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          target: SavedContentTarget(id: 'article-1'),
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
          target: SavedContentTarget(id: 'article-1'),
        );
        const snapshot2 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-2',
          title: 'Article 2',
          target: SavedContentTarget(id: 'article-2'),
        );

        repository.recordViewed(snapshot1);
        // Small delay to ensure different timestamp
        await Future.delayed(const Duration(milliseconds: 10));
        repository.recordViewed(snapshot2);
        final recent = repository.getRecentlyViewed();

        expect(recent.length, 2);
        expect(recent[0].contentKey, 'article-2');
        expect(recent[1].contentKey, 'article-1');
      });

      test('should remove recent by target', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          title: 'Test Article',
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.recordViewed(snapshot);
        repository.removeRecent(const SavedContentTarget(id: 'article-1'));
        final recent = repository.getRecentlyViewed();

        expect(recent.isEmpty, isTrue);
      });

      test('should clear all recent', () {
        const snapshot1 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-1',
          target: SavedContentTarget(id: 'article-1'),
        );
        const snapshot2 = SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'article-2',
          target: SavedContentTarget(id: 'article-2'),
        );

        repository.recordViewed(snapshot1);
        repository.recordViewed(snapshot2);
        repository.clearRecent();
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
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.toggleFavorite(snapshot);

        // Create new repository instance
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
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.recordViewed(snapshot);

        // Create new repository instance
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
          target: SavedContentTarget(id: 'article-1'),
        );

        repository.recordViewed(snapshot);
        final recent = repository.getRecentlyViewed();

        expect(recent[0].contentType, 'article');
      });

      test('should handle directoryItem type', () {
        const snapshot = SavedContentSnapshot(
          contentType: SavedContentType.directoryItem,
          id: 'dir-1',
          target: SavedContentTarget(id: 'dir-1'),
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
