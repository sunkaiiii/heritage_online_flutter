import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reading_path_repository.dart';
import 'reading_path_types.dart';

/// 阅读路径的响应式 Notifier
/// 所有写操作都通过此 Notifier 进行，写入后自动更新 state
class ReadingPathNotifier extends StateNotifier<List<ReadingPathEvent>> {
  final ReadingPathRepository _repository;

  ReadingPathNotifier(this._repository) : super(const []) {
    _loadAll();
  }

  /// 从 SharedPreferences 加载所有数据
  void _loadAll() {
    state = _repository.getRecentPath();
  }

  /// 记录阅读路径事件
  void record(ReadingPathEvent event) {
    _repository.record(event);
    _loadAll();
  }

  /// 清空阅读路径
  void clear() {
    _repository.clear();
    _loadAll();
  }
}
