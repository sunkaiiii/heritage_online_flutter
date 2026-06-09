import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/settings/settings_provider.dart';

import 'detail_cache_repository.dart';

/// 详情缓存 Repository Provider
final detailCacheRepositoryProvider = Provider<DetailCacheRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DetailCacheRepository(prefs: prefs);
});
