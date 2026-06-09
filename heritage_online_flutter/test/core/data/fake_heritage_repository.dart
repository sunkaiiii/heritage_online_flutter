import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/compare_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/context_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/digest_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/recommendation_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/story_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/taxonomy_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/timeline_dtos.dart';

/// Fake Heritage Repository 用于测试
/// 可以替换真实实现，方便单元测试
class FakeHeritageRepository implements HeritageRepository {
  /// 模拟文章详情缓存
  final Map<String, ArticleDetailDto> _articleCache = {};

  /// 模拟名录详情缓存
  final Map<String, DirectoryItemDetailDto> _directoryCache = {};

  /// 模拟传承人详情缓存
  final Map<String, InheritorDetailDto> _inheritorCache = {};

  /// 是否抛出错误
  bool shouldThrow = false;

  /// 模拟错误
  Exception? mockError;

  /// 设置模拟文章详情
  void setArticleDetail(String id, ArticleDetailDto detail) {
    _articleCache[id] = detail;
  }

  /// 设置模拟名录详情
  void setDirectoryDetail(String id, DirectoryItemDetailDto detail) {
    _directoryCache[id] = detail;
  }

  /// 设置模拟传承人详情
  void setInheritorDetail(String id, InheritorDetailDto detail) {
    _inheritorCache[id] = detail;
  }

  void _checkError() {
    if (shouldThrow && mockError != null) {
      throw mockError!;
    }
  }

  @override
  Future<List<HomeBannerDto>> homeBanners() async {
    _checkError();
    return [];
  }

  @override
  Future<HomeFeedDto> homeFeed() async {
    _checkError();
    return const HomeFeedDto();
  }

  @override
  Future<PagedResult<ArticleSummaryDto>> articles({
    String? category,
    int? page,
    int? pageSize,
    String? keywords,
    bool? hasImage,
    int? year,
  }) async {
    _checkError();
    return const PagedResult();
  }

  @override
  Future<ArticleDetailDto> article(String id) async {
    _checkError();
    if (_articleCache.containsKey(id)) {
      return _articleCache[id]!;
    }
    return ArticleDetailDto(id: id, title: 'Test Article $id');
  }

  @override
  Future<ArticleDetailDto> articleBySourceId(
    String sourceId, {
    ArticleCategory category = ArticleCategory.news,
  }) async {
    _checkError();
    return ArticleDetailDto(id: 'source:$sourceId', title: 'Article from source');
  }

  @override
  Future<ArticleDetailDto> articleBySourceUrl(
    String sourceUrl, {
    ArticleCategory category = ArticleCategory.news,
  }) async {
    _checkError();
    return ArticleDetailDto(id: 'url:$sourceUrl', title: 'Article from URL');
  }

  @override
  Future<ArticleDetailDto> articleDetail(ArticleDetailLookup lookup) async {
    _checkError();
    if (!lookup.isValid) {
      throw ArgumentError('Missing article lookup key');
    }

    if (lookup.articleId != null && lookup.articleId!.isNotEmpty) {
      return article(lookup.articleId!);
    }

    if (lookup.sourceId != null && lookup.sourceId!.isNotEmpty) {
      return articleBySourceId(lookup.sourceId!, category: lookup.category);
    }

    if (lookup.sourceUrl != null && lookup.sourceUrl!.isNotEmpty) {
      return articleBySourceUrl(lookup.sourceUrl!, category: lookup.category);
    }

    throw ArgumentError('Missing article lookup key');
  }

  @override
  Future<PagedResult<DirectoryItemSummaryDto>> directoryItems({
    String? kind,
    int? page,
    int? pageSize,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? listType,
  }) async {
    _checkError();
    return const PagedResult();
  }

  @override
  Future<DirectoryItemDetailDto> directoryItem(String id) async {
    _checkError();
    if (_directoryCache.containsKey(id)) {
      return _directoryCache[id]!;
    }
    return DirectoryItemDetailDto(id: id, title: 'Test Directory $id');
  }

