import 'package:dio/dio.dart';

import 'api_config.dart';
import 'http_client.dart';
import 'url_encoder.dart';

/// API Client
/// 统一网络入口，所有业务接口都从这里发出
class ApiClient {
  final HttpClient _httpClient;

  ApiClient({required ApiConfig config}) : _httpClient = HttpClient(config: config);

  /// GET 请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _httpClient.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  /// 构建 endpoint URL
  String endpoint(String path) {
    return '${_httpClient.config.baseUrl.trimRight()}/${path.trimLeft()}';
  }

  /// 编码 path segment
  String pathSegment(String value) {
    return UrlEncoder.encodePathSegment(value);
  }

  /// 添加可选参数
  /// 过滤 null、空字符串、空列表
  void addOptionalParam(Map<String, dynamic> params, String key, dynamic value) {
    if (value == null) return;
    if (value is String && value.trim().isEmpty) return;
    if (value is List && value.isEmpty) return;
    params[key] = value;
  }
}

/// API Client 扩展方法
/// 提供常用的 API 请求方法
extension ApiClientExtensions on ApiClient {
  /// 获取首页 Banner
  Future<Response> getHomeBanners() {
    return get('api/home-banners');
  }

  /// 获取首页 Feed
  Future<Response> getHomeFeed() {
    return get('api/home/feed');
  }

  /// 获取文章列表
  Future<Response> getArticles({
    String? category,
    int? page,
    int? pageSize,
    String? keywords,
    bool? hasImage,
    int? year,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'category', category);
    addOptionalParam(params, 'page', page);
    addOptionalParam(params, 'pageSize', pageSize);
    addOptionalParam(params, 'keywords', keywords);
    addOptionalParam(params, 'hasImage', hasImage);
    addOptionalParam(params, 'year', year);
    return get('api/articles', queryParameters: params);
  }

  /// 获取文章详情 by id
  Future<Response> getArticle(String id) {
    return get('api/articles/${pathSegment(id)}');
  }

