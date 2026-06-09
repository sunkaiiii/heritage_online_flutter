import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/context_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/digest_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/recommendation_dtos.dart';

void main() {
  group('RecommendationDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'rec-1',
        'type': 'article',
        'title': '推荐文章',
        'subtitle': '副标题',
        'source': 'semantic',
        'relationType': 'related',
        'reason': '相似主题',
        'weight': 0.85,
        'category': 'news',
        'region': '北京',
        'sourceUrl': 'https://example.com',
        'sourceId': 'src-1',
      };

      final dto = RecommendationDto.fromJson(json);

      expect(dto.id, 'rec-1');
      expect(dto.type, 'article');
      expect(dto.title, '推荐文章');
      expect(dto.reason, '相似主题');
      expect(dto.weight, 0.85);
      expect(dto.region, '北京');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = RecommendationDto.fromJson(json);
      expect(dto.id, isNull);
      expect(dto.weight, 0.0);
    });
  });

  group('GraphDto', () {
    test('should parse with nodes and edges', () {
      final json = {
        'nodes': [
          {'id': 'n1', 'type': 'article', 'title': '节点1'},
          {'id': 'n2', 'type': 'directoryItem', 'title': '节点2'},
        ],
        'edges': [
          {'from': 'n1', 'to': 'n2', 'label': '相关'},
        ],
      };

      final dto = GraphDto.fromJson(json);

      expect(dto.nodes.length, 2);
      expect(dto.edges.length, 1);
      expect(dto.edges[0].fromId, 'n1');
      expect(dto.edges[0].toId, 'n2');
      expect(dto.edges[0].label, '相关');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = GraphDto.fromJson(json);
      expect(dto.nodes, isEmpty);
      expect(dto.edges, isEmpty);
    });
  });

  group('RelatedSummaryDto', () {
    test('should parse from JSON', () {
      final json = {
        'id': 'rel-1',
        'type': 'directoryItem',
        'title': '相关名录',
        'category': 'traditionalCrafts',
        'kind': 'nationalProject',
        'region': '上海',
      };

      final dto = RelatedSummaryDto.fromJson(json);

      expect(dto.id, 'rel-1');
      expect(dto.type, 'directoryItem');
      expect(dto.title, '相关名录');
      expect(dto.kind, 'nationalProject');
    });
  });

  group('DetailContextDto', () {
    test('should parse full context', () {
      final json = {
        'related': [
          {'id': 'r1', 'type': 'article', 'title': '相关1'},
        ],
        'graph': {
          'nodes': [],
          'edges': [],
        },
        'collections': [
          {'id': 'c1', 'title': '合集1', 'items': []},
        ],
        'exploreTopics': [
          {'type': 'category', 'key': 'crafts', 'title': '技艺'},
        ],
        'recommendations': [
          {'id': 'rec1', 'type': 'article', 'title': '推荐1'},
        ],
        'semanticRecommendations': [
          {'id': 'sem1', 'type': 'article', 'title': '语义推荐1'},
        ],
      };

      final dto = DetailContextDto.fromJson(json);

      expect(dto.related.length, 1);
      expect(dto.graph, isNotNull);
      expect(dto.collections.length, 1);
      expect(dto.exploreTopics.length, 1);
      expect(dto.recommendations.length, 1);
      expect(dto.semanticRecommendations.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = DetailContextDto.fromJson(json);
      expect(dto.related, isEmpty);
      expect(dto.graph, isNull);
      expect(dto.collections, isEmpty);
      expect(dto.exploreTopics, isEmpty);
      expect(dto.recommendations, isEmpty);
      expect(dto.semanticRecommendations, isEmpty);
    });

    test('should round-trip through JSON', () {
      final original = DetailContextDto(
        related: [RelatedSummaryDto(id: 'r1', type: 'article', title: '相关')],
        recommendations: [RecommendationDto(id: 'rec1', title: '推荐')],
        exploreTopics: [],
      );

      final jsonMap =
          jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = DetailContextDto.fromJson(jsonMap);

      expect(restored.related.length, 1);
      expect(restored.recommendations.length, 1);
      expect(restored.recommendations[0].title, '推荐');
    });
  });

  group('ContentDigestDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'type': 'article',
        'id': 'art-1',
        'title': '文章标题',
        'quickRead': '快速阅读内容',
        'highlights': ['要点1', '要点2', '要点3'],
        'keyFacts': [
          {'label': '类别', 'value': '新闻'},
          {'label': '地区', 'value': '北京'},
        ],
        'keywords': ['非遗', '保护'],
        'readingTimeMinutes': 5,
        'sourceUrl': 'https://example.com',
        'generatedAt': '2024-01-15',
      };

      final dto = ContentDigestDto.fromJson(json);

      expect(dto.type, 'article');
      expect(dto.title, '文章标题');
      expect(dto.quickRead, '快速阅读内容');
      expect(dto.highlights.length, 3);
      expect(dto.keyFacts.length, 2);
      expect(dto.keyFacts[0].label, '类别');
      expect(dto.keywords.length, 2);
      expect(dto.readingTimeMinutes, 5);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = ContentDigestDto.fromJson(json);
      expect(dto.type, '');
      expect(dto.highlights, isEmpty);
      expect(dto.keyFacts, isEmpty);
      expect(dto.keywords, isEmpty);
      expect(dto.readingTimeMinutes, 0);
    });

    test('should round-trip through JSON', () {
      final original = ContentDigestDto(
        type: 'article',
        id: 'test',
        title: '测试',
        quickRead: '速读内容',
        highlights: ['要点1'],
        keyFacts: [DigestFactDto(label: '标签', value: '值')],
        readingTimeMinutes: 3,
      );

      final jsonMap =
          jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = ContentDigestDto.fromJson(jsonMap);

      expect(restored.quickRead, '速读内容');
      expect(restored.highlights.length, 1);
      expect(restored.keyFacts[0].label, '标签');
    });
  });

  group('BlendedRecommendationResponseDto', () {
    test('should parse from JSON', () {
      final json = {
        'items': [
          {
            'id': 'item-1',
            'type': 'article',
            'title': '推荐文章',
            'score': 0.95,
            'reasons': ['相似主题'],
            'scoreBreakdown': {
              'explicit': 0.8,
              'inferred': 0.7,
              'embedding': 0.9,
              'sameCategory': 0.6,
              'sameRegion': 0.5,
            },
          },
        ],
        'query': {
          'type': 'article',
          'id': 'art-1',
          'limit': 10,
        },
        'generatedAt': '2024-01-15',
      };

      final dto = BlendedRecommendationResponseDto.fromJson(json);

      expect(dto.items.length, 1);
      expect(dto.items[0].title, '推荐文章');
      expect(dto.items[0].score, 0.95);
      expect(dto.items[0].reasons, ['相似主题']);
      expect(dto.items[0].scoreBreakdown.explicit, 0.8);
      expect(dto.query.type, 'article');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};
      final dto = BlendedRecommendationResponseDto.fromJson(json);
      expect(dto.items, isEmpty);
      expect(dto.query.type, '');
      expect(dto.query.limit, 10);
      expect(dto.query.diversify, true);
    });
  });
}
