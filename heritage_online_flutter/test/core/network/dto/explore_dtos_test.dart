import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/explore_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/learning_path_dtos.dart';

void main() {
  group('ExploreTopicInfoDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'type': 'category',
        'key': 'traditional-crafts',
        'title': '传统技艺',
        'subtitle': '非遗传统技艺类项目',
      };

      final dto = ExploreTopicInfoDto.fromJson(json);

      expect(dto.type, 'category');
      expect(dto.key, 'traditional-crafts');
      expect(dto.title, '传统技艺');
      expect(dto.subtitle, '非遗传统技艺类项目');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreTopicInfoDto.fromJson(json);

      expect(dto.type, isNull);
      expect(dto.key, isNull);
      expect(dto.title, isNull);
      expect(dto.subtitle, isNull);
    });
  });

  group('ExploreTopicItemDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'item-123',
        'type': 'article',
        'title': '文章标题',
        'summary': '摘要',
        'category': 'news',
        'region': '北京',
        'year': 2024,
        'count': 10,
      };

      final dto = ExploreTopicItemDto.fromJson(json);

      expect(dto.id, 'item-123');
      expect(dto.type, 'article');
      expect(dto.title, '文章标题');
      expect(dto.summary, '摘要');
      expect(dto.category, 'news');
      expect(dto.region, '北京');
      expect(dto.year, 2024);
      expect(dto.count, 10);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreTopicItemDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.type, isNull);
      expect(dto.title, isNull);
    });
  });

  group('ExploreTopicSectionDto', () {
    test('should parse from JSON with items', () {
      final json = {
        'id': 'section-1',
        'title': '精选文章',
        'subtitle': '推荐阅读',
        'items': [
          {'id': 'item-1', 'title': '文章1'},
          {'id': 'item-2', 'title': '文章2'},
        ],
      };

      final dto = ExploreTopicSectionDto.fromJson(json);

      expect(dto.id, 'section-1');
      expect(dto.title, '精选文章');
      expect(dto.items.length, 2);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreTopicSectionDto.fromJson(json);

      expect(dto.items, isEmpty);
    });
  });

  group('ExploreTopicStatDto', () {
    test('should parse from JSON', () {
      final json = {
        'name': '文章数',
        'value': 42,
      };

      final dto = ExploreTopicStatDto.fromJson(json);

      expect(dto.name, '文章数');
      expect(dto.value, 42);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreTopicStatDto.fromJson(json);

      expect(dto.name, isNull);
      expect(dto.value, 0);
    });
  });

  group('ExploreTopicV2Dto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'topic': {'type': 'category', 'key': 'crafts', 'title': '技艺'},
        'stats': [
          {'name': '文章', 'value': 10},
        ],
        'sections': [
          {'title': '精选', 'items': []},
        ],
        'relatedTopics': [
          {'type': 'category', 'key': 'music', 'title': '音乐'},
        ],
        'timeline': [],
        'generatedAt': '2024-01-15',
      };

      final dto = ExploreTopicV2Dto.fromJson(json);

      expect(dto.topic, isNotNull);
      expect(dto.topic!.title, '技艺');
      expect(dto.stats.length, 1);
      expect(dto.sections.length, 1);
      expect(dto.relatedTopics.length, 1);
      expect(dto.generatedAt, '2024-01-15');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreTopicV2Dto.fromJson(json);

      expect(dto.topic, isNull);
      expect(dto.stats, isEmpty);
      expect(dto.sections, isEmpty);
      expect(dto.relatedTopics, isEmpty);
    });
  });

  group('ExploreIndexDto', () {
    test('should parse from JSON', () {
      final json = {
        'regions': [
          {'type': 'region', 'key': 'beijing', 'title': '北京'},
        ],
        'categories': [
          {'type': 'category', 'key': 'crafts', 'title': '技艺'},
        ],
        'years': [
          {'type': 'year', 'key': '2024', 'title': '2024年'},
        ],
      };

      final dto = ExploreIndexDto.fromJson(json);

      expect(dto.regions.length, 1);
      expect(dto.categories.length, 1);
      expect(dto.years.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ExploreIndexDto.fromJson(json);

      expect(dto.regions, isEmpty);
      expect(dto.categories, isEmpty);
      expect(dto.years, isEmpty);
    });
  });

  group('LearningPathStepDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'step-1',
        'title': '了解基础',
        'subtitle': '非遗入门知识',
        'topic': {'type': 'category', 'key': 'basics'},
        'items': [
          {'id': 'item-1', 'title': '文章1'},
        ],
      };

      final dto = LearningPathStepDto.fromJson(json);

      expect(dto.id, 'step-1');
      expect(dto.title, '了解基础');
      expect(dto.subtitle, '非遗入门知识');
      expect(dto.topic, isNotNull);
      expect(dto.items.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = LearningPathStepDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.items, isEmpty);
    });
  });

  group('LearningPathDto', () {
    test('should parse from JSON', () {
      final json = {
        'id': 'path-1',
        'title': '非遗入门路径',
        'subtitle': '从零开始了解非遗',
        'topics': [
          {'type': 'category', 'key': 'crafts', 'title': '技艺'},
        ],
      };

      final dto = LearningPathDto.fromJson(json);

      expect(dto.id, 'path-1');
      expect(dto.title, '非遗入门路径');
      expect(dto.topics.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = LearningPathDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.topics, isEmpty);
    });
  });

  group('LearningPathDetailDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'path-1',
        'title': '非遗入门路径',
        'subtitle': '从零开始',
        'description': '详细介绍...',
        'tags': ['入门', '基础'],
        'steps': [
          {'id': 'step-1', 'title': '第一步'},
        ],
        'featuredItems': [
          {'id': 'item-1', 'title': '精选'},
        ],
        'relatedTopics': [
          {'type': 'category', 'key': 'music'},
        ],
        'generatedAt': '2024-01-15',
      };

      final dto = LearningPathDetailDto.fromJson(json);

      expect(dto.id, 'path-1');
      expect(dto.title, '非遗入门路径');
      expect(dto.tags.length, 2);
      expect(dto.steps.length, 1);
      expect(dto.featuredItems.length, 1);
      expect(dto.relatedTopics.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = LearningPathDetailDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.tags, isEmpty);
      expect(dto.steps, isEmpty);
      expect(dto.featuredItems, isEmpty);
      expect(dto.relatedTopics, isEmpty);
    });
  });
}
