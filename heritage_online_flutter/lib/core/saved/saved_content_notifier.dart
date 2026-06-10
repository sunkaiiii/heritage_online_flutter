import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'saved_content_repository.dart';
import 'saved_content_types.dart';

/// 收藏和最近浏览的响应式状态
class SavedContentState {
  final List<SavedContentEntity> favorites;
  final List<SavedContentEntity> recentlyViewed;

  const SavedContentState({
    this.favorites = const [],
    this.recentlyViewed = const [],
  });

  SavedContentState copyWith({
    List<SavedContentEntity>? favorites,
    List<SavedContentEntity>? recentlyViewed,
  }) {
    return SavedContentState(
      favorites: favorites ?? this.favorites,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
    );
  }
}

/// 收藏和最近浏览的响应式 Notifier
/// 所有写操作都通过此 Notifier 进行，写入后自动更新 state
class SavedContentNotifier extends StateNotifier<SavedContentState> {
  final SavedContentRepository _repository;

  /// 内存中的收藏 key 集合，用于快速查询
  final Set<String> _favoriteKeys = {};

  SavedContentNotifier(this._repository) : super(const SavedContentState()) {
    _loadAll();
  }

  /// 从 SharedPreferences 加载所有数据
  void _loadAll() {
    final favorites = _repository
        .getFavorites()
        .where((e) => e.isFavorite)
        .toList();
    final recentlyViewed = _repository.getRecentlyViewed();

    // 更新内存中的 favorite key 集合
    _favoriteKeys
      ..clear()
      ..addAll(favorites.map((e) => e.contentKey));

    state = SavedContentState(
      favorites: favorites,
      recentlyViewed: recentlyViewed,
    );
  }

  /// 切换收藏状态
  void toggleFavorite(SavedContentSnapshot snapshot) {
    _repository.toggleFavorite(snapshot);
    _loadAll();
  }

  /// 记录浏览
  void recordViewed(SavedContentSnapshot snapshot) {
    _repository.recordViewed(snapshot);
    _loadAll();
  }

  /// 删除收藏
  void removeFavorite(SavedContentTarget target) {
    _repository.removeFavorite(target);
    _loadAll();
  }

  /// 删除最近浏览
  void removeRecent(SavedContentTarget target) {
    _repository.removeRecent(target);
    _loadAll();
  }

  /// 清空最近浏览
  void clearRecent() {
    _repository.clearRecent();
    _loadAll();
  }

  /// 检查是否已收藏（使用新 key 格式）
  bool isFavorite(SavedContentTarget target) {
    final key = SavedContentEntity.computeKeyFromTarget(target);
    if (key == null) return false;
    return _favoriteKeys.contains(key);
  }

  /// 检查是否已收藏（带 contentType，使用完整 key 格式）
  bool isFavoriteWithType(SavedContentType contentType, SavedContentTarget target) {
    final key = SavedContentEntity.computeKeyFromTargetWithType(contentType, target);
    if (key == null) return false;
    return _favoriteKeys.contains(key);
  }
}
