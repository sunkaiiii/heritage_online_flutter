import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/compare_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/taxonomy_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/learning_path_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

void main() {
  group('CompareResultDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'left': {
          'key': 'beijing',
          'title': '北京',
          'directoryItemCount': 100,
          'inheritorCount': 50,
          'articleCount': 200,
          'total': 350,
          'topCategories': [
            {'category': 'news', 'count': 100},
          ],
          'topRegions': [
            {'region': '华北', 'count': 80},
          ],
        },
        'right': {
          'key': 'shanghai',
          'title': '上海',
          'directoryItemCount': 80,
          'total': 280,
        },
        'summary': {
          'leftTotal': 350,
          'rightTotal': 280,
          'sharedCategoryCount': 5,
          'leftUniqueCategoryCount': 3,
          'rightUniqueCategoryCount': 2,
          'sharedRegionCount': 1,
          'leftUniqueRegionCount': 2,
          'rightUniqueRegionCount': 1,
        },
        'sharedCategories': ['传统技艺', '传统音乐'],
        'leftUniqueCategories': ['传统戏剧'],
        'rightUniqueCategories': ['传统美术'],
        'sharedRegions': ['华东'],
        'leftUniqueRegions': ['华北', '东北'],
        'rightUniqueRegions': [],
        'leftFeaturedItems': [
          {'id': 'd1', 'title': '名录1'},
        ],
        'rightFeaturedItems': [],
        'generatedAt': '2024-01-15',
      };

      final dto = CompareResultDto.fromJson(json);

      expect(dto.left.key, 'beijing');
      expect(dto.left.title, '北京');
      expect(dto.left.total, 350);
      expect(dto.left.topCategories.length, 1);
      expect(dto.left.topRegions.length, 1);
      expect(dto.right.key, 'shanghai');
      expect(dto.right.total, 280);
      expect(dto.summary.leftTotal, 350);
      expect(dto.summary.sharedCategoryCount, 5);
      expect(dto.sharedCategories.length, 2);
      expect(dto.leftUniqueCategories.length, 1);
      expect(dto.rightUniqueCategories.length, 1);
      expect(dto.leftUniqueRegions.length, 2);
      expect(dto.leftFeaturedItems.length, 1);
      expect(dto.generatedAt, '2024-01-15');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = CompareResultDto.fromJson(json);
      expect(dto.left.key, '');
      expect(dto.right.key, '');
      expect(dto.summary.leftTotal, 0);
      expect(dto.sharedCategories, isEmpty);
      expect(dto.leftUniqueCategories, isEmpty);
      expect(dto.rightUniqueCategories, isEmpty);
      expect(dto.leftFeaturedItems, isEmpty);
    });

    test('should round-trip through JSON', () {
      final original = CompareResultDto(
        left: CompareSideDto(key: 'a', title: 'A', total: 100),
        right: CompareSideDto(key: 'b', title: 'B', total: 200),
        summary: CompareSummaryDto(leftTotal: 100, rightTotal: 200),
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

  group('CompareSideDto', () {
    test('should parse from JSON', () {
      final json = {
        'key': 'beijing',
        'title': '北京',
        'directoryItemCount': 100,
        'inheritorCount': 50,
        'articleCount': 200,
        'total': 350,
      };

      final dto = CompareSideDto.fromJson(json);

      expect(dto.key, 'beijing');
      expect(dto.total, 350);
    });
  });

  group('CompareSummaryDto', () {
    test('should parse from JSON', () {
      final json = {
        'leftTotal': 100,
        'rightTotal': 200,
        'sharedCategoryCount': 5,
        'leftUniqueCategoryCount': 3,
        'rightUniqueCategoryCount': 2,
      };

      final dto = CompareSummaryDto.fromJson(json);

      expect(dto.leftTotal, 100);
      expect(dto.rightTotal, 200);
      expect(dto.sharedCategoryCount, 5);
    });
  });

  group('TaxonomyTopicDto', () {
    test('should parse from JSON with all fields', () {
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
      expect(dto.topRegions[0].region, '北京');
      expect(dto.topCategories.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = TaxonomyTopicDto.fromJson(json);
      expect(dto.type, '');
      expect(dto.total, 0);
      expect(dto.topRegions, isEmpty);
      expect(dto.topCategories, isEmpty);
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
          {'type': 'category', 'key': 'music', 'title': '音乐'},
        ],
        'generatedAt': '2024-01-15',
      };

      final dto = TaxonomyIndexDto.fromJson(
        json,
        (json) => TaxonomyTopicDto.fromJson(json as Map<String, dynamic>),
      );

      expect(dto.items.length, 2);
      expect(dto.items[0].title, '技艺');
      expect(dto.generatedAt, '2024-01-15');
    });

    test('should parse with TaxonomyKindDto items', () {
      final json = {
        'items': [
          {'key': 'nationalProject', 'title': '国家级项目'},
        ],
      };

      final dto = TaxonomyIndexDto.fromJson(
        json,
        (json) => TaxonomyKindDto.fromJson(json as Map<String, dynamic>),
      );

      expect(dto.items.length, 1);
      expect(dto.items[0].key, 'nationalProject');
    });
  });

  group('TaxonomyCategoryDetailDto', () {
    test('should parse from JSON with all fields', () {
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
        'relatedCategories': ['传统音乐', '传统戏剧'],
        'recommendedCollections': [
          {'id': 'c1', 'title': '合集1'},
        ],
        'generatedAt': '2024-01-15',
      };

      final dto = TaxonomyCategoryDetailDto.fromJson(json);

      expect(dto.topic.title, '技艺');
      expect(dto.stats.total, 350);
      expect(dto.topRegions.length, 1);
      expect(dto.articles.length, 1);
      expect(dto.directoryItems.length, 1);
      expect(dto.inheritors.length, 1);
      expect(dto.relatedCategories.length, 2);
      expect(dto.recommendedCollections.length, 1);
      expect(dto.generatedAt, '2024-01-15');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = TaxonomyCategoryDetailDto.fromJson(json);
      expect(dto.topic.title, '');
      expect(dto.stats.total, 0);
      expect(dto.topRegions, isEmpty);
      expect(dto.articles, isEmpty);
      expect(dto.directoryItems, isEmpty);
      expect(dto.inheritors, isEmpty);
      expect(dto.relatedCategories, isEmpty);
      expect(dto.recommendedCollections, isEmpty);
    });
  });

  group('TaxonomyRegionDetailDto', () {
    test('should parse from JSON', () {
      final json = {
        'topic': {'type': 'region', 'key': 'beijing', 'title': '北京'},
        'stats': {'directoryItemCount': 50, 'total': 100},
        'topCategories': [
          {'category': 'news', 'count': 30},
        ],
        'relatedRegions': ['天津', '河北'],
      };

      final dto = TaxonomyRegionDetailDto.fromJson(json);

      expect(dto.topic.title, '北京');
      expect(dto.stats.directoryItemCount, 50);
      expect(dto.topCategories.length, 1);
      expect(dto.relatedRegions.length, 2);
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

  group('ArticleCategory enum', () {
    test('should have correct wire names', () {
      expect(ArticleCategory.news.wireName, 'news');
      expect(ArticleCategory.forum.wireName, 'forum');
      expect(ArticleCategory.specialTopic.wireName, 'specialTopic');
    });

    test('should parse from wire name', () {
      expect(ArticleCategory.fromWireName('news'), ArticleCategory.news);
      expect(ArticleCategory.fromWireName('forum'), ArticleCategory.forum);
      expect(
          ArticleCategory.fromWireName('specialTopic'), ArticleCategory.specialTopic);
    });

    test('should default to news for unknown', () {
      expect(ArticleCategory.fromWireName('unknown'), ArticleCategory.news);
      expect(ArticleCategory.fromWireName(null), ArticleCategory.news);
    });
  });

  group('DirectoryItemKind enum', () {
    test('should have correct wire names', () {
      expect(DirectoryItemKind.nationalProject.wireName, 'nationalProject');
      expect(DirectoryItemKind.culturalEcoZone.wireName, 'culturalEcoZone');
      expect(DirectoryItemKind.unescoEntry.wireName, 'unescoEntry');
    });

    test('should parse from wire name', () {
      expect(DirectoryItemKind.fromWireName('nationalProject'),
          DirectoryItemKind.nationalProject);
      expect(DirectoryItemKind.fromWireName('unescoEntry'),
          DirectoryItemKind.unescoEntry);
    });

    test('should default to nationalProject for unknown', () {
      expect(DirectoryItemKind.fromWireName('unknown'),
          DirectoryItemKind.nationalProject);
    });
  });

  group('SearchResultType enum', () {
    test('should have correct wire names', () {
      expect(SearchResultType.article.wireName, 'article');
      expect(SearchResultType.directoryItem.wireName, 'directoryItem');
      expect(SearchResultType.inheritor.wireName, 'inheritor');
      expect(SearchResultType.collection.wireName, 'collection');
      expect(SearchResultType.topic.wireName, 'topic');
    });

    test('should parse from wire name', () {
      expect(SearchResultType.fromWireName('article'), SearchResultType.article);
      expect(SearchResultType.fromWireName('directoryItem'),
          SearchResultType.directoryItem);
      expect(SearchResultType.fromWireName('inheritor'), SearchResultType.inheritor);
    });

    test('should default to article for unknown', () {
      expect(SearchResultType.fromWireName('unknown'), SearchResultType.article);
    });
  });

  group('ReadingPathSource enum', () {
    test('should have correct wire names', () {
      expect(ReadingPathSource.blendedRecommendation.wireName,
          'blendedRecommendation');
      expect(ReadingPathSource.related.wireName, 'related');
      expect(ReadingPathSource.recommendation.wireName, 'recommendation');
      expect(ReadingPathSource.graph.wireName, 'graph');
      expect(ReadingPathSource.list.wireName, 'list');
    });

    test('should parse from wire name', () {
      expect(ReadingPathSource.fromWireName('blendedRecommendation'),
          ReadingPathSource.blendedRecommendation);
      expect(ReadingPathSource.fromWireName('related'), ReadingPathSource.related);
      expect(ReadingPathSource.fromWireName('graph'), ReadingPathSource.graph);
    });

    test('should default to list for unknown', () {
      expect(ReadingPathSource.fromWireName('unknown'), ReadingPathSource.list);
    });
  });
}
