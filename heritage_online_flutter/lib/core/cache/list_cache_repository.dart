import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 列表分页缓存 Repository
/// 基于 queryKey 缓存列表数据，支持 refresh 替换和 append 追加
class ListCacheRepository {
  static const _articlePrefix = 'list_cache_article_';
  static const _directoryPrefix = 'list_cache_directory_';
  static const _inheritorPrefix = 'list_cache_inheritor_';
  static const _articleIndexKey = 'list_cache_article_index';
  static const _directoryIndexKey = 'list_cache_directory_index';
  static const _inheritorIndexKey = 'list_cache_inheritor_index';
  static const _maxEntriesPerType = 20;

  final SharedPreferences _prefs;

  ListCacheRepository({required SharedPreferences prefs}) : _prefs = prefs; // ignore: prefer_initializing_formals

  // ==================== 文章列表缓存 ====================

  /// 获取文章列表缓存
  ListCacheEntry? getArticleCache(String queryKey) {
    return _getCache('$_articlePrefix$queryKey');
  }

  /// 保存文章列表缓存（refresh：替换）
  void saveArticleCache(String queryKey, ListCacheEntry entry) {
    _saveCache('$_articlePrefix$queryKey', entry);
    _updateIndex(_articleIndexKey, queryKey);
    _evictIfNeeded(_articleIndexKey, _articlePrefix);
  }

  /// 追加文章列表缓存（append：追加 items，按 id 去重）
  void appendArticleCache(String queryKey, ListCacheEntry newEntry) {
    final existing = getArticleCache(queryKey);
    if (existing != null) {
      final merged = _mergeWithDedup(existing.items, newEntry.items);
      final entry = ListCacheEntry(
        items: merged,
        hasMore: newEntry.hasMore,
        currentPage: newEntry.currentPage,
        cachedAt: DateTime.now(),
      );
      _saveCache('$_articlePrefix$queryKey', entry);
    } else {
      saveArticleCache(queryKey, newEntry);
    }
  }

  /// 清除文章列表缓存
  void clearArticleCache() {
    _clearTypeCache(_articleIndexKey, _articlePrefix);
  }

  // ==================== 名录列表缓存 ====================

  /// 获取名录列表缓存
  ListCacheEntry? getDirectoryCache(String queryKey) {
    return _getCache('$_directoryPrefix$queryKey');
  }

  /// 保存名录列表缓存（refresh：替换）
  void saveDirectoryCache(String queryKey, ListCacheEntry entry) {
    _saveCache('$_directoryPrefix$queryKey', entry);
    _updateIndex(_directoryIndexKey, queryKey);
    _evictIfNeeded(_directoryIndexKey, _directoryPrefix);
  }

  /// 追加名录列表缓存（append：追加 items，按 id 去重）
  void appendDirectoryCache(String queryKey, ListCacheEntry newEntry) {
    final existing = getDirectoryCache(queryKey);
    if (existing != null) {
      final merged = _mergeWithDedup(existing.items, newEntry.items);
      final entry = ListCacheEntry(
        items: merged,
        hasMore: newEntry.hasMore,
        currentPage: newEntry.currentPage,
        cachedAt: DateTime.now(),
      );
      _saveCache('$_directoryPrefix$queryKey', entry);
    } else {
      saveDirectoryCache(queryKey, newEntry);
    }
  }

  /// 清除名录列表缓存
  void clearDirectoryCache() {
    _clearTypeCache(_directoryIndexKey, _directoryPrefix);
  }

  // ==================== 传承人列表缓存 ====================

  /// 获取传承人列表缓存
  ListCacheEntry? getInheritorCache(String queryKey) {
    return _getCache('$_inheritorPrefix$queryKey');
  }

  /// 保存传承人列表缓存（refresh：替换）
  void saveInheritorCache(String queryKey, ListCacheEntry entry) {
    _saveCache('$_inheritorPrefix$queryKey', entry);
    _updateIndex(_inheritorIndexKey, queryKey);
    _evictIfNeeded(_inheritorIndexKey, _inheritorPrefix);
  }

  /// 追加传承人列表缓存（append：追加 items，按 id 去重）
  void appendInheritorCache(String queryKey, ListCacheEntry newEntry) {
    final existing = getInheritorCache(queryKey);
    if (existing != null) {
      final merged = _mergeWithDedup(existing.items, newEntry.items);
      final entry = ListCacheEntry(
        items: merged,
        hasMore: newEntry.hasMore,
        currentPage: newEntry.currentPage,
        cachedAt: DateTime.now(),
      );
      _saveCache('$_inheritorPrefix$queryKey', entry);
    } else {
      saveInheritorCache(queryKey, newEntry);
    }
  }

  /// 清除传承人列表缓存
  void clearInheritorCache() {
    _clearTypeCache(_inheritorIndexKey, _inheritorPrefix);
  }

