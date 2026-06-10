import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings_provider.dart';

import 'reading_path_notifier.dart';
import 'reading_path_repository.dart';
import 'reading_path_types.dart';

/// ReadingPath Repository Provider
final readingPathRepositoryProvider = Provider<ReadingPathRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ReadingPathRepository(prefs: prefs);
});

/// 阅读路径的响应式 Notifier Provider
final readingPathNotifierProvider =
    StateNotifierProvider<ReadingPathNotifier, List<ReadingPathEvent>>((ref) {
  final repo = ref.watch(readingPathRepositoryProvider);
  return ReadingPathNotifier(repo);
});

/// 阅读路径列表 Provider（从 notifier state 派生）
final readingPathProvider = Provider<List<ReadingPathEvent>>((ref) {
  final notifierState = ref.watch(readingPathNotifierProvider);
  return notifierState;
});
