/// 环境配置
/// 用于区分不同环境的配置
enum Environment {
  /// 开发环境
  development,

  /// 测试环境
  staging,

  /// 生产环境
  production,
}

/// 环境配置管理
class EnvConfig {
  EnvConfig._();

  static final EnvConfig instance = EnvConfig._();

  /// 当前环境
  Environment _environment = Environment.development;

  /// 获取当前环境
  Environment get environment => _environment;

  /// 设置当前环境
  void setEnvironment(Environment env) {
    _environment = env;
  }

  /// 是否为开发环境
  bool get isDevelopment => _environment == Environment.development;

  /// 是否为测试环境
  bool get isStaging => _environment == Environment.staging;

  /// 是否为生产环境
  bool get isProduction => _environment == Environment.production;

  /// 根据环境获取 API Base URL
  String getApiBaseUrl() {
    switch (_environment) {
      case Environment.development:
        return 'https://localhost:5078';
      case Environment.staging:
        return 'https://staging.heritage.example.com';
      case Environment.production:
        return 'https://heritage.example.com';
    }
  }

  /// 是否信任自签名证书
  bool get trustSelfSigned => _environment != Environment.production;
}
