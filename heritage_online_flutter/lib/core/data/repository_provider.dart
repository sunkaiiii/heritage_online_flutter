import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/default_heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/network/network_provider.dart';

/// Heritage Repository Provider
/// UI 只依赖此 Provider，不直接依赖 API client
final heritageRepositoryProvider = Provider<HeritageRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DefaultHeritageRepository(apiClient: apiClient);
});
