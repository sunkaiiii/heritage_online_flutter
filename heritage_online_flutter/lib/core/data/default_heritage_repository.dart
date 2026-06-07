import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/network/api_client.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

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
  }) async {
    final response = await _apiClient.getArticles(
      category: category,
      page: page,
      pageSize: pageSize,
      keywords: keywords,
      hasImage: hasImage,
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
}
