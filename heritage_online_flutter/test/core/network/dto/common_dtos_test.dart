import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';

void main() {
  group('PagedResult', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'items': [1, 2, 3],
        'page': 2,
        'pageSize': 10,
        'hasMore': true,
        'total': 100,
      };

      final result = PagedResult.fromJson(json, (json) => json as int);

      expect(result.items, [1, 2, 3]);
      expect(result.page, 2);
      expect(result.pageSize, 10);
      expect(result.hasMore, isTrue);
      expect(result.total, 100);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final result = PagedResult.fromJson(json, (json) => json as int);

      expect(result.items, isEmpty);
      expect(result.page, 1);
      expect(result.pageSize, 20);
      expect(result.hasMore, isFalse);
      expect(result.total, 0);
    });

    test('should handle empty items list', () {
      final json = {
        'items': [],
        'page': 1,
        'pageSize': 20,
        'hasMore': false,
        'total': 0,
      };

      final result = PagedResult.fromJson(json, (json) => json as int);

      expect(result.items, isEmpty);
    });
  });

  group('MediaAssetDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'sourceUrl': 'https://example.com/source.jpg',
        'originalUrl': 'https://example.com/original.jpg',
        'displayUrl': 'https://example.com/display.jpg',
        'thumbnailUrl': 'https://example.com/thumb.jpg',
        'altText': 'Test image',
      };

      final dto = MediaAssetDto.fromJson(json);

      expect(dto.sourceUrl, 'https://example.com/source.jpg');
      expect(dto.originalUrl, 'https://example.com/original.jpg');
      expect(dto.displayUrl, 'https://example.com/display.jpg');
      expect(dto.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(dto.altText, 'Test image');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = MediaAssetDto.fromJson(json);

      expect(dto.sourceUrl, isNull);
      expect(dto.originalUrl, isNull);
      expect(dto.displayUrl, isNull);
      expect(dto.thumbnailUrl, isNull);
      expect(dto.altText, isNull);
    });

    test('bestUrl should return displayUrl first', () {
      const dto = MediaAssetDto(
        sourceUrl: 'source',
        originalUrl: 'original',
        displayUrl: 'display',
        thumbnailUrl: 'thumb',
      );

      expect(dto.bestUrl, 'display');
    });

    test('bestUrl should fallback to thumbnailUrl', () {
      const dto = MediaAssetDto(
        sourceUrl: 'source',
        originalUrl: 'original',
        thumbnailUrl: 'thumb',
      );

      expect(dto.bestUrl, 'thumb');
    });

    test('bestUrl should fallback to sourceUrl when only sourceUrl set', () {
      const dto = MediaAssetDto(
        sourceUrl: 'source',
      );

      expect(dto.bestUrl, 'source');
    });

    test('thumbnailOrMainUrl should return thumbnailUrl first', () {
      const dto = MediaAssetDto(
        sourceUrl: 'source',
        thumbnailUrl: 'thumb',
      );

      expect(dto.thumbnailOrMainUrl, 'thumb');
    });

    test('thumbnailOrMainUrl should fallback to bestUrl', () {
      const dto = MediaAssetDto(
        sourceUrl: 'source',
      );

      expect(dto.thumbnailOrMainUrl, 'source');
    });
  });

  group('ProblemDetailsDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'type': 'https://example.com/errors/not-found',
        'title': 'Not Found',
        'status': 404,
        'detail': 'The resource was not found',
        'instance': '/api/articles/123',
      };

      final dto = ProblemDetailsDto.fromJson(json);

      expect(dto.type, 'https://example.com/errors/not-found');
      expect(dto.title, 'Not Found');
      expect(dto.status, 404);
      expect(dto.detail, 'The resource was not found');
      expect(dto.instance, '/api/articles/123');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ProblemDetailsDto.fromJson(json);

      expect(dto.type, isNull);
      expect(dto.title, isNull);
      expect(dto.status, isNull);
      expect(dto.detail, isNull);
      expect(dto.instance, isNull);
    });
  });

  group('FacetBucketDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'key': '北京市',
        'count': 42,
      };

      final dto = FacetBucketDto.fromJson(json);

      expect(dto.key, '北京市');
      expect(dto.count, 42);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = FacetBucketDto.fromJson(json);

      expect(dto.key, isNull);
      expect(dto.count, 0);
    });
  });

  group('ExploreTopicLinkDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'type': 'category',
        'key': 'traditional-crafts',
        'title': '传统技艺',
      };

      final dto = ExploreTopicLinkDto.fromJson(json);

      expect(dto.type, 'category');
      expect(dto.key, 'traditional-crafts');
      expect(dto.title, '传统技艺');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreTopicLinkDto.fromJson(json);

      expect(dto.type, isNull);
      expect(dto.key, isNull);
      expect(dto.title, isNull);
    });
  });
}
