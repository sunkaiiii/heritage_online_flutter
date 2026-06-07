import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

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
}
