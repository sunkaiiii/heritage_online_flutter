import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings_provider.dart';

import 'saved_content_notifier.dart';
import 'saved_content_repository.dart';
import 'saved_content_types.dart';

/// SavedContent Repository Provider
final savedContentRepositoryProvider = Provider<SavedContentRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SavedContentRepository(prefs: prefs);
});

/// 收藏和最近浏览的响应式 Notifier Provider
final savedContentNotifierProvider =
    StateNotifierProvider<SavedContentNotifier, SavedContentState>((ref) {
  final repo = ref.watch(savedContentRepositoryProvider);
  return SavedContentNotifier(repo);
});

/// 收藏列表 Provider（从 notifier state 派生）
final favoritesProvider = Provider<List<SavedContentEntity>>((ref) {
  final notifierState = ref.watch(savedContentNotifierProvider);
  return notifierState.favorites;
});

/// 最近浏览列表 Provider（从 notifier state 派生）
final recentlyViewedProvider = Provider<List<SavedContentEntity>>((ref) {
  final notifierState = ref.watch(savedContentNotifierProvider);
  return notifierState.recentlyViewed;
});

/// 收藏状态 Provider（按 target 查询）
final isFavoriteProvider = Provider.family<bool, SavedContentTarget>((ref, target) {
  final notifier = ref.watch(savedContentNotifierProvider.notifier);
  return notifier.isFavorite(target);
});