  @override
  Future<DirectoryItemDetailDto> directoryItemBySourceId(
    String sourceId, {
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
  }) async {
    _checkError();
    return DirectoryItemDetailDto(id: 'source:$sourceId', title: 'Directory from source');
  }

  @override
  Future<DirectoryItemDetailDto> directoryItemDetail(
    DirectoryDetailLookup lookup,
  ) async {
    _checkError();
    if (!lookup.isValid) {
      throw ArgumentError('Missing directory lookup key');
    }

    if (lookup.itemId != null && lookup.itemId!.isNotEmpty) {
      return directoryItem(lookup.itemId!);
    }

    if (lookup.sourceId != null && lookup.sourceId!.isNotEmpty) {
      return directoryItemBySourceId(lookup.sourceId!, kind: lookup.kind);
    }

    throw ArgumentError('Missing directory lookup key');
  }

  @override
  Future<DirectoryStatisticsOverviewDto> directoryStatisticsOverview({
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
  }) async {
    _checkError();
    return const DirectoryStatisticsOverviewDto();
  }

  @override
  Future<DirectoryStatisticDimensionDto> directoryStatisticsBreakdown({
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
    required DirectoryStatisticDimension dimension,
    int limit = 50,
  }) async {
    _checkError();
    return const DirectoryStatisticDimensionDto();
  }

  @override
  Future<PagedResult<InheritorSummaryDto>> inheritors({
    int? page,
    int? pageSize,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? gender,
  }) async {
    _checkError();
    return const PagedResult();
  }

  @override
  Future<InheritorDetailDto> inheritor(String id) async {
    _checkError();
    if (_inheritorCache.containsKey(id)) {
      return _inheritorCache[id]!;
    }
    return InheritorDetailDto(id: id, name: 'Test Inheritor $id');
  }

  @override
  Future<InheritorDetailDto> inheritorBySourceId(String sourceId) async {
    _checkError();
    return InheritorDetailDto(id: 'source:$sourceId', name: 'Inheritor from source');
  }

  @override
  Future<InheritorDetailDto> inheritorDetail(
    InheritorDetailLookup lookup,
  ) async {
    _checkError();
    if (!lookup.isValid) {
      throw ArgumentError('Missing inheritor lookup key');
    }

    if (lookup.inheritorId != null && lookup.inheritorId!.isNotEmpty) {
      return inheritor(lookup.inheritorId!);
    }

    if (lookup.sourceId != null && lookup.sourceId!.isNotEmpty) {
      return inheritorBySourceId(lookup.sourceId!);
    }

    throw ArgumentError('Missing inheritor lookup key');
  }

  @override
  Future<dynamic> searchV2({
    String? keywords,
    List<String>? types,
    int? page,
    int? pageSize,
    String? region,
    String? category,
    int? year,
    String? kind,
    bool? hasImage,
  }) async {
    _checkError();
    return {'items': [], 'hasMore': false, 'total': 0};
  }

  @override
  Future<List<dynamic>> searchSuggestions(String prefix, {int limit = 10}) async {
    _checkError();
    return [];
  }

  @override
  Future<dynamic> exploreIndex() async {
    _checkError();
    return null;
  }

  @override
  Future<List<dynamic>> exploreTopics({String? type, int limit = 20}) async {
    _checkError();
    return [];
  }

  @override
  Future<dynamic> exploreTopic(String type, String key, {int limit = 6}) async {
    _checkError();
    return null;
  }

  @override
  Future<List<dynamic>> learningPaths() async {
    _checkError();
    return [];
  }

  @override
  Future<dynamic> learningPathDetail(String id, {int limit = 6}) async {
    _checkError();
    return null;
  }

  /// 模拟精选合集
  List<FeaturedCollectionDto> mockFeaturedCollections = [];

