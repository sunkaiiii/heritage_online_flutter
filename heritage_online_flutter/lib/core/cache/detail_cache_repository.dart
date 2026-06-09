import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 详情缓存 Repository
/// 使用 SharedPreferences 缓存文章/名录/传承人详情的完整 JSON
/// 支持 LRU 淘汰和过期检测
class DetailCacheRepository {
  static const _articlePrefix = 'detail_cache_article_';
  static const _directoryPrefix = 'detail_cache_directory_';
  static const _inheritorPrefix = 'detail_cache_inheritor_';
  static const _articleIndexKey = 'detail_cache_article_index';
  static const _directoryIndexKey = 'detail_cache_directory_index';
  static const _inheritorIndexKey = 'detail_cache_inheritor_index';
  static const _maxEntriesPerType = 50;
  static const _staleThreshold = Duration(hours: 24);

  final SharedPreferences _prefs;

  DetailCacheRepository({required SharedPreferences prefs}) : _prefs = prefs; // ignore: prefer_initializing_formals

  // ==================== 文章缓存 ====================

  /// 获取缓存的文章详情
  Map<String, dynamic>? getArticleCache(String id) {
    return _getCache('$_articlePrefix$id');
  }

  /// 保存文章详情到缓存
  void saveArticleCache(String id, Map<String, dynamic> json) {
    _saveCache('$_articlePrefix$id', json);
    _updateIndex(_articleIndexKey, id);
    _evictIfNeeded(_articleIndexKey, _articlePrefix);
  }

  /// 清除文章缓存
  void clearArticleCache() {
    _clearTypeCache(_articleIndexKey, _articlePrefix);
  }

  // ==================== 名录缓存 ====================

  /// 获取缓存的名录详情
  Map<String, dynamic>? getDirectoryCache(String id) {
    return _getCache('$_directoryPrefix$id');
  }

  /// 保存名录详情到缓存
  void saveDirectoryCache(String id, Map<String, dynamic> json) {
    _saveCache('$_directoryPrefix$id', json);
    _updateIndex(_directoryIndexKey, id);
    _evictIfNeeded(_directoryIndexKey, _directoryPrefix);
  }

  /// 清除名录缓存
  void clearDirectoryCache() {
    _clearTypeCache(_directoryIndexKey, _directoryPrefix);
  }

  // ==================== 传承人缓存 ====================

  /// 获取缓存的传承人详情
  Map<String, dynamic>? getInheritorCache(String id) {
    return _getCache('$_inheritorPrefix$id');
  }

  /// 保存传承人详情到缓存
  void saveInheritorCache(String id, Map<String, dynamic> json) {
    _saveCache('$_inheritorPrefix$id', json);
    _updateIndex(_inheritorIndexKey, id);
    _evictIfNeeded(_inheritorIndexKey, _inheritorPrefix);
  }

  /// 清除传承人缓存
  void clearInheritorCache() {
    _clearTypeCache(_inheritorIndexKey, _inheritorPrefix);
  }

  // ==================== 通用方法 ====================

  /// 清除所有详情缓存
  void clearAll() {
    clearArticleCache();
    clearDirectoryCache();
    clearInheritorCache();
  }

  /// 获取缓存条目的时间戳，用于判断是否过期
  DateTime? getCacheTimestamp(String key) {
    final json = _prefs.getString(key);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      final timestamp = map['_cachedAt'] as int?;
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// 检查缓存是否过期
  bool isStale(String key) {
    final timestamp = getCacheTimestamp(key);
    if (timestamp == null) return true;
    return DateTime.now().difference(timestamp) > _staleThreshold;
  }

  /// 检查指定类型和 id 的缓存是否过期
  bool isStaleEntry(String type, String id) {
    String prefix;
    switch (type) {
      case 'article':
        prefix = _articlePrefix;
        break;
      case 'directory':
        prefix = _directoryPrefix;
        break;
      case 'inheritor':
        prefix = _inheritorPrefix;
        break;
      default:
        return true;
    }
    return isStale('$prefix$id');
  }

  // ==================== 内部方法 ====================

  /// 获取缓存条目
  Map<String, dynamic>? _getCache(String key) {
    final json = _prefs.getString(key);
    if (json == null) return null;
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error reading cache for $key: $e');
      }
      return null;
    }
  }

  /// 保存缓存条目，附带时间戳
  void _saveCache(String key, Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    data['_cachedAt'] = DateTime.now().millisecondsSinceEpoch;
    _prefs.setString(key, jsonEncode(data));
  }

  /// 更新索引（最近访问的 key 列表）
  void _updateIndex(String indexKey, String id) {
    final index = _getIndex(indexKey);
    index.remove(id); // 移除旧位置
    index.insert(0, id); // 插入到最前面
    _prefs.setString(indexKey, jsonEncode(index));
  }

  /// 获取索引列表
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

  /// LRU 淘汰：如果超过最大条目数，删除最旧的
  void _evictIfNeeded(String indexKey, String prefix) {
    final index = _getIndex(indexKey);
    while (index.length > _maxEntriesPerType) {
      final oldestId = index.removeLast();
      _prefs.remove('$prefix$oldestId');
    }
    _prefs.setString(indexKey, jsonEncode(index));
  }

  /// 清除指定类型的所有缓存
  void _clearTypeCache(String indexKey, String prefix) {
    final index = _getIndex(indexKey);
    for (final id in index) {
      _prefs.remove('$prefix$id');
    }
    _prefs.remove(indexKey);
  }
}
