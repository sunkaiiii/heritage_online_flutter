import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/cache/detail_cache_repository.dart';

void main() {
  late DetailCacheRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = DetailCacheRepository(prefs: prefs);
  });

  group('DetailCacheRepository - Article Cache', () {
    test('should return null for non-existent cache', () {
      expect(repository.getArticleCache('non-existent'), isNull);
    });

    test('should save and retrieve article cache', () {
      final json = {
        'id': 'art-1',
        'title': '测试文章',
        'summary': '摘要',
        'category': 'news',
      };

      repository.saveArticleCache('art-1', json);

      final cached = repository.getArticleCache('art-1');
      expect(cached, isNotNull);
      expect(cached!['id'], 'art-1');
      expect(cached['title'], '测试文章');
      // Should have timestamp
      expect(cached['_cachedAt'], isNotNull);
    });

    test('should overwrite existing cache', () {
      repository.saveArticleCache('art-1', {'title': '旧标题'});
      repository.saveArticleCache('art-1', {'title': '新标题'});

      final cached = repository.getArticleCache('art-1');
      expect(cached!['title'], '新标题');
    });

    test('should clear article cache', () {
      repository.saveArticleCache('art-1', {'id': 'art-1'});
      repository.saveArticleCache('art-2', {'id': 'art-2'});

      repository.clearArticleCache();

      expect(repository.getArticleCache('art-1'), isNull);
      expect(repository.getArticleCache('art-2'), isNull);
    });
  });

  group('DetailCacheRepository - Directory Cache', () {
    test('should save and retrieve directory cache', () {
      final json = {
        'id': 'dir-1',
        'title': '名录标题',
        'kind': 'nationalProject',
      };

      repository.saveDirectoryCache('dir-1', json);

      final cached = repository.getDirectoryCache('dir-1');
      expect(cached, isNotNull);
      expect(cached!['title'], '名录标题');
    });

    test('should clear directory cache', () {
      repository.saveDirectoryCache('dir-1', {'id': 'dir-1'});
      repository.clearDirectoryCache();
      expect(repository.getDirectoryCache('dir-1'), isNull);
    });
  });

  group('DetailCacheRepository - Inheritor Cache', () {
    test('should save and retrieve inheritor cache', () {
      final json = {
        'id': 'inh-1',
        'name': '传承人姓名',
      };

      repository.saveInheritorCache('inh-1', json);

      final cached = repository.getInheritorCache('inh-1');
      expect(cached, isNotNull);
      expect(cached!['name'], '传承人姓名');
    });

    test('should clear inheritor cache', () {
      repository.saveInheritorCache('inh-1', {'id': 'inh-1'});
      repository.clearInheritorCache();
      expect(repository.getInheritorCache('inh-1'), isNull);
    });
  });

  group('DetailCacheRepository - Timestamp and Staleness', () {
    test('should track cache timestamp', () {
      repository.saveArticleCache('art-1', {'id': 'art-1'});

      final timestamp = repository.getCacheTimestamp('detail_cache_article_art-1');
      expect(timestamp, isNotNull);
      expect(timestamp!.difference(DateTime.now()).inSeconds, lessThan(5));
    });

    test('fresh cache should not be stale', () {
      repository.saveArticleCache('art-1', {'id': 'art-1'});

      expect(repository.isStaleEntry('article', 'art-1'), isFalse);
    });

    test('non-existent cache should be stale', () {
      expect(repository.isStaleEntry('article', 'non-existent'), isTrue);
    });

    test('should return null timestamp for non-existent key', () {
      expect(repository.getCacheTimestamp('non-existent'), isNull);
    });
  });

  group('DetailCacheRepository - LRU Eviction', () {
    test('should evict oldest entries when exceeding max', () {
      // Save 52 entries (max is 50)
      for (var i = 0; i < 52; i++) {
        repository.saveArticleCache('art-$i', {'id': 'art-$i'});
      }

      // The first two should be evicted
      expect(repository.getArticleCache('art-0'), isNull);
      expect(repository.getArticleCache('art-1'), isNull);

      // The last ones should still be there
      expect(repository.getArticleCache('art-51'), isNotNull);
      expect(repository.getArticleCache('art-50'), isNotNull);
    });

    test('should not evict when under max', () {
      for (var i = 0; i < 10; i++) {
        repository.saveArticleCache('art-$i', {'id': 'art-$i'});
      }

      for (var i = 0; i < 10; i++) {
        expect(repository.getArticleCache('art-$i'), isNotNull);
      }
    });
  });

  group('DetailCacheRepository - Clear All', () {
    test('should clear all caches', () {
      repository.saveArticleCache('art-1', {'id': 'art-1'});
      repository.saveDirectoryCache('dir-1', {'id': 'dir-1'});
      repository.saveInheritorCache('inh-1', {'id': 'inh-1'});

      repository.clearAll();

      expect(repository.getArticleCache('art-1'), isNull);
      expect(repository.getDirectoryCache('dir-1'), isNull);
      expect(repository.getInheritorCache('inh-1'), isNull);
    });
  });

  group('DetailCacheRepository - Corrupted Data', () {
    test('should handle corrupted cache gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'detail_cache_article_corrupted': 'not valid json{{{',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = DetailCacheRepository(prefs: prefs);

      expect(repo.getArticleCache('corrupted'), isNull);
    });
  });
}
