import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

import 'fake_heritage_repository.dart';

void main() {
  late FakeHeritageRepository repository;

  setUp(() {
    repository = FakeHeritageRepository();
  });

  group('HeritageRepository', () {
    group('ArticleDetailLookup priority', () {
      test('should use articleId when provided', () async {
        const lookup = ArticleDetailLookup(articleId: 'article-123');
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'article-123');
      });

      test('should use sourceId when articleId is null', () async {
        const lookup = ArticleDetailLookup(sourceId: 'source-123');
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'source:source-123');
      });

      test('should use sourceUrl when articleId and sourceId are null', () async {
        const lookup = ArticleDetailLookup(sourceUrl: 'https://example.com');
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'url:https://example.com');
      });

      test('should prioritize articleId over sourceId', () async {
        const lookup = ArticleDetailLookup(
          articleId: 'article-123',
          sourceId: 'source-123',
        );
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'article-123');
      });

      test('should prioritize articleId over sourceUrl', () async {
        const lookup = ArticleDetailLookup(
          articleId: 'article-123',
          sourceUrl: 'https://example.com',
        );
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'article-123');
      });

      test('should prioritize sourceId over sourceUrl', () async {
        const lookup = ArticleDetailLookup(
          sourceId: 'source-123',
          sourceUrl: 'https://example.com',
        );
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'source:source-123');
      });

      test('should throw for invalid lookup', () async {
        const lookup = ArticleDetailLookup();

        expect(
          () => repository.articleDetail(lookup),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should use custom category', () async {
        const lookup = ArticleDetailLookup(
          sourceId: 'source-123',
          category: ArticleCategory.specialTopic,
        );
        final result = await repository.articleDetail(lookup);

        expect(result.id, 'source:source-123');
      });
    });

    group('DirectoryDetailLookup priority', () {
      test('should use itemId when provided', () async {
        const lookup = DirectoryDetailLookup(itemId: 'dir-123');
        final result = await repository.directoryItemDetail(lookup);

        expect(result.id, 'dir-123');
      });

      test('should use sourceId when itemId is null', () async {
        const lookup = DirectoryDetailLookup(sourceId: 'source-123');
        final result = await repository.directoryItemDetail(lookup);

        expect(result.id, 'source:source-123');
      });

      test('should prioritize itemId over sourceId', () async {
        const lookup = DirectoryDetailLookup(
          itemId: 'dir-123',
          sourceId: 'source-123',
        );
        final result = await repository.directoryItemDetail(lookup);

        expect(result.id, 'dir-123');
      });

      test('should throw for invalid lookup', () async {
        const lookup = DirectoryDetailLookup();

        expect(
          () => repository.directoryItemDetail(lookup),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should use custom kind', () async {
        const lookup = DirectoryDetailLookup(
          sourceId: 'source-123',
          kind: DirectoryItemKind.unescoEntry,
        );
        final result = await repository.directoryItemDetail(lookup);

        expect(result.id, 'source:source-123');
      });
    });

    group('InheritorDetailLookup priority', () {
      test('should use inheritorId when provided', () async {
        const lookup = InheritorDetailLookup(inheritorId: 'inh-123');
        final result = await repository.inheritorDetail(lookup);

        expect(result.id, 'inh-123');
      });

      test('should use sourceId when inheritorId is null', () async {
        const lookup = InheritorDetailLookup(sourceId: 'source-123');
        final result = await repository.inheritorDetail(lookup);

        expect(result.id, 'source:source-123');
      });

      test('should prioritize inheritorId over sourceId', () async {
        const lookup = InheritorDetailLookup(
          inheritorId: 'inh-123',
          sourceId: 'source-123',
        );
        final result = await repository.inheritorDetail(lookup);

        expect(result.id, 'inh-123');
      });

      test('should throw for invalid lookup', () async {
        const lookup = InheritorDetailLookup();

        expect(
          () => repository.inheritorDetail(lookup),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Repository error handling', () {
      test('should throw error when shouldThrow is true', () async {
        repository.shouldThrow = true;
        repository.mockError = Exception('Test error');

        expect(
          () => repository.article('article-123'),
          throwsA(isA<Exception>()),
        );
      });

      test('should not throw error when shouldThrow is false', () async {
        repository.shouldThrow = false;

        final result = await repository.article('article-123');
        expect(result.id, 'article-123');
      });
    });

    group('Repository cache', () {
      test('should return cached article when available', () async {
        repository.setArticleDetail(
          'cached-123',
          const ArticleDetailDto(id: 'cached-123', title: 'Cached Article'),
        );

        final result = await repository.article('cached-123');
        expect(result.title, 'Cached Article');
      });

      test('should return default when not cached', () async {
        final result = await repository.article('not-cached');
        expect(result.title, 'Test Article not-cached');
      });

      test('should return cached directory when available', () async {
        repository.setDirectoryDetail(
          'cached-dir',
          const DirectoryItemDetailDto(id: 'cached-dir', title: 'Cached Directory'),
        );

        final result = await repository.directoryItem('cached-dir');
        expect(result.title, 'Cached Directory');
      });

      test('should return cached inheritor when available', () async {
        repository.setInheritorDetail(
          'cached-inh',
          const InheritorDetailDto(id: 'cached-inh', name: 'Cached Inheritor'),
        );

        final result = await repository.inheritor('cached-inh');
        expect(result.name, 'Cached Inheritor');
      });
    });

    group('Repository interface compliance', () {
      test('should implement all required methods', () {
        expect(repository.homeBanners, isNotNull);
        expect(repository.homeFeed, isNotNull);
        expect(repository.articles, isNotNull);
        expect(repository.article, isNotNull);
        expect(repository.articleBySourceId, isNotNull);
        expect(repository.articleBySourceUrl, isNotNull);
        expect(repository.articleDetail, isNotNull);
        expect(repository.directoryItems, isNotNull);
        expect(repository.directoryItem, isNotNull);
        expect(repository.directoryItemBySourceId, isNotNull);
        expect(repository.directoryItemDetail, isNotNull);
        expect(repository.directoryStatisticsOverview, isNotNull);
        expect(repository.directoryStatisticsBreakdown, isNotNull);
        expect(repository.inheritors, isNotNull);
        expect(repository.inheritor, isNotNull);
        expect(repository.inheritorBySourceId, isNotNull);
        expect(repository.inheritorDetail, isNotNull);
      });
    });
  });
}
