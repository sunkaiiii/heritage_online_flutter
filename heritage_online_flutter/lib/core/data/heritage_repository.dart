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

import 'models/detail_lookup.dart';

/// Heritage Repository 接口
/// UI 只依赖 Repository，不直接依赖 API client
abstract class HeritageRepository {
  // ==================== 首页 ====================

  /// 获取首页 Banner
  Future<List<HomeBannerDto>> homeBanners();

  /// 获取首页 Feed
  Future<HomeFeedDto> homeFeed();

  // ==================== 文章 ====================

  /// 获取文章列表
  Future<PagedResult<ArticleSummaryDto>> articles({
    String? category,
    int? page,
    int? pageSize,
    String? keywords,
    bool? hasImage,
    int? year,
  });

  /// 获取文章详情 by id
  Future<ArticleDetailDto> article(String id);

  /// 获取文章详情 by sourceId
  Future<ArticleDetailDto> articleBySourceId(
    String sourceId, {
    ArticleCategory category = ArticleCategory.news,
  });

  /// 获取文章详情 by sourceUrl
  Future<ArticleDetailDto> articleBySourceUrl(
    String sourceUrl, {
    ArticleCategory category = ArticleCategory.news,
  });

  /// 通过 ArticleDetailLookup 获取文章详情
  /// 优先级：articleId > sourceId > sourceUrl
  Future<ArticleDetailDto> articleDetail(ArticleDetailLookup lookup);

  /// 获取文章 Context
  Future<DetailContextDto> articleContext(String id);

  /// 获取文章 Digest
  Future<ContentDigestDto> articleDigest(String id);

  // ==================== 名录 ====================

  /// 获取名录列表
  Future<PagedResult<DirectoryItemSummaryDto>> directoryItems({
    String? kind,
    int? page,
    int? pageSize,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? listType,
  });

  /// 获取名录详情 by id
  Future<DirectoryItemDetailDto> directoryItem(String id);

  /// 获取名录详情 by sourceId
  Future<DirectoryItemDetailDto> directoryItemBySourceId(
    String sourceId, {
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
  });

  /// 通过 DirectoryDetailLookup 获取名录详情
  /// 优先级：itemId > sourceId
  Future<DirectoryItemDetailDto> directoryItemDetail(DirectoryDetailLookup lookup);

  /// 获取名录统计总览
  Future<DirectoryStatisticsOverviewDto> directoryStatisticsOverview({
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
  });

  /// 获取名录统计 breakdown
  Future<DirectoryStatisticDimensionDto> directoryStatisticsBreakdown({
    DirectoryItemKind kind = DirectoryItemKind.nationalProject,
    required DirectoryStatisticDimension dimension,
    int limit = 50,
  });

  /// 获取名录 Context
  Future<DetailContextDto> directoryItemContext(String id);

  /// 获取名录 Digest
  Future<ContentDigestDto> directoryItemDigest(String id);

  // ==================== 传承人 ====================

  /// 获取传承人列表
  Future<PagedResult<InheritorSummaryDto>> inheritors({
    int? page,
    int? pageSize,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? gender,
  });

  /// 获取传承人详情 by id
  Future<InheritorDetailDto> inheritor(String id);

  /// 获取传承人详情 by sourceId
  Future<InheritorDetailDto> inheritorBySourceId(String sourceId);

  /// 通过 InheritorDetailLookup 获取传承人详情
  /// 优先级：inheritorId > sourceId
  Future<InheritorDetailDto> inheritorDetail(InheritorDetailLookup lookup);

  /// 获取传承人 Context
  Future<DetailContextDto> inheritorContext(String id);

  /// 获取传承人 Digest
  Future<ContentDigestDto> inheritorDigest(String id);

  // ==================== 推荐 ====================

  /// 获取综合推荐
  Future<BlendedRecommendationResponseDto> blendedRecommendations(
    String type,
    String id, {
    int limit = 10,
  });

  // ==================== 搜索 ====================

  /// 搜索 v2
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
  });

  /// 获取搜索建议
  Future<List<dynamic>> searchSuggestions(String prefix, {int limit = 10});

  // ==================== 发现页 ====================

  /// 获取探索索引
  Future<ExploreIndexDto> exploreIndex();

  /// 获取探索主题列表
  Future<List<ExploreTopicInfoDto>> exploreTopics({String? type, int limit = 20});

  /// 获取探索主题详情
  Future<ExploreTopicV2Dto> exploreTopic(String type, String key, {int limit = 6});

  /// 获取学习路径列表
  Future<List<LearningPathDto>> learningPaths();

  /// 获取学习路径详情
  Future<LearningPathDetailDto> learningPathDetail(String id, {int limit = 6});

  /// 获取精选合集
  Future<List<FeaturedCollectionDto>> featuredCollections();

  /// 获取合集详情
  Future<CollectionDto> collection(String id, {int limit = 10});

  /// 获取主题合集
  Future<CollectionDto> topicCollection(String type, String key, {int limit = 10});

  /// 获取地区图谱
  Future<RegionAtlasDto> regionAtlas();

  /// 获取地区图谱详情
  Future<RegionAtlasDetailDto> regionAtlasDetail(String region, {int limit = 6});

  // ==================== 数据故事 ====================

  /// 获取地区故事
  Future<DataStoryDto> regionStory(String region);

  /// 获取分类故事
  Future<DataStoryDto> categoryStory(String category);

  /// 获取年份故事
  Future<DataStoryDto> yearStory(int year);

  // ==================== 主题库 ====================

  /// 获取分类索引
  Future<TaxonomyIndexDto<TaxonomyTopicDto>> taxonomyCategories({int limit = 50});

  /// 获取地区索引
  Future<TaxonomyIndexDto<TaxonomyTopicDto>> taxonomyRegions({int limit = 50});

  /// 获取 kind 索引
  Future<TaxonomyIndexDto<TaxonomyKindDto>> taxonomyKinds();

  /// 获取分类详情
  Future<TaxonomyCategoryDetailDto> taxonomyCategoryDetail(String category, {int limit = 6});

  /// 获取地区详情
  Future<TaxonomyRegionDetailDto> taxonomyRegionDetail(String region, {int limit = 6});

  // ==================== 对比 ====================

  /// 地区对比
  Future<CompareResultDto> compareRegions(String left, String right, {int limit = 6});

  /// 分类对比
  Future<CompareResultDto> compareCategories(String left, String right, {int limit = 6});

  /// kind 对比
  Future<CompareResultDto> compareKinds(String left, String right, {int limit = 6});

  // ==================== 发现增强 ====================

  /// 获取今日发现
  Future<DiscoveryTodayDto> discoveryToday();

  /// 获取趋势内容
  Future<DiscoveryTrendingDto> discoveryTrending();

  /// 获取本周精选
  Future<DiscoveryWeeklyDto> discoveryWeekly();

  /// 偶遇内容
  Future<DiscoveryItemDto?> discoverySerendipity();

  /// 随机内容
  Future<DiscoveryItemDto?> discoveryRandom({String? type});

  // ==================== 时间线 ====================

  /// 获取时间线年份列表
  Future<List<TimelineYearBucketDto>> timelineYears();

  /// 获取时间线 v2 内容
  Future<TimelineV2ResponseDto> timelineV2({
    int? year,
    List<String>? types,
    int? page,
    int? pageSize,
    String? category,
    String? region,
    String? kind,
    bool? hasImage,
  });
}