  /// 模拟合集详情
  CollectionDto? mockCollection;

  @override
  Future<List<FeaturedCollectionDto>> featuredCollections() async {
    _checkError();
    return mockFeaturedCollections;
  }

  @override
  Future<CollectionDto> collection(String id, {int limit = 10}) async {
    _checkError();
    if (mockCollection != null) return mockCollection!;
    return const CollectionDto();
  }

  @override
  Future<CollectionDto> topicCollection(String type, String key, {int limit = 10}) async {
    _checkError();
    if (mockCollection != null) return mockCollection!;
    return const CollectionDto();
  }

  /// 模拟地区图谱响应
  RegionAtlasDto? mockRegionAtlas;

  /// 模拟地区详情响应
  RegionAtlasDetailDto? mockRegionDetail;

  @override
  Future<RegionAtlasDto> regionAtlas() async {
    _checkError();
    if (mockRegionAtlas != null) return mockRegionAtlas!;
    return const RegionAtlasDto();
  }

  @override
  Future<RegionAtlasDetailDto> regionAtlasDetail(String region, {int limit = 6}) async {
    _checkError();
    if (mockRegionDetail != null) return mockRegionDetail!;
    return const RegionAtlasDetailDto();
  }

  @override
  Future<dynamic> discoveryToday() async {
    _checkError();
    return null;
  }

  @override
  Future<dynamic> discoveryTrending() async {
    _checkError();
    return null;
  }

  @override
  Future<dynamic> discoveryWeekly() async {
    _checkError();
    return null;
  }

  @override
  Future<dynamic> discoverySerendipity() async {
    _checkError();
    return null;
  }

  @override
  Future<dynamic> discoveryRandom({String? type}) async {
    _checkError();
    return null;
  }

  // ==================== 时间线 ====================

  /// 模拟时间线年份数据
  List<TimelineYearBucketDto> mockTimelineYears = [];

  /// 模拟时间线响应
  TimelineV2ResponseDto? mockTimelineResponse;

  @override
  Future<List<TimelineYearBucketDto>> timelineYears() async {
    _checkError();
    return mockTimelineYears;
  }

  @override
  Future<TimelineV2ResponseDto> timelineV2({
    int? year,
    List<String>? types,
    int? page,
    int? pageSize,
    String? category,
    String? region,
    String? kind,
    bool? hasImage,
  }) async {
    _checkError();
    if (mockTimelineResponse != null) return mockTimelineResponse!;
    return const TimelineV2ResponseDto();
  }

  // ==================== Context / Digest / Blended ====================

  /// 模拟 Context 响应
  DetailContextDto? mockContext;

  /// 模拟 Digest 响应
  ContentDigestDto? mockDigest;

  /// 模拟综合推荐响应
  BlendedRecommendationResponseDto? mockBlendedRecommendations;

  @override
  Future<DetailContextDto> articleContext(String id) async {
    _checkError();
    if (mockContext != null) return mockContext!;
    return const DetailContextDto();
  }

  @override
  Future<ContentDigestDto> articleDigest(String id) async {
    _checkError();
    if (mockDigest != null) return mockDigest!;
    return const ContentDigestDto();
  }

  @override
  Future<DetailContextDto> directoryItemContext(String id) async {
    _checkError();
    if (mockContext != null) return mockContext!;
    return const DetailContextDto();
  }

  @override
  Future<ContentDigestDto> directoryItemDigest(String id) async {
    _checkError();
    if (mockDigest != null) return mockDigest!;
    return const ContentDigestDto();
  }

  @override
  Future<DetailContextDto> inheritorContext(String id) async {
    _checkError();
    if (mockContext != null) return mockContext!;
    return const DetailContextDto();
  }

  @override
  Future<ContentDigestDto> inheritorDigest(String id) async {
    _checkError();
    if (mockDigest != null) return mockDigest!;
    return const ContentDigestDto();
  }

