import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings_provider.dart';

import 'saved_content_repository.dart';
import 'saved_content_types.dart';

/// SavedContent Repository Provider
final savedContentRepositoryProvider = Provider<SavedContentRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SavedContentRepository(prefs: prefs);
});

/// 收藏列表 Provider
final favoritesProvider = Provider<List<SavedContentEntity>>((ref) {
  final repo = ref.watch(savedContentRepositoryProvider);
  return repo.getFavorites().where((e) => e.isFavorite).toList();
});

/// 最近浏览列表 Provider
final recentlyViewedProvider = Provider<List<SavedContentEntity>>((ref) {
  final repo = ref.watch(savedContentRepositoryProvider);
  return repo.getRecentlyViewed();
});

/// 收藏状态 Provider（按 target 查询）
final isFavoriteProvider = Provider.family<bool, SavedContentTarget>((ref, target) {
  final repo = ref.watch(savedContentRepositoryProvider);
  return repo.isFavorite(target);
});
