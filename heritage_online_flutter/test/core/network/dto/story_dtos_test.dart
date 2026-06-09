import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/story_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/taxonomy_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/compare_dtos.dart';

void main() {
  group('DataStoryDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'story-region-beijing',
        'title': '北京非遗故事',
        'subtitle': '古都文化传承',
        'sections': [
          {
            'id': 's1',
            'title': '历史渊源',
            'type': 'narrative',
            'body': '正文内容...',
            'items': [
              {'type': 'article', 'id': 'a1', 'title': '相关文章'},
            ],
          },
        ],
        'relatedTopics': [
          {'type': 'category', 'key': 'crafts', 'title': '传统技艺'},
        ],
        'generatedAt': '2024-01-15',
      };

      final dto = DataStoryDto.fromJson(json);

      expect(dto.id, 'story-region-beijing');
      expect(dto.title, '北京非遗故事');
      expect(dto.subtitle, '古都文化传承');
      expect(dto.sections.length, 1);
      expect(dto.sections[0].body, '正文内容...');
      expect(dto.sections[0].items.length, 1);
      expect(dto.relatedTopics.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = DataStoryDto.fromJson(json);
      expect(dto.id, '');
      expect(dto.sections, isEmpty);
      expect(dto.relatedTopics, isEmpty);
    });

    test('should round-trip through JSON', () {
      final original = DataStoryDto(
        id: 'test',
        title: '测试故事',
        sections: [
          DataStorySectionDto(id: 's1', title: '区块1', type: 'narrative'),
        ],
      );

      final jsonMap =
          jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = DataStoryDto.fromJson(jsonMap);

      expect(restored.id, 'test');
      expect(restored.sections.length, 1);
    });
  });

  group('DataStorySectionDto', () {
    test('should parse from JSON', () {
      final json = {
        'id': 's1',
        'title': '历史渊源',
        'type': 'narrative',
        'body': '正文',
        'items': [],
      };

      final dto = DataStorySectionDto.fromJson(json);

      expect(dto.id, 's1');
      expect(dto.title, '历史渊源');
      expect(dto.type, 'narrative');
      expect(dto.body, '正文');
    });
  });

  group('DataStoryItemDto', () {
    test('should parse from JSON', () {
      final json = {
        'type': 'article',
        'id': 'a1',
        'title': '文章标题',
        'summary': '摘要',
        'sourceUrl': 'https://example.com',
      };

      final dto = DataStoryItemDto.fromJson(json);

      expect(dto.type, 'article');
      expect(dto.id, 'a1');
      expect(dto.title, '文章标题');
    });
  });

  group('TaxonomyTopicDto', () {
    test('should parse from JSON', () {
      final json = {
        'type': 'category',
        'key': 'traditionalCrafts',
        'title': '传统技艺',
        'subtitle': '非遗传统技艺类项目',
        'directoryItemCount': 100,
        'inheritorCount': 50,
        'articleCount': 200,
        'total': 350,
        'topRegions': [
          {'region': '北京', 'count': 20},
        ],
        'topCategories': [
          {'category': 'news', 'count': 100},
        ],
      };

      final dto = TaxonomyTopicDto.fromJson(json);

      expect(dto.type, 'category');
      expect(dto.key, 'traditionalCrafts');
      expect(dto.title, '传统技艺');
      expect(dto.total, 350);
      expect(dto.topRegions.length, 1);
      expect(dto.topCategories.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = TaxonomyTopicDto.fromJson(json);
      expect(dto.type, '');
      expect(dto.total, 0);
      expect(dto.topRegions, isEmpty);
    });
  });

  group('TaxonomyKindDto', () {
    test('should parse from JSON', () {
      final json = {
        'key': 'nationalProject',
        'title': '国家级项目',
        'directoryItemCount': 500,
        'inheritorCount': 200,
        'total': 700,
      };

      final dto = TaxonomyKindDto.fromJson(json);

      expect(dto.key, 'nationalProject');
      expect(dto.title, '国家级项目');
      expect(dto.total, 700);
    });
  });

  group('TaxonomyIndexDto', () {
    test('should parse with TaxonomyTopicDto items', () {
      final json = {
        'items': [
          {'type': 'category', 'key': 'crafts', 'title': '技艺'},
        ],
        'generatedAt': '2024-01-15',
      };

      final dto = TaxonomyIndexDto.fromJson(
        json,
        (json) => TaxonomyTopicDto.fromJson(json as Map<String, dynamic>),
      );

      expect(dto.items.length, 1);
      expect(dto.items[0].title, '技艺');
    });
  });

  group('TaxonomyCategoryDetailDto', () {
    test('should parse from JSON', () {
      final json = {
        'topic': {'type': 'category', 'key': 'crafts', 'title': '技艺'},
        'stats': {
          'directoryItemCount': 100,
          'inheritorCount': 50,
          'articleCount': 200,
          'total': 350,
        },
        'topRegions': [
          {'region': '北京', 'count': 20},
        ],
        'articles': [
          {'id': 'a1', 'title': '文章1'},
        ],
        'directoryItems': [
          {'id': 'd1', 'title': '名录1'},
        ],
        'inheritors': [
          {'id': 'i1', 'name': '传承人1'},
        ],
      };

      final dto = TaxonomyCategoryDetailDto.fromJson(json);

      expect(dto.topic.title, '技艺');
      expect(dto.stats.total, 350);
      expect(dto.topRegions.length, 1);
      expect(dto.articles.length, 1);
      expect(dto.directoryItems.length, 1);
      expect(dto.inheritors.length, 1);
    });
  });

  group('CompareResultDto', () {
    test('should parse from JSON', () {
      final json = {
        'left': {
          'key': 'beijing',
          'title': '北京',
          'directoryItemCount': 100,
          'total': 150,
        },
        'right': {
          'key': 'shanghai',
          'title': '上海',
          'directoryItemCount': 80,
          'total': 120,
        },
        'summary': {
          'leftTotal': 150,
          'rightTotal': 120,
          'sharedCategoryCount': 5,
        },
        'sharedCategories': ['传统技艺', '传统音乐'],
        'leftUniqueCategories': ['传统戏剧'],
        'rightUniqueCategories': ['传统美术'],
        'sharedRegions': ['华东'],
        'leftUniqueRegions': ['华北'],
        'rightUniqueRegions': [],
      };

      final dto = CompareResultDto.fromJson(json);

      expect(dto.left.key, 'beijing');
      expect(dto.left.total, 150);
      expect(dto.right.key, 'shanghai');
      expect(dto.right.total, 120);
      expect(dto.summary.sharedCategoryCount, 5);
      expect(dto.sharedCategories.length, 2);
      expect(dto.leftUniqueCategories.length, 1);
      expect(dto.rightUniqueCategories.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = CompareResultDto.fromJson(json);
      expect(dto.left.key, '');
      expect(dto.right.key, '');
      expect(dto.sharedCategories, isEmpty);
    });

    test('should round-trip through JSON', () {
      final original = CompareResultDto(
        left: CompareSideDto(key: 'a', title: 'A', total: 100),
        right: CompareSideDto(key: 'b', title: 'B', total: 200),
        sharedCategories: ['cat1'],
      );

      final jsonMap =
          jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = CompareResultDto.fromJson(jsonMap);

      expect(restored.left.key, 'a');
      expect(restored.right.total, 200);
      expect(restored.sharedCategories, ['cat1']);
    });
  });
}