  /// 获取文章详情 by sourceId
  Future<Response> getArticleBySourceId(String sourceId, {String? category}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'category', category);
    return get('api/articles/source/${pathSegment(sourceId)}', queryParameters: params);
  }

  /// 获取文章详情 by sourceUrl
  Future<Response> getArticleBySourceUrl(String sourceUrl, {String? category}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'url', sourceUrl);
    addOptionalParam(params, 'category', category);
    return get('api/articles/source', queryParameters: params);
  }

  /// 获取文章 Context
  Future<Response> getArticleContext(String id) {
    return get('api/articles/${pathSegment(id)}/context');
  }

  /// 获取文章 Digest
  Future<Response> getArticleDigest(String id) {
    return get('api/articles/${pathSegment(id)}/digest');
  }

  /// 获取名录列表
  Future<Response> getDirectoryItems({
    String? kind,
    int? page,
    int? pageSize,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? listType,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'kind', kind);
    addOptionalParam(params, 'page', page);
    addOptionalParam(params, 'pageSize', pageSize);
    addOptionalParam(params, 'keywords', keywords);
    addOptionalParam(params, 'region', region);
    addOptionalParam(params, 'category', category);
    addOptionalParam(params, 'year', year);
    addOptionalParam(params, 'listType', listType);
    return get('api/directory-items', queryParameters: params);
  }

  /// 获取名录详情 by id
  Future<Response> getDirectoryItem(String id) {
    return get('api/directory-items/${pathSegment(id)}');
  }

  /// 获取名录详情 by sourceId
  Future<Response> getDirectoryItemBySourceId(String sourceId, {String? kind}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'kind', kind);
    return get('api/directory-items/source/${pathSegment(sourceId)}', queryParameters: params);
  }

  /// 获取名录 Context
  Future<Response> getDirectoryItemContext(String id) {
    return get('api/directory-items/${pathSegment(id)}/context');
  }

  /// 获取名录 Digest
  Future<Response> getDirectoryItemDigest(String id) {
    return get('api/directory-items/${pathSegment(id)}/digest');
  }

  /// 获取名录统计总览
  Future<Response> getDirectoryStatisticsOverview({String? kind}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'kind', kind);
    return get('api/directory-items/statistics', queryParameters: params);
  }

  /// 获取名录统计 breakdown
  Future<Response> getDirectoryStatisticsBreakdown({
    String? kind,
    String? dimension,
    int? limit,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'kind', kind);
    addOptionalParam(params, 'dimension', dimension);
    addOptionalParam(params, 'limit', limit);
    return get('api/directory-items/statistics/breakdown', queryParameters: params);
  }

  /// 获取传承人列表
  Future<Response> getInheritors({
    int? page,
    int? pageSize,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? gender,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'page', page);
    addOptionalParam(params, 'pageSize', pageSize);
    addOptionalParam(params, 'keywords', keywords);
    addOptionalParam(params, 'region', region);
    addOptionalParam(params, 'category', category);
    addOptionalParam(params, 'year', year);
    addOptionalParam(params, 'gender', gender);
    return get('api/inheritors', queryParameters: params);
  }

  /// 获取传承人详情 by id
  Future<Response> getInheritor(String id) {
    return get('api/inheritors/${pathSegment(id)}');
  }

  /// 获取传承人详情 by sourceId
  Future<Response> getInheritorBySourceId(String sourceId) {
    return get('api/inheritors/source/${pathSegment(sourceId)}');
  }

  /// 获取传承人 Context
  Future<Response> getInheritorContext(String id) {
    return get('api/inheritors/${pathSegment(id)}/context');
  }

  /// 获取传承人 Digest
  Future<Response> getInheritorDigest(String id) {
    return get('api/inheritors/${pathSegment(id)}/digest');
  }

  /// 搜索 v2
  Future<Response> searchV2({
    String? query,
    List<String>? types,
    int? page,
    int? pageSize,
    String? region,
    String? category,
    int? year,
    String? kind,
    bool? hasImage,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'query', query);
    if (types != null && types.isNotEmpty) {
      params['types'] = types.join(',');
    }
    addOptionalParam(params, 'page', page);
    addOptionalParam(params, 'pageSize', pageSize);
    addOptionalParam(params, 'region', region);
    addOptionalParam(params, 'category', category);
    addOptionalParam(params, 'year', year);
    addOptionalParam(params, 'kind', kind);
    addOptionalParam(params, 'hasImage', hasImage);
    return get('api/search/v2', queryParameters: params);
  }

  /// 获取搜索建议
  Future<Response> getSearchSuggestions(String prefix, {int? limit}) {
    final params = <String, dynamic>{'prefix': prefix};
    addOptionalParam(params, 'limit', limit);
    return get('api/search/suggestions', queryParameters: params);
  }

  /// 获取时间线年份
  Future<Response> getTimelineYears() {
    return get('api/timeline/years');
  }

  /// 获取时间线 v2
  Future<Response> getTimelineV2({
    int? year,
    List<String>? types,
    int? page,
    int? pageSize,
    String? category,
    String? region,
    String? kind,
    bool? hasImage,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'year', year);
    if (types != null && types.isNotEmpty) {
      params['types'] = types.join(',');
    }
    addOptionalParam(params, 'page', page);
    addOptionalParam(params, 'pageSize', pageSize);
    addOptionalParam(params, 'category', category);
    addOptionalParam(params, 'region', region);
    addOptionalParam(params, 'kind', kind);
    addOptionalParam(params, 'hasImage', hasImage);
    return get('api/timeline/v2', queryParameters: params);
  }

  /// 获取探索索引
  Future<Response> getExploreIndex() {
    return get('api/explore');
  }

  /// 获取探索主题
  Future<Response> getExploreTopics({String? type, int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'type', type);
    addOptionalParam(params, 'limit', limit);
    return get('api/explore/topics', queryParameters: params);
  }

  /// 获取探索主题详情
  Future<Response> getExploreTopic(String type, String key, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/explore/topics/${pathSegment(type)}/${pathSegment(key)}', queryParameters: params);
  }

  /// 获取学习路径
  Future<Response> getLearningPaths() {
    return get('api/explore/learning-paths');
  }

  /// 获取学习路径详情
  Future<Response> getLearningPathDetail(String id, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/explore/learning-paths/${pathSegment(id)}', queryParameters: params);
  }

  /// 获取地区图谱
  Future<Response> getRegionAtlas() {
    return get('api/regions/atlas');
  }

  /// 获取地区图谱详情
  Future<Response> getRegionAtlasDetail(String region, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/regions/${pathSegment(region)}/atlas', queryParameters: params);
  }

  /// 获取精选合集
  Future<Response> getFeaturedCollections() {
    return get('api/collections/featured');
  }

  /// 获取合集详情
  Future<Response> getCollection(String id, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/collections/${pathSegment(id)}', queryParameters: params);
  }

  /// 获取主题合集
  Future<Response> getTopicCollection(String type, String key, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/collections/topic/${pathSegment(type)}/${pathSegment(key)}', queryParameters: params);
  }

  // ==================== 发现增强 ====================

  /// 获取今日发现
  Future<Response> getDiscoveryToday() {
    return get('api/discovery/today');
  }

  /// 获取趋势内容
  Future<Response> getDiscoveryTrending() {
    return get('api/discovery/trending');
  }

  /// 获取本周精选
  Future<Response> getDiscoveryWeekly() {
    return get('api/discovery/weekly');
  }

  /// 偶遇内容
  Future<Response> getDiscoverySerendipity() {
    return get('api/discovery/serendipity');
  }

  /// 随机内容
  Future<Response> getDiscoveryRandom({String? type}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'type', type);
    return get('api/discovery/random', queryParameters: params);
  }

  // ==================== 推荐 ====================

  /// 获取综合推荐
  Future<Response> getBlendedRecommendations(
    String type,
    String id, {
    int? limit,
    double? ruleWeight,
    double? semanticWeight,
    double? sameCategoryWeight,
    double? sameRegionWeight,
    bool? diversify,
  }) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    addOptionalParam(params, 'ruleWeight', ruleWeight);
    addOptionalParam(params, 'semanticWeight', semanticWeight);
    addOptionalParam(params, 'sameCategoryWeight', sameCategoryWeight);
    addOptionalParam(params, 'sameRegionWeight', sameRegionWeight);
    addOptionalParam(params, 'diversify', diversify);
    return get(
      'api/recommendations/blended/${pathSegment(type)}/${pathSegment(id)}',
      queryParameters: params,
    );
  }

  // ==================== 数据故事 ====================

  /// 获取地区故事
  Future<Response> getRegionStory(String region) {
    return get('api/stories/regions/${pathSegment(region)}');
  }

  /// 获取分类故事
  Future<Response> getCategoryStory(String category) {
    return get('api/stories/categories/${pathSegment(category)}');
  }

  /// 获取年份故事
  Future<Response> getYearStory(int year) {
    return get('api/stories/years/$year');
  }

  // ==================== 主题库 ====================

  /// 获取分类索引
  Future<Response> getTaxonomyCategories({int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/taxonomy/categories', queryParameters: params);
  }

  /// 获取地区索引
  Future<Response> getTaxonomyRegions({int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/taxonomy/regions', queryParameters: params);
  }

  /// 获取 kind 索引
  Future<Response> getTaxonomyKinds() {
    return get('api/taxonomy/kinds');
  }

  /// 获取分类详情
  Future<Response> getTaxonomyCategoryDetail(String category, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/taxonomy/category/${pathSegment(category)}',
        queryParameters: params);
  }

  /// 获取地区详情
  Future<Response> getTaxonomyRegionDetail(String region, {int? limit}) {
    final params = <String, dynamic>{};
    addOptionalParam(params, 'limit', limit);
    return get('api/taxonomy/region/${pathSegment(region)}',
        queryParameters: params);
  }

  // ==================== 对比 ====================

  /// 地区对比
  Future<Response> compareRegions(String left, String right, {int? limit}) {
    final params = <String, dynamic>{};
    params['left'] = left;
    params['right'] = right;
    addOptionalParam(params, 'limit', limit);
    return get('api/compare/regions', queryParameters: params);
  }

  /// 分类对比
  Future<Response> compareCategories(String left, String right, {int? limit}) {
    final params = <String, dynamic>{};
    params['left'] = left;
    params['right'] = right;
    addOptionalParam(params, 'limit', limit);
    return get('api/compare/categories', queryParameters: params);
  }

  /// kind 对比
  Future<Response> compareKinds(String left, String right, {int? limit}) {
    final params = <String, dynamic>{};
    params['left'] = left;
    params['right'] = right;
    addOptionalParam(params, 'limit', limit);
    return get('api/compare/kinds', queryParameters: params);
  }
}
