import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// 应用配置
/// 根据 debug/release 模式提供不同的配置值
class AppConfig {
  AppConfig._();

  /// 单例实例
  static final AppConfig instance = AppConfig._();

  /// API Base URL
  /// Debug: 指向本地后端
  ///   - Android 模拟器使用 https://10.0.2.2:5078 访问宿主机
  ///   - iOS 模拟器和桌面端使用 https://localhost:5078
  /// Release: 指向生产后端
  String get apiBaseUrl {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'https://10.0.2.2:5078';
      }
      return 'https://localhost:5078';
    }
    return 'https://heritage.example.com';
  }

  /// 是否信任自签名证书
  /// Debug: 允许自签名证书
  /// Release: 不允许自签名证书
  bool get trustSelfSigned => kDebugMode;

  /// 请求超时时间（秒）
  int get requestTimeoutSeconds => 30;

  /// 是否为 Debug 模式
  bool get isDebug => kDebugMode;

  /// 应用名称
  String get appName => 'Heritage Online';

  /// 应用版本
  String get appVersion => '1.0.0';
}