  // ==================== 通用方法 ====================

  /// 清除所有列表缓存
  void clearAll() {
    clearArticleCache();
    clearDirectoryCache();
    clearInheritorCache();
  }

  // ==================== 内部方法 ====================

  ListCacheEntry? _getCache(String key) {
    final json = _prefs.getString(key);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return ListCacheEntry.fromMap(map);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error reading list cache for $key: $e');
      }
      return null;
    }
  }

  void _saveCache(String key, ListCacheEntry entry) {
    _prefs.setString(key, jsonEncode(entry.toMap()));
  }

  void _updateIndex(String indexKey, String queryKey) {
    final index = _getIndex(indexKey);
    index.remove(queryKey);
    index.insert(0, queryKey);
    _prefs.setString(indexKey, jsonEncode(index));
  }

  List<String> _getIndex(String indexKey) {
    final json = _prefs.getString(indexKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  /// 合并两个 item 列表，按 id/sourceId 去重
  List<Map<String, dynamic>> _mergeWithDedup(
    List<Map<String, dynamic>> existing,
    List<Map<String, dynamic>> incoming,
  ) {
    final seenIds = <String>{};
    final merged = <Map<String, dynamic>>[];

    for (final item in existing) {
      final id = item['id']?.toString() ?? item['sourceId']?.toString() ?? '';
      if (id.isNotEmpty && seenIds.contains(id)) continue;
      if (id.isNotEmpty) seenIds.add(id);
      merged.add(item);
    }

    for (final item in incoming) {
      final id = item['id']?.toString() ?? item['sourceId']?.toString() ?? '';
      if (id.isNotEmpty && seenIds.contains(id)) continue;
      if (id.isNotEmpty) seenIds.add(id);
      merged.add(item);
    }

    return merged;
  }

  void _evictIfNeeded(String indexKey, String prefix) {
    final index = _getIndex(indexKey);
    while (index.length > _maxEntriesPerType) {
      final oldestKey = index.removeLast();
      _prefs.remove('$prefix$oldestKey');
    }
    _prefs.setString(indexKey, jsonEncode(index));
  }

  void _clearTypeCache(String indexKey, String prefix) {
    final index = _getIndex(indexKey);
    for (final key in index) {
      _prefs.remove('$prefix$key');
    }
    _prefs.remove(indexKey);
  }
}

/// 列表缓存条目
class ListCacheEntry {
  final List<Map<String, dynamic>> items;
  final bool hasMore;
  final int currentPage;
  final DateTime cachedAt;

  const ListCacheEntry({
    required this.items,
    required this.hasMore,
    required this.currentPage,
    required this.cachedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'hasMore': hasMore,
      'currentPage': currentPage,
      'cachedAt': cachedAt.millisecondsSinceEpoch,
    };
  }

  factory ListCacheEntry.fromMap(Map<String, dynamic> map) {
    return ListCacheEntry(
      items: (map['items'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      hasMore: map['hasMore'] ?? false,
      currentPage: map['currentPage'] ?? 1,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(
        map['cachedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

/// queryKey 构建工具
class QueryKeyBuilder {
  QueryKeyBuilder._();

  /// 构建文章列表 queryKey
  static String articles({
    String? category,
    String? keywords,
    int? year,
  }) {
    final parts = <String>['articles'];
    if (category != null && category.isNotEmpty) parts.add('cat:$category');
    if (keywords != null && keywords.isNotEmpty) parts.add('kw:$keywords');
    if (year != null) parts.add('y:$year');
    return parts.join('|');
  }

  /// 构建名录列表 queryKey
  static String directoryItems({
    String? kind,
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? listType,
  }) {
    final parts = <String>['directory'];
    if (kind != null && kind.isNotEmpty) parts.add('kind:$kind');
    if (keywords != null && keywords.isNotEmpty) parts.add('kw:$keywords');
    if (region != null && region.isNotEmpty) parts.add('reg:$region');
    if (category != null && category.isNotEmpty) parts.add('cat:$category');
    if (year != null) parts.add('y:$year');
    if (listType != null && listType.isNotEmpty) parts.add('lt:$listType');
    return parts.join('|');
  }

  /// 构建传承人列表 queryKey
  static String inheritors({
    String? keywords,
    String? region,
    String? category,
    int? year,
    String? gender,
  }) {
    final parts = <String>['inheritors'];
    if (keywords != null && keywords.isNotEmpty) parts.add('kw:$keywords');
    if (region != null && region.isNotEmpty) parts.add('reg:$region');
    if (category != null && category.isNotEmpty) parts.add('cat:$category');
    if (year != null) parts.add('y:$year');
    if (gender != null && gender.isNotEmpty) parts.add('g:$gender');
    return parts.join('|');
  }
}
