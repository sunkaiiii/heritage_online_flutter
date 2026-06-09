import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';

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
  Future<dynamic> exploreIndex();

  /// 获取探索主题
  Future<List<dynamic>> exploreTopics({String? type, int limit = 20});

  /// 获取学习路径
  Future<List<dynamic>> learningPaths();

  /// 获取精选合集
  Future<List<dynamic>> featuredCollections();

  /// 获取地区图谱
  Future<dynamic> regionAtlas();

  // ==================== 发现增强 ====================

  /// 获取今日发现
  Future<dynamic> discoveryToday();

  /// 获取趋势内容
  Future<dynamic> discoveryTrending();

  /// 获取本周精选
  Future<dynamic> discoveryWeekly();

  /// 偶遇内容
  Future<dynamic> discoverySerendipity();

  /// 随机内容
  Future<dynamic> discoveryRandom({String? type});
}
