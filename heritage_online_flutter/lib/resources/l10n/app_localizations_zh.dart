// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '非遗在线';

  @override
  String get tabArticles => '文章';

  @override
  String get tabDirectory => '名录';

  @override
  String get tabInheritors => '传承人';

  @override
  String get tabDiscovery => '发现';

  @override
  String get commonRetry => '重试';

  @override
  String get commonLoading => '加载中...';

  @override
  String get commonError => '出错了';

  @override
  String get commonEmpty => '暂无数据';

  @override
  String get commonSeeAll => '查看全部';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSystem => '跟随系统';
}
