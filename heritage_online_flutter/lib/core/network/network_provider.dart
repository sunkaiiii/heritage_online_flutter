import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'api_config.dart';

/// API 配置 Provider
final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig.defaultConfig();
});

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(apiConfigProvider);
  return ApiClient(config: config);
});
