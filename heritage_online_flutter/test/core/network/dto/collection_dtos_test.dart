import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';

void main() {
  group('FeaturedCollectionDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'latest-news',
        'title': '最新新闻',
        'subtitle': '近期非遗新闻报道',
        'itemCount': 25,
      };

      final dto = FeaturedCollectionDto.fromJson(json);

      expect(dto.id, 'latest-news');
      expect(dto.title, '最新新闻');
      expect(dto.subtitle, '近期非遗新闻报道');
      expect(dto.itemCount, 25);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = FeaturedCollectionDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.title, isNull);
      expect(dto.subtitle, isNull);
      expect(dto.itemCount, 0);
    });

    test('should serialize to JSON', () {
      const dto = FeaturedCollectionDto(
        id: 'featured-inheritors',
        title: '精选传承人',
        itemCount: 10,
      );

      final json = dto.toJson();

      expect(json['id'], 'featured-inheritors');
      expect(json['title'], '精选传承人');
      expect(json['itemCount'], 10);
    });
  });

  group('CollectionItemDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'art-001',
        'type': 'article',
        'title': '非遗保护新举措',
        'summary': '关于非遗保护的最新政策',
        'category': 'news',
        'region': '北京',
        'publishedAt': '2024-06-15',
        'publishedYear': 2024,
        'coverImage': {
          'displayUrl': 'https://example.com/image.jpg',
        },
        'sourceUrl': 'https://example.com/article',
        'sourceId': 'src-001',
        'kind': 'nationalProject',
      };

      final dto = CollectionItemDto.fromJson(json);

      expect(dto.id, 'art-001');
      expect(dto.type, 'article');
      expect(dto.title, '非遗保护新举措');
      expect(dto.summary, '关于非遗保护的最新政策');
      expect(dto.category, 'news');
      expect(dto.region, '北京');
      expect(dto.publishedAt, '2024-06-15');
      expect(dto.publishedYear, 2024);
      expect(dto.coverImage, isNotNull);
      expect(dto.sourceUrl, 'https://example.com/article');
      expect(dto.sourceId, 'src-001');
      expect(dto.kind, 'nationalProject');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = CollectionItemDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.type, isNull);
      expect(dto.title, isNull);
      expect(dto.summary, isNull);
      expect(dto.category, isNull);
      expect(dto.region, isNull);
      expect(dto.publishedAt, isNull);
      expect(dto.publishedYear, isNull);
      expect(dto.coverImage, isNull);
      expect(dto.sourceUrl, isNull);
      expect(dto.sourceId, isNull);
      expect(dto.kind, isNull);
    });

    test('should handle directoryItem type', () {
      final json = {
        'id': 'dir-001',
        'type': 'directoryItem',
        'title': '昆曲',
        'kind': 'unescoEntry',
      };

      final dto = CollectionItemDto.fromJson(json);

      expect(dto.type, 'directoryItem');
      expect(dto.kind, 'unescoEntry');
    });

    test('should handle inheritor type', () {
      final json = {
        'id': 'inh-001',
        'type': 'inheritor',
        'title': '张三',
        'region': '四川',
      };

      final dto = CollectionItemDto.fromJson(json);

      expect(dto.type, 'inheritor');
      expect(dto.title, '张三');
    });
  });

  group('CollectionDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'national-projects',
        'title': '国家级项目精选',
        'subtitle': '代表性国家级非遗项目',
        'type': 'featured',
        'tags': ['国家级', '精选'],
        'generatedAt': '2024-01-15',
        'items': [
          {
            'id': 'dir-1',
            'type': 'directoryItem',
            'title': '昆曲',
          },
          {
            'id': 'art-1',
            'type': 'article',
            'title': '昆曲保护报道',
          },
        ],
      };

      final dto = CollectionDto.fromJson(json);

      expect(dto.id, 'national-projects');
      expect(dto.title, '国家级项目精选');
      expect(dto.subtitle, '代表性国家级非遗项目');
      expect(dto.type, 'featured');
      expect(dto.tags.length, 2);
      expect(dto.tags[0], '国家级');
      expect(dto.generatedAt, '2024-01-15');
      expect(dto.items.length, 2);
      expect(dto.items[0].type, 'directoryItem');
      expect(dto.items[1].type, 'article');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = CollectionDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.title, isNull);
      expect(dto.subtitle, isNull);
      expect(dto.type, isNull);
      expect(dto.tags, isEmpty);
      expect(dto.generatedAt, isNull);
      expect(dto.items, isEmpty);
    });

    test('should handle empty items', () {
      final json = {
        'id': 'empty-collection',
        'title': '空合集',
        'items': [],
      };

      final dto = CollectionDto.fromJson(json);

      expect(dto.items, isEmpty);
    });

    test('should round-trip through JSON', () {
      final original = CollectionDto(
        id: 'test-collection',
        title: '测试合集',
        tags: ['tag1', 'tag2'],
        items: [
          CollectionItemDto(id: '1', type: 'article', title: '文章1'),
          CollectionItemDto(id: '2', type: 'directoryItem', title: '名录1'),
        ],
      );

      final jsonMap =
          jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = CollectionDto.fromJson(jsonMap);

      expect(restored.id, 'test-collection');
      expect(restored.title, '测试合集');
      expect(restored.tags.length, 2);
      expect(restored.items.length, 2);
      expect(restored.items[0].type, 'article');
      expect(restored.items[1].type, 'directoryItem');
    });
  });
}
