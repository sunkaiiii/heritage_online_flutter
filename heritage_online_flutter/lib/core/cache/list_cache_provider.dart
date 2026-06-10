import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings_provider.dart';

import 'list_cache_repository.dart';

/// 列表缓存 Repository Provider
final listCacheRepositoryProvider = Provider<ListCacheRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ListCacheRepository(prefs: prefs);
});
