import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/network/api_client.dart';
import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/compare_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/context_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/digest_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/discovery_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/explore_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/learning_path_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/recommendation_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/story_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/taxonomy_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/timeline_dtos.dart';

/// 默认 Heritage Repository 实现
/// UI 只依赖 Repository，不直接依赖 API client
class DefaultHeritageRepository implements HeritageRepository {
  final ApiClient _apiClient;

  DefaultHeritageRepository({required ApiClient apiClient}) : _apiClient = apiClient; // ignore: prefer_initializing_formals

  /// 将 response.data 转换为 `Map<String, dynamic>`
  Map<String, dynamic> _toMap(dynamic data) => data as Map<String, dynamic>;

  /// 将 response.data 转换为 List
  List<dynamic> _toList(dynamic data) => data as List<dynamic>;

  // ==================== 首页 ====================

  @override
  Future<List<HomeBannerDto>> homeBanners() async {
    final response = await _apiClient.getHomeBanners();
    final data = _toList(response.data);
    return data.map((json) => HomeBannerDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<HomeFeedDto> homeFeed() async {
    final response = await _apiClient.getHomeFeed();
    return HomeFeedDto.fromJson(_toMap(response.data));
  }

  // ==================== 文章 ====================

  @override
  Future<PagedResult<ArticleSummaryDto>> articles({
    String? category,
    int? page,
    int? pageSize,
    String? keywords,
    bool? hasImage,
    int? year,
  }) async {
    final response = await _apiClient.getArticles(
      category: category,
      page: page,
      pageSize: pageSize,
      keywords: keywords,
      hasImage: hasImage,
      year: year,
    );
    return PagedResult.fromJson(
      _toMap(response.data),
      (json) => ArticleSummaryDto.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ArticleDetailDto> article(String id) async {
    final response = await _apiClient.getArticle(id);
    return ArticleDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<ArticleDetailDto> articleBySourceId(
    String sourceId, {
    ArticleCategory category = ArticleCategory.news,
  }) async {
    final response = await _apiClient.getArticleBySourceId(
      sourceId,
      category: category.wireName,
    );
    return ArticleDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<ArticleDetailDto> articleBySourceUrl(
    String sourceUrl, {
    ArticleCategory category = ArticleCategory.news,
  }) async {
    final response = await _apiClient.getArticleBySourceUrl(
      sourceUrl,
      category: category.wireName,
    );
    return ArticleDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<ArticleDetailDto> articleDetail(ArticleDetailLookup lookup) async {
    if (!lookup.isValid) {
      throw ArgumentError('Missing article lookup key');
    }

    if (lookup.articleId != null && lookup.articleId!.isNotEmpty) {
      return article(lookup.articleId!);
    }

    if (lookup.sourceId != null && lookup.sourceId!.isNotEmpty) {
      return articleBySourceId(
        lookup.sourceId!,
        category: lookup.category,
      );
    }

    if (lookup.sourceUrl != null && lookup.sourceUrl!.isNotEmpty) {
      return articleBySourceUrl(
        lookup.sourceUrl!,
        category: lookup.category,
      );
    }

    throw ArgumentError('Missing article lookup key');
  }

  @override
  Future<DetailContextDto> articleContext(String id) async {
    final response = await _apiClient.getArticleContext(id);
    return DetailContextDto.fromJson(_toMap(response.data));
  }

  @override
  Future<ContentDigestDto> articleDigest(String id) async {
    final response = await _apiClient.getArticleDigest(id);
    return ContentDigestDto.fromJson(_toMap(response.data));
  }

  // ==================== 名录 ====================

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
    final response = await _apiClient.getDirectoryItems(
      kind: kind,
      page: page,
      pageSize: pageSize,
      keywords: keywords,
      region: region,
      category: category,
      year: year,
      listType: listType,
    );
    return PagedResult.fromJson(
      _toMap(response.data),
      (json) => DirectoryItemSummaryDto.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<DirectoryItemDetailDto> directoryItem(String id) async {
    final response = await _apiClient.getDirectoryItem(id);
    return DirectoryItemDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DirectoryItemDetailDto> directoryItemBySourceId(
    String sourceId, {
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
  }) async {
    final response = await _apiClient.getDirectoryItemBySourceId(
      sourceId,
      kind: kind.wireName,
    );
    return DirectoryItemDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DirectoryItemDetailDto> directoryItemDetail(
    DirectoryDetailLookup lookup,
  ) async {
    if (!lookup.isValid) {
      throw ArgumentError('Missing directory lookup key');
    }

    if (lookup.itemId != null && lookup.itemId!.isNotEmpty) {
      return directoryItem(lookup.itemId!);
    }

    if (lookup.sourceId != null && lookup.sourceId!.isNotEmpty) {
      return directoryItemBySourceId(
        lookup.sourceId!,
        kind: lookup.kind,
      );
    }

    throw ArgumentError('Missing directory lookup key');
  }

  @override
  Future<DirectoryStatisticsOverviewDto> directoryStatisticsOverview({
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
  }) async {
    final response = await _apiClient.getDirectoryStatisticsOverview(
      kind: kind.wireName,
    );
    return DirectoryStatisticsOverviewDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DirectoryStatisticDimensionDto> directoryStatisticsBreakdown({
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
    required DirectoryStatisticDimension dimension,
    int limit = 50,
  }) async {
    final response = await _apiClient.getDirectoryStatisticsBreakdown(
      kind: kind.wireName,
      dimension: dimension.wireName,
      limit: limit,
    );
    return DirectoryStatisticDimensionDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DetailContextDto> directoryItemContext(String id) async {
    final response = await _apiClient.getDirectoryItemContext(id);
    return DetailContextDto.fromJson(_toMap(response.data));
  }

  @override
  Future<ContentDigestDto> directoryItemDigest(String id) async {
    final response = await _apiClient.getDirectoryItemDigest(id);
    return ContentDigestDto.fromJson(_toMap(response.data));
  }

  // ==================== 传承人 ====================

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
    final response = await _apiClient.getInheritors(
      page: page,
      pageSize: pageSize,
      keywords: keywords,
      region: region,
      category: category,
      year: year,
      gender: gender,
    );
    return PagedResult.fromJson(
      _toMap(response.data),
      (json) => InheritorSummaryDto.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<InheritorDetailDto> inheritor(String id) async {
    final response = await _apiClient.getInheritor(id);
    return InheritorDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<InheritorDetailDto> inheritorBySourceId(String sourceId) async {
    final response = await _apiClient.getInheritorBySourceId(sourceId);
    return InheritorDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<InheritorDetailDto> inheritorDetail(
    InheritorDetailLookup lookup,
  ) async {
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
  Future<DetailContextDto> inheritorContext(String id) async {
    final response = await _apiClient.getInheritorContext(id);
    return DetailContextDto.fromJson(_toMap(response.data));
  }

  @override
  Future<ContentDigestDto> inheritorDigest(String id) async {
    final response = await _apiClient.getInheritorDigest(id);
    return ContentDigestDto.fromJson(_toMap(response.data));
  }

  // ==================== 推荐 ====================

  @override
  Future<BlendedRecommendationResponseDto> blendedRecommendations(
    String type,
    String id, {
    int limit = 10,
  }) async {
    final response = await _apiClient.getBlendedRecommendations(
      type,
      id,
      limit: limit,
    );
    return BlendedRecommendationResponseDto.fromJson(_toMap(response.data));
  }

  // ==================== 搜索 ====================

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
    final response = await _apiClient.searchV2(
      query: keywords,
      types: types,
      page: page,
      pageSize: pageSize,
      region: region,
      category: category,
      year: year,
      kind: kind,
      hasImage: hasImage,
    );
    return response.data;
  }

  @override
  Future<List<dynamic>> searchSuggestions(String prefix, {int limit = 10}) async {
    final response = await _apiClient.getSearchSuggestions(prefix, limit: limit);
    return response.data as List<dynamic>;
  }

  // ==================== 发现页 ====================

  @override
  Future<ExploreIndexDto> exploreIndex() async {
    final response = await _apiClient.getExploreIndex();
    return ExploreIndexDto.fromJson(_toMap(response.data));
  }

  @override
  Future<List<ExploreTopicInfoDto>> exploreTopics({String? type, int limit = 20}) async {
    final response = await _apiClient.getExploreTopics(type: type, limit: limit);
    final list = response.data as List<dynamic>;
    return list.map((j) => ExploreTopicInfoDto.fromJson(j as Map<String, dynamic>)).toList();
  }

  @override
  Future<ExploreTopicV2Dto> exploreTopic(String type, String key, {int limit = 6}) async {
    final response = await _apiClient.getExploreTopic(type, key, limit: limit);
    return ExploreTopicV2Dto.fromJson(_toMap(response.data));
  }

  @override
  Future<List<LearningPathDto>> learningPaths() async {
    final response = await _apiClient.getLearningPaths();
    final list = response.data as List<dynamic>;
    return list.map((j) => LearningPathDto.fromJson(j as Map<String, dynamic>)).toList();
  }

  @override
  Future<LearningPathDetailDto> learningPathDetail(String id, {int limit = 6}) async {
    final response = await _apiClient.getLearningPathDetail(id, limit: limit);
    return LearningPathDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<List<FeaturedCollectionDto>> featuredCollections() async {
    final response = await _apiClient.getFeaturedCollections();
    final data = _toList(response.data);
    return data
        .map((json) => FeaturedCollectionDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CollectionDto> collection(String id, {int limit = 10}) async {
    final response = await _apiClient.getCollection(id, limit: limit);
    return CollectionDto.fromJson(_toMap(response.data));
  }

  @override
  Future<CollectionDto> topicCollection(String type, String key, {int limit = 10}) async {
    final response = await _apiClient.getTopicCollection(type, key, limit: limit);
    return CollectionDto.fromJson(_toMap(response.data));
  }

  @override
  Future<RegionAtlasDto> regionAtlas() async {
    final response = await _apiClient.getRegionAtlas();
    return RegionAtlasDto.fromJson(_toMap(response.data));
  }

  @override
  Future<RegionAtlasDetailDto> regionAtlasDetail(String region, {int limit = 6}) async {
    final response = await _apiClient.getRegionAtlasDetail(region, limit: limit);
    return RegionAtlasDetailDto.fromJson(_toMap(response.data));
  }

  // ==================== 数据故事 ====================

  @override
  Future<DataStoryDto> regionStory(String region) async {
    final response = await _apiClient.getRegionStory(region);
    return DataStoryDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DataStoryDto> categoryStory(String category) async {
    final response = await _apiClient.getCategoryStory(category);
    return DataStoryDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DataStoryDto> yearStory(int year) async {
    final response = await _apiClient.getYearStory(year);
    return DataStoryDto.fromJson(_toMap(response.data));
  }

  // ==================== 主题库 ====================

  @override
  Future<TaxonomyIndexDto<TaxonomyTopicDto>> taxonomyCategories({int limit = 50}) async {
    final response = await _apiClient.getTaxonomyCategories(limit: limit);
    return TaxonomyIndexDto.fromJson(
      _toMap(response.data),
      (json) => TaxonomyTopicDto.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<TaxonomyIndexDto<TaxonomyTopicDto>> taxonomyRegions({int limit = 50}) async {
    final response = await _apiClient.getTaxonomyRegions(limit: limit);
    return TaxonomyIndexDto.fromJson(
      _toMap(response.data),
      (json) => TaxonomyTopicDto.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<TaxonomyIndexDto<TaxonomyKindDto>> taxonomyKinds() async {
    final response = await _apiClient.getTaxonomyKinds();
    return TaxonomyIndexDto.fromJson(
      _toMap(response.data),
      (json) => TaxonomyKindDto.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<TaxonomyCategoryDetailDto> taxonomyCategoryDetail(String category, {int limit = 6}) async {
    final response = await _apiClient.getTaxonomyCategoryDetail(category, limit: limit);
    return TaxonomyCategoryDetailDto.fromJson(_toMap(response.data));
  }

  @override
  Future<TaxonomyRegionDetailDto> taxonomyRegionDetail(String region, {int limit = 6}) async {
    final response = await _apiClient.getTaxonomyRegionDetail(region, limit: limit);
    return TaxonomyRegionDetailDto.fromJson(_toMap(response.data));
  }

  // ==================== 对比 ====================

  @override
  Future<CompareResultDto> compareRegions(String left, String right, {int limit = 6}) async {
    final response = await _apiClient.compareRegions(left, right, limit: limit);
    return CompareResultDto.fromJson(_toMap(response.data));
  }

  @override
  Future<CompareResultDto> compareCategories(String left, String right, {int limit = 6}) async {
    final response = await _apiClient.compareCategories(left, right, limit: limit);
    return CompareResultDto.fromJson(_toMap(response.data));
  }

  @override
  Future<CompareResultDto> compareKinds(String left, String right, {int limit = 6}) async {
    final response = await _apiClient.compareKinds(left, right, limit: limit);
    return CompareResultDto.fromJson(_toMap(response.data));
  }

  // ==================== 发现增强 ====================

  @override
  Future<DiscoveryTodayDto> discoveryToday() async {
    final response = await _apiClient.getDiscoveryToday();
    return DiscoveryTodayDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DiscoveryTrendingDto> discoveryTrending() async {
    final response = await _apiClient.getDiscoveryTrending();
    return DiscoveryTrendingDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DiscoveryWeeklyDto> discoveryWeekly() async {
    final response = await _apiClient.getDiscoveryWeekly();
    return DiscoveryWeeklyDto.fromJson(_toMap(response.data));
  }

  @override
  Future<DiscoveryItemDto?> discoverySerendipity() async {
    final response = await _apiClient.getDiscoverySerendipity();
    final data = response.data;
    if (data == null) return null;
    return DiscoveryItemDto.fromJson(_toMap(data));
  }

  @override
  Future<DiscoveryItemDto?> discoveryRandom({String? type}) async {
    final response = await _apiClient.getDiscoveryRandom(type: type);
    final data = response.data;
    if (data == null) return null;
    return DiscoveryItemDto.fromJson(_toMap(data));
  }

  // ==================== 时间线 ====================

  @override
  Future<List<TimelineYearBucketDto>> timelineYears() async {
    final response = await _apiClient.getTimelineYears();
    final data = _toList(response.data);
    return data
        .map((json) => TimelineYearBucketDto.fromJson(json as Map<String, dynamic>))
        .toList();
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
    final response = await _apiClient.getTimelineV2(
      year: year,
      types: types,
      page: page,
      pageSize: pageSize,
      category: category,
      region: region,
      kind: kind,
      hasImage: hasImage,
    );
    return TimelineV2ResponseDto.fromJson(_toMap(response.data));
  }
}
