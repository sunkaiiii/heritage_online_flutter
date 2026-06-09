import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/timeline_dtos.dart';

void main() {
  group('TimelineItemDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'item-001',
        'type': 'article',
        'title': '非遗传承人访谈',
        'summary': '关于传统技艺的深度报道',
        'category': 'news',
        'kind': 'nationalProject',
        'region': '北京',
        'date': '2024-06-15',
        'year': 2024,
        'coverImage': {
          'displayUrl': 'https://example.com/image.jpg',
          'thumbnailUrl': 'https://example.com/thumb.jpg',
        },
        'sourceUrl': 'https://example.com/article',
        'sourceId': 'src-001',
      };

      final dto = TimelineItemDto.fromJson(json);

      expect(dto.id, 'item-001');
      expect(dto.type, 'article');
      expect(dto.title, '非遗传承人访谈');
      expect(dto.summary, '关于传统技艺的深度报道');
      expect(dto.category, 'news');
      expect(dto.kind, 'nationalProject');
      expect(dto.region, '北京');
      expect(dto.date, '2024-06-15');
      expect(dto.year, 2024);
      expect(dto.coverImage, isNotNull);
      expect(dto.coverImage!.displayUrl, 'https://example.com/image.jpg');
      expect(dto.sourceUrl, 'https://example.com/article');
      expect(dto.sourceId, 'src-001');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = TimelineItemDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.type, isNull);
      expect(dto.title, isNull);
      expect(dto.summary, isNull);
      expect(dto.category, isNull);
      expect(dto.kind, isNull);
      expect(dto.region, isNull);
      expect(dto.date, isNull);
      expect(dto.year, isNull);
      expect(dto.coverImage, isNull);
      expect(dto.sourceUrl, isNull);
      expect(dto.sourceId, isNull);
    });

    test('should handle directoryItem type', () {
      final json = {
        'id': 'dir-001',
        'type': 'directoryItem',
        'title': '昆曲',
        'category': 'traditionalOpera',
        'kind': 'unescoEntry',
        'region': '江苏',
        'year': 2001,
      };

      final dto = TimelineItemDto.fromJson(json);

      expect(dto.type, 'directoryItem');
      expect(dto.kind, 'unescoEntry');
    });

    test('should handle inheritor type', () {
      final json = {
        'id': 'inh-001',
        'type': 'inheritor',
        'title': '张三',
        'region': '四川',
        'year': 1960,
      };

      final dto = TimelineItemDto.fromJson(json);

      expect(dto.type, 'inheritor');
      expect(dto.title, '张三');
    });

    test('should serialize to JSON', () {
      const dto = TimelineItemDto(
        id: 'item-001',
        type: 'article',
        title: '测试文章',
        year: 2024,
      );

      final json = dto.toJson();

      expect(json['id'], 'item-001');
      expect(json['type'], 'article');
      expect(json['title'], '测试文章');
      expect(json['year'], 2024);
    });
  });

  group('TimelineYearBucketDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'year': 2024,
        'total': 150,
        'articleCount': 80,
        'directoryItemCount': 40,
        'inheritorCount': 30,
      };

      final dto = TimelineYearBucketDto.fromJson(json);

      expect(dto.year, 2024);
      expect(dto.total, 150);
      expect(dto.articleCount, 80);
      expect(dto.directoryItemCount, 40);
      expect(dto.inheritorCount, 30);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = TimelineYearBucketDto.fromJson(json);

      expect(dto.year, 0);
      expect(dto.total, 0);
      expect(dto.articleCount, 0);
      expect(dto.directoryItemCount, 0);
      expect(dto.inheritorCount, 0);
    });

    test('should serialize to JSON', () {
      const dto = TimelineYearBucketDto(
        year: 2023,
        total: 100,
        articleCount: 50,
        directoryItemCount: 30,
        inheritorCount: 20,
      );

      final json = dto.toJson();

      expect(json['year'], 2023);
      expect(json['total'], 100);
      expect(json['articleCount'], 50);
      expect(json['directoryItemCount'], 30);
      expect(json['inheritorCount'], 20);
    });
  });

  group('TimelineV2FacetsDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'types': [
          {'key': 'article', 'count': 50},
          {'key': 'directoryItem', 'count': 30},
        ],
        'categories': [
          {'key': 'news', 'count': 20},
        ],
        'regions': [
          {'key': '北京', 'count': 15},
        ],
        'kinds': [
          {'key': 'nationalProject', 'count': 10},
        ],
      };

      final dto = TimelineV2FacetsDto.fromJson(json);

      expect(dto.types.length, 2);
      expect(dto.types[0].key, 'article');
      expect(dto.types[0].count, 50);
      expect(dto.categories.length, 1);
      expect(dto.regions.length, 1);
      expect(dto.kinds.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = TimelineV2FacetsDto.fromJson(json);

      expect(dto.types, isEmpty);
      expect(dto.categories, isEmpty);
      expect(dto.regions, isEmpty);
      expect(dto.kinds, isEmpty);
    });
  });

  group('TimelineV2ResponseDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'items': [
          {'id': 'item-1', 'title': '文章1', 'type': 'article'},
          {'id': 'item-2', 'title': '名录1', 'type': 'directoryItem'},
        ],
        'page': 1,
        'pageSize': 20,
        'hasMore': true,
        'total': 50,
        'facets': {
          'types': [
            {'key': 'article', 'count': 25},
          ],
        },
      };

      final dto = TimelineV2ResponseDto.fromJson(json);

      expect(dto.items.length, 2);
      expect(dto.items[0].id, 'item-1');
      expect(dto.items[1].type, 'directoryItem');
      expect(dto.page, 1);
      expect(dto.pageSize, 20);
      expect(dto.hasMore, true);
      expect(dto.total, 50);
      expect(dto.facets, isNotNull);
      expect(dto.facets!.types.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = TimelineV2ResponseDto.fromJson(json);

      expect(dto.items, isEmpty);
      expect(dto.page, 1);
      expect(dto.pageSize, 20);
      expect(dto.hasMore, false);
      expect(dto.total, 0);
      expect(dto.facets, isNull);
    });

    test('should handle empty items list', () {
      final json = {
        'items': [],
        'hasMore': false,
        'total': 0,
      };

      final dto = TimelineV2ResponseDto.fromJson(json);

      expect(dto.items, isEmpty);
      expect(dto.hasMore, false);
    });

    test('should serialize to JSON', () {
      const dto = TimelineV2ResponseDto(
        items: [
          TimelineItemDto(id: '1', title: 'test'),
        ],
        page: 2,
        hasMore: true,
        total: 40,
      );

      final json = dto.toJson();

      expect(json['page'], 2);
      expect(json['hasMore'], true);
      expect(json['total'], 40);
    });
  });
}
