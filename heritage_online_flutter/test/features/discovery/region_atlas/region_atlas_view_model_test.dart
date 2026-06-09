import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_atlas_view_model.dart';

import '../../../core/data/fake_heritage_repository.dart';

void main() {
  group('RegionAtlasViewModel', () {
    late FakeHeritageRepository repository;
    late RegionAtlasViewModel viewModel;

    setUp(() {
      repository = FakeHeritageRepository();
      viewModel = RegionAtlasViewModel(repository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('should load atlas successfully', () async {
      repository.mockRegionAtlas = const RegionAtlasDto(
        regions: [
          RegionAtlasItemDto(
            region: 'beijing',
            displayName: '北京',
            directoryItemCount: 50,
            inheritorCount: 20,
          ),
          RegionAtlasItemDto(
            region: 'shanghai',
            displayName: '上海',
            directoryItemCount: 30,
            inheritorCount: 10,
          ),
        ],
        totals: RegionAtlasTotalsDto(
          directoryItemCount: 80,
          inheritorCount: 30,
          regionCount: 2,
        ),
      );

      viewModel.dispose();
      viewModel = RegionAtlasViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.atlas, isNotNull);
      expect(state.atlas!.regions.length, 2);
      expect(state.atlas!.regions[0].displayName, '北京');
      expect(state.atlas!.totals!.directoryItemCount, 80);
      expect(state.error, isNull);
    });

    test('should handle loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      viewModel.dispose();
      viewModel = RegionAtlasViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.atlas, isNull);
      expect(state.error, isNotNull);
    });

    test('should load empty atlas without error', () async {
      repository.mockRegionAtlas = const RegionAtlasDto(regions: []);

      viewModel.dispose();
      viewModel = RegionAtlasViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.atlas, isNotNull);
      expect(state.atlas!.regions, isEmpty);
      expect(state.error, isNull);
    });

    test('should retry successfully', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      viewModel.dispose();
      viewModel = RegionAtlasViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNotNull);

      // Fix error and retry
      repository.shouldThrow = false;
      repository.mockRegionAtlas = const RegionAtlasDto(
        regions: [RegionAtlasItemDto(region: 'beijing')],
      );

      viewModel.retry();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNull);
      expect(viewModel.state.atlas!.regions.length, 1);
    });
  });

  group('RegionDetailViewModel', () {
    late FakeHeritageRepository repository;

    setUp(() {
      repository = FakeHeritageRepository();
    });

    test('should load detail successfully', () async {
      repository.mockRegionDetail = const RegionAtlasDetailDto(
        region: 'beijing',
        displayName: '北京',
        stats: RegionAtlasDetailStatsDto(
          directoryItemCount: 50,
          inheritorCount: 20,
          total: 70,
        ),
        categoryBreakdown: [
          FacetBucketDto(key: 'traditionalCrafts', count: 15),
        ],
        kindBreakdown: [
          FacetBucketDto(key: 'nationalProject', count: 30),
        ],
        featuredDirectoryItems: [
          DirectoryItemSummaryDto(id: 'dir-1', title: '昆曲'),
        ],
        featuredInheritors: [
          InheritorSummaryDto(id: 'inh-1', name: '张三'),
        ],
        relatedArticles: [
          ArticleSummaryDto(id: 'art-1', title: '北京非遗'),
        ],
        relatedRegions: [
          ExploreTopicLinkDto(type: 'region', key: 'tianjin', title: '天津'),
        ],
      );

      final viewModel = RegionDetailViewModel(repository, 'beijing');
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.detail, isNotNull);
      expect(state.detail!.region, 'beijing');
      expect(state.detail!.displayName, '北京');
      expect(state.detail!.stats!.directoryItemCount, 50);
      expect(state.detail!.categoryBreakdown.length, 1);
      expect(state.detail!.featuredDirectoryItems.length, 1);
      expect(state.detail!.featuredInheritors.length, 1);
      expect(state.detail!.relatedArticles.length, 1);
      expect(state.detail!.relatedRegions.length, 1);
      expect(state.error, isNull);

      viewModel.dispose();
    });

    test('should handle loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Not found');

      final viewModel = RegionDetailViewModel(repository, 'unknown');
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.detail, isNull);
      expect(state.error, isNotNull);

      viewModel.dispose();
    });

    test('should load empty detail without error', () async {
      repository.mockRegionDetail = const RegionAtlasDetailDto();

      final viewModel = RegionDetailViewModel(repository, 'empty');
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.detail, isNotNull);
      expect(state.detail!.featuredDirectoryItems, isEmpty);
      expect(state.error, isNull);

      viewModel.dispose();
    });

    test('should retry successfully', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Timeout');

      final viewModel = RegionDetailViewModel(repository, 'beijing');
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNotNull);

      // Fix error and retry
      repository.shouldThrow = false;
      repository.mockRegionDetail = const RegionAtlasDetailDto(
        region: 'beijing',
        displayName: '北京',
      );

      viewModel.retry();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNull);
      expect(viewModel.state.detail!.displayName, '北京');

      viewModel.dispose();
    });
  });
}
