import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/cache/list_cache_repository.dart';

void main() {
  late ListCacheRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = ListCacheRepository(prefs: prefs);
  });

  group('ListCacheEntry', () {
    test('should serialize and deserialize', () {
      final entry = ListCacheEntry(
        items: [
          {'id': '1', 'title': 'Item 1'},
          {'id': '2', 'title': 'Item 2'},
        ],
        hasMore: true,
        currentPage: 2,
        cachedAt: DateTime(2024, 6, 15),
      );

      final map = entry.toMap();
      final restored = ListCacheEntry.fromMap(map);

      expect(restored.items.length, 2);
      expect(restored.items[0]['id'], '1');
      expect(restored.hasMore, true);
      expect(restored.currentPage, 2);
      expect(restored.cachedAt, DateTime(2024, 6, 15));
    });

    test('should handle empty items', () {
      final entry = ListCacheEntry(
        items: [],
        hasMore: false,
        currentPage: 1,
        cachedAt: DateTime.now(),
      );

      final map = entry.toMap();
      final restored = ListCacheEntry.fromMap(map);

      expect(restored.items, isEmpty);
      expect(restored.hasMore, false);
    });
  });

  group('QueryKeyBuilder', () {
    test('should build article query key', () {
      final key = QueryKeyBuilder.articles(
        category: 'news',
        keywords: 'test',
        year: 2024,
      );
      expect(key, 'articles|cat:news|kw:test|y:2024');
    });

    test('should build article query key with minimal params', () {
      final key = QueryKeyBuilder.articles();
      expect(key, 'articles');
    });

    test('should build directory query key', () {
      final key = QueryKeyBuilder.directoryItems(
        kind: 'nationalProject',
        region: '北京',
      );
      expect(key, 'directory|kind:nationalProject|reg:北京');
    });

    test('should build inheritor query key', () {
      final key = QueryKeyBuilder.inheritors(
        gender: 'male',
        category: '传统技艺',
      );
      expect(key, 'inheritors|cat:传统技艺|g:male');
    });

    test('should skip empty/null params', () {
      final key = QueryKeyBuilder.articles(
        category: '',
        keywords: null,
      );
      expect(key, 'articles');
    });
  });

  group('Article List Cache', () {
    test('should return null for non-existent cache', () {
      expect(repository.getArticleCache('non-existent'), isNull);
    });

    test('should save and retrieve article cache', () {
      final entry = ListCacheEntry(
        items: [
          {'id': '1', 'title': '文章1'},
        ],
        hasMore: true,
        currentPage: 1,
        cachedAt: DateTime.now(),
      );

      repository.saveArticleCache('articles|cat:news', entry);

      final cached = repository.getArticleCache('articles|cat:news');
      expect(cached, isNotNull);
      expect(cached!.items.length, 1);
      expect(cached.hasMore, true);
    });

    test('should overwrite on refresh', () {
      repository.saveArticleCache(
        'key',
        ListCacheEntry(
          items: [{'id': 'old'}],
          hasMore: true,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      repository.saveArticleCache(
        'key',
        ListCacheEntry(
          items: [{'id': 'new'}],
          hasMore: false,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      final cached = repository.getArticleCache('key');
      expect(cached!.items[0]['id'], 'new');
      expect(cached.hasMore, false);
    });

    test('should append items', () {
      repository.saveArticleCache(
        'key',
        ListCacheEntry(
          items: [{'id': '1'}, {'id': '2'}],
          hasMore: true,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      repository.appendArticleCache(
        'key',
        ListCacheEntry(
          items: [{'id': '3'}],
          hasMore: false,
          currentPage: 2,
          cachedAt: DateTime.now(),
        ),
      );

      final cached = repository.getArticleCache('key');
      expect(cached!.items.length, 3);
      expect(cached.items[2]['id'], '3');
      expect(cached.hasMore, false);
      expect(cached.currentPage, 2);
    });

    test('append should create entry if not exists', () {
      repository.appendArticleCache(
        'new-key',
        ListCacheEntry(
          items: [{'id': '1'}],
          hasMore: true,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      final cached = repository.getArticleCache('new-key');
      expect(cached, isNotNull);
      expect(cached!.items.length, 1);
    });

    test('should clear article cache', () {
      repository.saveArticleCache('k1', ListCacheEntry(
        items: [{'id': '1'}], hasMore: false, currentPage: 1, cachedAt: DateTime.now(),
      ));
      repository.saveArticleCache('k2', ListCacheEntry(
        items: [{'id': '2'}], hasMore: false, currentPage: 1, cachedAt: DateTime.now(),
      ));

      repository.clearArticleCache();

      expect(repository.getArticleCache('k1'), isNull);
      expect(repository.getArticleCache('k2'), isNull);
    });
  });

  group('Directory List Cache', () {
    test('should save and retrieve', () {
      final entry = ListCacheEntry(
        items: [{'id': 'dir-1'}],
        hasMore: false,
        currentPage: 1,
        cachedAt: DateTime.now(),
      );

      repository.saveDirectoryCache('dir-key', entry);
      final cached = repository.getDirectoryCache('dir-key');
      expect(cached, isNotNull);
      expect(cached!.items[0]['id'], 'dir-1');
    });
  });

  group('Inheritor List Cache', () {
    test('should save and retrieve', () {
      final entry = ListCacheEntry(
        items: [{'id': 'inh-1'}],
        hasMore: true,
        currentPage: 1,
        cachedAt: DateTime.now(),
      );

      repository.saveInheritorCache('inh-key', entry);
      final cached = repository.getInheritorCache('inh-key');
      expect(cached, isNotNull);
      expect(cached!.items[0]['id'], 'inh-1');
    });
  });

  group('LRU Eviction', () {
    test('should evict oldest when exceeding max', () {
      for (var i = 0; i < 22; i++) {
        repository.saveArticleCache(
          'key-$i',
          ListCacheEntry(
            items: [{'id': '$i'}],
            hasMore: false,
            currentPage: 1,
            cachedAt: DateTime.now(),
          ),
        );
      }

      // First two should be evicted
      expect(repository.getArticleCache('key-0'), isNull);
      expect(repository.getArticleCache('key-1'), isNull);

      // Last ones should still exist
      expect(repository.getArticleCache('key-21'), isNotNull);
    });
  });

  group('Clear All', () {
    test('should clear all caches', () {
      repository.saveArticleCache('a1', ListCacheEntry(
        items: [], hasMore: false, currentPage: 1, cachedAt: DateTime.now(),
      ));
      repository.saveDirectoryCache('d1', ListCacheEntry(
        items: [], hasMore: false, currentPage: 1, cachedAt: DateTime.now(),
      ));
      repository.saveInheritorCache('i1', ListCacheEntry(
        items: [], hasMore: false, currentPage: 1, cachedAt: DateTime.now(),
      ));

      repository.clearAll();

      expect(repository.getArticleCache('a1'), isNull);
      expect(repository.getDirectoryCache('d1'), isNull);
      expect(repository.getInheritorCache('i1'), isNull);
    });
  });

  group('Corrupted Data', () {
    test('should handle corrupted cache gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'list_cache_article_corrupted': 'not valid json{{{',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = ListCacheRepository(prefs: prefs);

      expect(repo.getArticleCache('corrupted'), isNull);
    });
  });

  group('Different queryKeys do not mix', () {
    test('should keep separate caches for different queries', () {
      repository.saveArticleCache(
        'articles|cat:news',
        ListCacheEntry(
          items: [{'id': 'news-1'}],
          hasMore: false,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      repository.saveArticleCache(
        'articles|cat:forum',
        ListCacheEntry(
          items: [{'id': 'forum-1'}],
          hasMore: false,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      final news = repository.getArticleCache('articles|cat:news');
      final forum = repository.getArticleCache('articles|cat:forum');

      expect(news!.items[0]['id'], 'news-1');
      expect(forum!.items[0]['id'], 'forum-1');
    });
  });
}
