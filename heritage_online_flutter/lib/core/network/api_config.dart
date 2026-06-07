import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// API 配置
class ApiConfig {
  /// API 基础 URL
  final String baseUrl;

  /// 是否信任自签名证书（仅 debug）
  final bool trustSelfSigned;

  /// 请求超时时间（秒）
  final int timeoutSeconds;

  /// JSON 宽松解析策略
  final bool lenientJson;

  const ApiConfig({
    required this.baseUrl,
    this.trustSelfSigned = false,
    this.timeoutSeconds = 30,
    this.lenientJson = true,
  });

  /// 创建默认配置（根据 debug/release 和平台自动选择 baseUrl）
  factory ApiConfig.defaultConfig() {
    if (kDebugMode) {
      final baseUrl = Platform.isAndroid
          ? 'https://10.0.2.2:5078'
          : 'https://localhost:5078';
      return ApiConfig(
        baseUrl: baseUrl,
        trustSelfSigned: true,
        timeoutSeconds: 30,
        lenientJson: true,
      );
    }
    return const ApiConfig(
      baseUrl: 'https://heritage.example.com',
      trustSelfSigned: false,
      timeoutSeconds: 30,
      lenientJson: true,
    );
  }

  /// 创建 Debug 配置
  factory ApiConfig.debug() {
    return const ApiConfig(
      baseUrl: 'https://localhost:5078',
      trustSelfSigned: true,
      timeoutSeconds: 30,
      lenientJson: true,
    );
  }

  /// 创建 Release 配置
  factory ApiConfig.release() {
    return const ApiConfig(
      baseUrl: 'https://heritage.example.com',
      trustSelfSigned: false,
      timeoutSeconds: 30,
      lenientJson: true,
    );
  }

  /// 创建副本
  ApiConfig copyWith({
    String? baseUrl,
    bool? trustSelfSigned,
    int? timeoutSeconds,
    bool? lenientJson,
  }) {
    return ApiConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      trustSelfSigned: trustSelfSigned ?? this.trustSelfSigned,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      lenientJson: lenientJson ?? this.lenientJson,
    );
  }
}
