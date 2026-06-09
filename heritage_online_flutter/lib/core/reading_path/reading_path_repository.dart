// ignore_for_file: prefer_initializing_formals

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reading_path_types.dart';

/// 阅读路径 Repository
/// 使用 SharedPreferences 进行本地持久化
class ReadingPathRepository {
  static const _storageKey = 'reading_path_events';
  static const _defaultLimit = 50;

  final SharedPreferences _prefs;

  ReadingPathRepository({required SharedPreferences prefs}) : _prefs = prefs;

  /// 获取最近的阅读路径
  List<ReadingPathEvent> getRecentPath({int limit = _defaultLimit}) {
    final json = _prefs.getString(_storageKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      final events = list.map((e) => ReadingPathEvent.fromMap(e)).toList();
      // 按 createdAt 降序排序
      events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return events.take(limit).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading reading path: $e');
      }
      return [];
    }
  }

  /// 记录阅读路径事件
  /// 同一路径再次发生时更新 createdAt，不重复增加多条
  void record(ReadingPathEvent event) {
    final events = getRecentPath(limit: 1000); // 获取所有
    final stableKey = _stableKey(event);

    // 查找并移除已有相同路径的事件
    events.removeWhere((e) => _stableKey(e) == stableKey);

    // 插入到最前面
    events.insert(0, event);

    // 限制最大数量
    if (events.length > 200) {
      events.removeRange(200, events.length);
    }

    _saveEvents(events);
  }

  /// 生成稳定 key（spec 5.5 规则）
  /// {fromType}:{fromId}->{toType}:{toId}:{source}
  String _stableKey(ReadingPathEvent event) {
    return '${event.fromType ?? ""}:${event.fromId ?? ""}->${event.toType}:${event.toId}:${event.source}';
  }

  /// 清空阅读路径
  void clear() {
    _prefs.remove(_storageKey);
  }

  /// 保存事件列表
  void _saveEvents(List<ReadingPathEvent> events) {
    final json = jsonEncode(events.map((e) => e.toMap()).toList());
    _prefs.setString(_storageKey, json);
  }
}
