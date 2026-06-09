import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';

void main() {
  group('RegionAtlasTotalsDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'directoryItemCount': 500,
        'inheritorCount': 200,
        'regionCount': 30,
      };

      final dto = RegionAtlasTotalsDto.fromJson(json);

      expect(dto.directoryItemCount, 500);
      expect(dto.inheritorCount, 200);
      expect(dto.regionCount, 30);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = RegionAtlasTotalsDto.fromJson(json);

      expect(dto.directoryItemCount, 0);
      expect(dto.inheritorCount, 0);
      expect(dto.regionCount, 0);
    });
  });

  group('RegionAtlasItemDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'region': 'beijing',
        'displayName': '北京',
        'directoryItemCount': 50,
        'inheritorCount': 20,
        'total': 70,
        'topCategories': [
          {'key': 'traditionalCrafts', 'count': 15},
        ],
        'topKinds': [
          {'key': 'nationalProject', 'count': 30},
        ],
        'coverImage': {
          'displayUrl': 'https://example.com/beijing.jpg',
        },
      };

      final dto = RegionAtlasItemDto.fromJson(json);

      expect(dto.region, 'beijing');
      expect(dto.displayName, '北京');
      expect(dto.directoryItemCount, 50);
      expect(dto.inheritorCount, 20);
      expect(dto.total, 70);
      expect(dto.topCategories.length, 1);
      expect(dto.topCategories[0].key, 'traditionalCrafts');
      expect(dto.topKinds.length, 1);
      expect(dto.coverImage, isNotNull);
      expect(dto.coverImage!.displayUrl, 'https://example.com/beijing.jpg');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = RegionAtlasItemDto.fromJson(json);

      expect(dto.region, isNull);
      expect(dto.displayName, isNull);
      expect(dto.directoryItemCount, 0);
      expect(dto.inheritorCount, 0);
      expect(dto.total, 0);
      expect(dto.topCategories, isEmpty);
      expect(dto.topKinds, isEmpty);
      expect(dto.coverImage, isNull);
    });
  });

  group('RegionAtlasDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'regions': [
          {
            'region': 'beijing',
            'displayName': '北京',
            'directoryItemCount': 50,
          },
          {
            'region': 'shanghai',
            'displayName': '上海',
            'directoryItemCount': 30,
          },
        ],
        'totals': {
          'directoryItemCount': 80,
          'inheritorCount': 40,
          'regionCount': 2,
        },
        'generatedAt': '2024-01-15',
      };

      final dto = RegionAtlasDto.fromJson(json);

      expect(dto.regions.length, 2);
      expect(dto.regions[0].region, 'beijing');
      expect(dto.regions[1].displayName, '上海');
      expect(dto.totals, isNotNull);
      expect(dto.totals!.directoryItemCount, 80);
      expect(dto.generatedAt, '2024-01-15');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = RegionAtlasDto.fromJson(json);

      expect(dto.regions, isEmpty);
      expect(dto.totals, isNull);
      expect(dto.generatedAt, isNull);
    });
  });

  group('RegionAtlasDetailStatsDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'directoryItemCount': 50,
        'inheritorCount': 20,
        'total': 70,
      };

      final dto = RegionAtlasDetailStatsDto.fromJson(json);

      expect(dto.directoryItemCount, 50);
      expect(dto.inheritorCount, 20);
      expect(dto.total, 70);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = RegionAtlasDetailStatsDto.fromJson(json);

      expect(dto.directoryItemCount, 0);
      expect(dto.inheritorCount, 0);
      expect(dto.total, 0);
    });
  });

  group('RegionAtlasDetailDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'region': 'beijing',
        'displayName': '北京',
        'stats': {
          'directoryItemCount': 50,
          'inheritorCount': 20,
          'total': 70,
        },
        'categoryBreakdown': [
          {'key': 'traditionalCrafts', 'count': 15},
          {'key': 'traditionalMusic', 'count': 10},
        ],
        'kindBreakdown': [
          {'key': 'nationalProject', 'count': 30},
          {'key': 'unescoEntry', 'count': 5},
        ],
        'featuredDirectoryItems': [
          {'id': 'dir-1', 'title': '昆曲'},
        ],
        'featuredInheritors': [
          {'id': 'inh-1', 'name': '张三'},
        ],
        'relatedArticles': [
          {'id': 'art-1', 'title': '北京非遗报道'},
        ],
        'timeline': [
          {'title': '2024年事件'},
        ],
        'relatedRegions': [
          {'type': 'region', 'key': 'tianjin', 'title': '天津'},
        ],
        'generatedAt': '2024-01-15',
      };

      final dto = RegionAtlasDetailDto.fromJson(json);

      expect(dto.region, 'beijing');
      expect(dto.displayName, '北京');
      expect(dto.stats, isNotNull);
      expect(dto.stats!.directoryItemCount, 50);
      expect(dto.categoryBreakdown.length, 2);
      expect(dto.kindBreakdown.length, 2);
      expect(dto.featuredDirectoryItems.length, 1);
      expect(dto.featuredDirectoryItems[0].title, '昆曲');
      expect(dto.featuredInheritors.length, 1);
      expect(dto.featuredInheritors[0].name, '张三');
      expect(dto.relatedArticles.length, 1);
      expect(dto.relatedArticles[0].title, '北京非遗报道');
      expect(dto.timeline.length, 1);
      expect(dto.relatedRegions.length, 1);
      expect(dto.relatedRegions[0].key, 'tianjin');
      expect(dto.generatedAt, '2024-01-15');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = RegionAtlasDetailDto.fromJson(json);

      expect(dto.region, isNull);
      expect(dto.displayName, isNull);
      expect(dto.stats, isNull);
      expect(dto.categoryBreakdown, isEmpty);
      expect(dto.kindBreakdown, isEmpty);
      expect(dto.featuredDirectoryItems, isEmpty);
      expect(dto.featuredInheritors, isEmpty);
      expect(dto.relatedArticles, isEmpty);
      expect(dto.timeline, isEmpty);
      expect(dto.relatedRegions, isEmpty);
      expect(dto.generatedAt, isNull);
    });

    test('should round-trip through JSON', () {
      final original = RegionAtlasDetailDto(
        region: 'shanghai',
        displayName: '上海',
        stats: RegionAtlasDetailStatsDto(
          directoryItemCount: 30,
          inheritorCount: 10,
          total: 40,
        ),
        categoryBreakdown: [FacetBucketDto(key: 'crafts', count: 5)],
      );

      // Deep serialize via JSON encode/decode to get proper Map<String, dynamic>
      final jsonMap = jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>;
      final restored = RegionAtlasDetailDto.fromJson(jsonMap);

      expect(restored.region, 'shanghai');
      expect(restored.displayName, '上海');
      expect(restored.stats!.directoryItemCount, 30);
      expect(restored.categoryBreakdown.length, 1);
      expect(restored.categoryBreakdown[0].key, 'crafts');
    });
  });
}
