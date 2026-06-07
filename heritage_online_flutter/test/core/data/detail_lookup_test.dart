import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

void main() {
  group('ArticleDetailLookup', () {
    test('should create with articleId', () {
      const lookup = ArticleDetailLookup(articleId: 'article-123');
      expect(lookup.articleId, 'article-123');
      expect(lookup.sourceId, isNull);
      expect(lookup.sourceUrl, isNull);
      expect(lookup.category, ArticleCategory.news);
    });

    test('should create with sourceId', () {
      const lookup = ArticleDetailLookup(sourceId: 'source-123');
      expect(lookup.articleId, isNull);
      expect(lookup.sourceId, 'source-123');
      expect(lookup.sourceUrl, isNull);
    });

    test('should create with sourceUrl', () {
      const lookup = ArticleDetailLookup(sourceUrl: 'https://example.com');
      expect(lookup.articleId, isNull);
      expect(lookup.sourceId, isNull);
      expect(lookup.sourceUrl, 'https://example.com');
    });

    test('should create with custom category', () {
      const lookup = ArticleDetailLookup(
        articleId: 'article-123',
        category: ArticleCategory.specialTopic,
      );
      expect(lookup.category, ArticleCategory.specialTopic);
    });

    test('isValid should return true with articleId', () {
      const lookup = ArticleDetailLookup(articleId: 'article-123');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return true with sourceId', () {
      const lookup = ArticleDetailLookup(sourceId: 'source-123');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return true with sourceUrl', () {
      const lookup = ArticleDetailLookup(sourceUrl: 'https://example.com');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return false with no keys', () {
      const lookup = ArticleDetailLookup();
      expect(lookup.isValid, isFalse);
    });

    test('isValid should return false with empty articleId', () {
      const lookup = ArticleDetailLookup(articleId: '');
      expect(lookup.isValid, isFalse);
    });

    test('isValid should return false with empty sourceId', () {
      const lookup = ArticleDetailLookup(sourceId: '');
      expect(lookup.isValid, isFalse);
    });

    test('equality should work correctly', () {
      const lookup1 = ArticleDetailLookup(articleId: 'article-123');
      const lookup2 = ArticleDetailLookup(articleId: 'article-123');
      const lookup3 = ArticleDetailLookup(articleId: 'article-456');

      expect(lookup1, equals(lookup2));
      expect(lookup1, isNot(equals(lookup3)));
    });

    test('hashCode should be consistent', () {
      const lookup1 = ArticleDetailLookup(articleId: 'article-123');
      const lookup2 = ArticleDetailLookup(articleId: 'article-123');

      expect(lookup1.hashCode, equals(lookup2.hashCode));
    });

    test('toString should include all fields', () {
      const lookup = ArticleDetailLookup(
        articleId: 'article-123',
        sourceId: 'source-123',
        category: ArticleCategory.forum,
      );
      final str = lookup.toString();
      expect(str, contains('articleId: article-123'));
      expect(str, contains('sourceId: source-123'));
      expect(str, contains('category: ArticleCategory.forum'));
    });
  });

  group('DirectoryDetailLookup', () {
    test('should create with itemId', () {
      const lookup = DirectoryDetailLookup(itemId: 'dir-123');
      expect(lookup.itemId, 'dir-123');
      expect(lookup.sourceId, isNull);
      expect(lookup.kind, DirectoryItemKind.nationalProject);
    });

    test('should create with sourceId', () {
      const lookup = DirectoryDetailLookup(sourceId: 'source-123');
      expect(lookup.itemId, isNull);
      expect(lookup.sourceId, 'source-123');
    });

    test('should create with custom kind', () {
      const lookup = DirectoryDetailLookup(
        itemId: 'dir-123',
        kind: DirectoryItemKind.unescoEntry,
      );
      expect(lookup.kind, DirectoryItemKind.unescoEntry);
    });

    test('isValid should return true with itemId', () {
      const lookup = DirectoryDetailLookup(itemId: 'dir-123');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return true with sourceId', () {
      const lookup = DirectoryDetailLookup(sourceId: 'source-123');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return false with no keys', () {
      const lookup = DirectoryDetailLookup();
      expect(lookup.isValid, isFalse);
    });

    test('isValid should return false with empty itemId', () {
      const lookup = DirectoryDetailLookup(itemId: '');
      expect(lookup.isValid, isFalse);
    });

    test('isValid should return false with empty sourceId', () {
      const lookup = DirectoryDetailLookup(sourceId: '');
      expect(lookup.isValid, isFalse);
    });

    test('equality should work correctly', () {
      const lookup1 = DirectoryDetailLookup(itemId: 'dir-123');
      const lookup2 = DirectoryDetailLookup(itemId: 'dir-123');
      const lookup3 = DirectoryDetailLookup(itemId: 'dir-456');

      expect(lookup1, equals(lookup2));
      expect(lookup1, isNot(equals(lookup3)));
    });

    test('hashCode should be consistent', () {
      const lookup1 = DirectoryDetailLookup(itemId: 'dir-123');
      const lookup2 = DirectoryDetailLookup(itemId: 'dir-123');

      expect(lookup1.hashCode, equals(lookup2.hashCode));
    });

    test('toString should include all fields', () {
      const lookup = DirectoryDetailLookup(
        itemId: 'dir-123',
        sourceId: 'source-123',
        kind: DirectoryItemKind.culturalEcoZone,
      );
      final str = lookup.toString();
      expect(str, contains('itemId: dir-123'));
      expect(str, contains('sourceId: source-123'));
      expect(str, contains('kind: DirectoryItemKind.culturalEcoZone'));
    });
  });

  group('InheritorDetailLookup', () {
    test('should create with inheritorId', () {
      const lookup = InheritorDetailLookup(inheritorId: 'inh-123');
      expect(lookup.inheritorId, 'inh-123');
      expect(lookup.sourceId, isNull);
    });

    test('should create with sourceId', () {
      const lookup = InheritorDetailLookup(sourceId: 'source-123');
      expect(lookup.inheritorId, isNull);
      expect(lookup.sourceId, 'source-123');
    });

    test('isValid should return true with inheritorId', () {
      const lookup = InheritorDetailLookup(inheritorId: 'inh-123');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return true with sourceId', () {
      const lookup = InheritorDetailLookup(sourceId: 'source-123');
      expect(lookup.isValid, isTrue);
    });

    test('isValid should return false with no keys', () {
      const lookup = InheritorDetailLookup();
      expect(lookup.isValid, isFalse);
    });

    test('isValid should return false with empty inheritorId', () {
      const lookup = InheritorDetailLookup(inheritorId: '');
      expect(lookup.isValid, isFalse);
    });

    test('isValid should return false with empty sourceId', () {
      const lookup = InheritorDetailLookup(sourceId: '');
      expect(lookup.isValid, isFalse);
    });

    test('equality should work correctly', () {
      const lookup1 = InheritorDetailLookup(inheritorId: 'inh-123');
      const lookup2 = InheritorDetailLookup(inheritorId: 'inh-123');
      const lookup3 = InheritorDetailLookup(inheritorId: 'inh-456');

      expect(lookup1, equals(lookup2));
      expect(lookup1, isNot(equals(lookup3)));
    });

    test('hashCode should be consistent', () {
      const lookup1 = InheritorDetailLookup(inheritorId: 'inh-123');
      const lookup2 = InheritorDetailLookup(inheritorId: 'inh-123');

      expect(lookup1.hashCode, equals(lookup2.hashCode));
    });

    test('toString should include all fields', () {
      const lookup = InheritorDetailLookup(
        inheritorId: 'inh-123',
        sourceId: 'source-123',
      );
      final str = lookup.toString();
      expect(str, contains('inheritorId: inh-123'));
      expect(str, contains('sourceId: source-123'));
    });
  });
}