  @override
  Future<BlendedRecommendationResponseDto> blendedRecommendations(
    String type,
    String id, {
    int limit = 10,
  }) async {
    _checkError();
    if (mockBlendedRecommendations != null) return mockBlendedRecommendations!;
    return const BlendedRecommendationResponseDto();
  }

  // ==================== 数据故事 ====================

  /// 模拟故事响应
  DataStoryDto? mockStory;

  @override
  Future<DataStoryDto> regionStory(String region) async {
    _checkError();
    if (mockStory != null) return mockStory!;
    return const DataStoryDto();
  }

  @override
  Future<DataStoryDto> categoryStory(String category) async {
    _checkError();
    if (mockStory != null) return mockStory!;
    return const DataStoryDto();
  }

  @override
  Future<DataStoryDto> yearStory(int year) async {
    _checkError();
    if (mockStory != null) return mockStory!;
    return const DataStoryDto();
  }

  // ==================== 主题库 ====================

  /// 模拟主题库分类索引
  TaxonomyIndexDto<TaxonomyTopicDto>? mockTaxonomyCategories;

  /// 模拟主题库地区索引
  TaxonomyIndexDto<TaxonomyTopicDto>? mockTaxonomyRegions;

  /// 模拟主题库 kind 索引
  TaxonomyIndexDto<TaxonomyKindDto>? mockTaxonomyKinds;

  /// 模拟分类详情
  TaxonomyCategoryDetailDto? mockTaxonomyCategoryDetail;

  /// 模拟地区详情
  TaxonomyRegionDetailDto? mockTaxonomyRegionDetail;

  @override
  Future<TaxonomyIndexDto<TaxonomyTopicDto>> taxonomyCategories({int limit = 50}) async {
    _checkError();
    if (mockTaxonomyCategories != null) return mockTaxonomyCategories!;
    return const TaxonomyIndexDto<TaxonomyTopicDto>();
  }

  @override
  Future<TaxonomyIndexDto<TaxonomyTopicDto>> taxonomyRegions({int limit = 50}) async {
    _checkError();
    if (mockTaxonomyRegions != null) return mockTaxonomyRegions!;
    return const TaxonomyIndexDto<TaxonomyTopicDto>();
  }

  @override
  Future<TaxonomyIndexDto<TaxonomyKindDto>> taxonomyKinds() async {
    _checkError();
    if (mockTaxonomyKinds != null) return mockTaxonomyKinds!;
    return const TaxonomyIndexDto<TaxonomyKindDto>();
  }

  @override
  Future<TaxonomyCategoryDetailDto> taxonomyCategoryDetail(String category, {int limit = 6}) async {
    _checkError();
    if (mockTaxonomyCategoryDetail != null) return mockTaxonomyCategoryDetail!;
    return const TaxonomyCategoryDetailDto();
  }

  @override
  Future<TaxonomyRegionDetailDto> taxonomyRegionDetail(String region, {int limit = 6}) async {
    _checkError();
    if (mockTaxonomyRegionDetail != null) return mockTaxonomyRegionDetail!;
    return const TaxonomyRegionDetailDto();
  }

  // ==================== 对比 ====================

  /// 模拟对比结果
  CompareResultDto? mockCompareResult;

  @override
  Future<CompareResultDto> compareRegions(String left, String right, {int limit = 6}) async {
    _checkError();
    if (mockCompareResult != null) return mockCompareResult!;
    return const CompareResultDto();
  }

  @override
  Future<CompareResultDto> compareCategories(String left, String right, {int limit = 6}) async {
    _checkError();
    if (mockCompareResult != null) return mockCompareResult!;
    return const CompareResultDto();
  }

  @override
  Future<CompareResultDto> compareKinds(String left, String right, {int limit = 6}) async {
    _checkError();
    if (mockCompareResult != null) return mockCompareResult!;
    return const CompareResultDto();
  }
}
