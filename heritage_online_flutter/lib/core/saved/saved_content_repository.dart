// ignore_for_file: prefer_initializing_formals

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'saved_content_types.dart';

/// 收藏和最近浏览 Repository
/// 使用 SharedPreferences 进行本地持久化
class SavedContentRepository {
  static const _favoritesKey = 'saved_content_favorites';
  static const _recentKey = 'saved_content_recent';

  final SharedPreferences _prefs;

  SavedContentRepository({required SharedPreferences prefs}) : _prefs = prefs;

  /// 获取收藏列表
  List<SavedContentEntity> getFavorites() {
    final json = _prefs.getString(_favoritesKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => _entityFromMap(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading favorites: $e');
      }
      return [];
    }
  }

  /// 获取最近浏览列表
  List<SavedContentEntity> getRecentlyViewed() {
    final json = _prefs.getString(_recentKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => _entityFromMap(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading recently viewed: $e');
      }
      return [];
    }
  }

  /// 检查是否已收藏
  bool isFavorite(SavedContentTarget target) {
    final key = SavedContentEntity.computeKeyFromTarget(target);
    final favorites = getFavorites();
    return favorites.any((e) => e.contentKey == key && e.isFavorite);
  }

  /// 切换收藏状态
  void toggleFavorite(SavedContentSnapshot snapshot) {
    final key = SavedContentEntity.computeKey(snapshot);
    final favorites = getFavorites();
    final index = favorites.indexWhere((e) => e.contentKey == key);

    if (index >= 0) {
      // 已存在，切换收藏状态
      final existing = favorites[index];
      if (existing.isFavorite) {
        // 取消收藏
        favorites[index] = existing.copyWith(
          isFavorite: false,
          favoritedAt: null,
        );
      } else {
        // 重新收藏
        favorites[index] = existing.copyWith(
          isFavorite: true,
          favoritedAt: DateTime.now().millisecondsSinceEpoch,
        );
      }
    } else {
      // 不存在，新增
      final entity = SavedContentEntity.fromSnapshot(snapshot).copyWith(
        isFavorite: true,
        favoritedAt: DateTime.now().millisecondsSinceEpoch,
      );
      favorites.add(entity);
    }

    _saveFavorites(favorites);
  }

  /// 记录浏览
  void recordViewed(SavedContentSnapshot snapshot) {
    final key = SavedContentEntity.computeKey(snapshot);
    final recent = getRecentlyViewed();
    final index = recent.indexWhere((e) => e.contentKey == key);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (index >= 0) {
      // 已存在，只更新 lastViewedAt
      recent[index] = recent[index].copyWith(lastViewedAt: now);
    } else {
      // 不存在，新增
      final entity = SavedContentEntity.fromSnapshot(snapshot);
      recent.add(entity);
    }

    // 按 lastViewedAt 降序排序
    recent.sort((a, b) => b.lastViewedAt.compareTo(a.lastViewedAt));

    _saveRecent(recent);
  }

  /// 删除收藏
  void removeFavorite(SavedContentTarget target) {
    final key = SavedContentEntity.computeKeyFromTarget(target);
    final favorites = getFavorites();
    favorites.removeWhere((e) => e.contentKey == key);
    _saveFavorites(favorites);
  }

  /// 删除最近浏览
  void removeRecent(SavedContentTarget target) {
    final key = SavedContentEntity.computeKeyFromTarget(target);
    final recent = getRecentlyViewed();
    recent.removeWhere((e) => e.contentKey == key);
    _saveRecent(recent);
  }

  /// 清空最近浏览
  void clearRecent() {
    _prefs.remove(_recentKey);
  }

  /// 保存收藏列表
  void _saveFavorites(List<SavedContentEntity> favorites) {
    final json = jsonEncode(favorites.map((e) => _entityToMap(e)).toList());
    _prefs.setString(_favoritesKey, json);
  }

  /// 保存最近浏览列表
  void _saveRecent(List<SavedContentEntity> recent) {
    final json = jsonEncode(recent.map((e) => _entityToMap(e)).toList());
    _prefs.setString(_recentKey, json);
  }

  /// 实体转 Map
  Map<String, dynamic> _entityToMap(SavedContentEntity entity) {
    return {
      'contentKey': entity.contentKey,
      'contentType': entity.contentType,
      'title': entity.title,
      'summary': entity.summary,
      'coverImageJson': entity.coverImageJson,
      'category': entity.category,
      'region': entity.region,
      'year': entity.year,
      'sourceUrl': entity.sourceUrl,
      'targetId': entity.targetId,
      'targetSourceId': entity.targetSourceId,
      'targetSourceUrl': entity.targetSourceUrl,
      'targetCategory': entity.targetCategory,
      'targetKind': entity.targetKind,
      'isFavorite': entity.isFavorite,
      'favoritedAt': entity.favoritedAt,
      'lastViewedAt': entity.lastViewedAt,
    };
  }

  /// Map 转实体
  SavedContentEntity _entityFromMap(Map<String, dynamic> map) {
    return SavedContentEntity(
      contentKey: map['contentKey'] ?? '',
      contentType: map['contentType'] ?? '',
      title: map['title'],
      summary: map['summary'],
      coverImageJson: map['coverImageJson'],
      category: map['category'],
      region: map['region'],
      year: map['year'],
      sourceUrl: map['sourceUrl'],
      targetId: map['targetId'],
      targetSourceId: map['targetSourceId'],
      targetSourceUrl: map['targetSourceUrl'],
      targetCategory: map['targetCategory'],
      targetKind: map['targetKind'],
      isFavorite: map['isFavorite'] ?? false,
      favoritedAt: map['favoritedAt'],
      lastViewedAt: map['lastViewedAt'] ?? 0,
    );
  }
}
