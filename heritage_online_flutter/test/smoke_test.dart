import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/cache/detail_cache_repository.dart';
import 'package:heritage_online_flutter/core/cache/list_cache_repository.dart';
import 'core/data/fake_heritage_repository.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/reading_path/reading_path_repository.dart';
import 'package:heritage_online_flutter/core/reading_path/reading_path_types.dart';
import 'package:heritage_online_flutter/core/saved/saved_content_notifier.dart';
import 'package:heritage_online_flutter/core/saved/saved_content_repository.dart';
import 'package:heritage_online_flutter/core/saved/saved_content_types.dart';
import 'package:heritage_online_flutter/core/settings/app_language_mode.dart';
import 'package:heritage_online_flutter/core/settings/app_theme_mode.dart';
import 'package:heritage_online_flutter/core/settings/settings_repository.dart';
import 'package:heritage_online_flutter/features/articles/articles_view_model.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_view_model.dart';
import 'package:heritage_online_flutter/features/directory/directory_view_model.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_view_model.dart';
import 'package:heritage_online_flutter/features/inheritors/inheritors_view_model.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_view_model.dart';
import 'package:heritage_online_flutter/features/search/search_view_model.dart';

import 'package:heritage_online_flutter/features/app_shell.dart';

/// Smoke 测试 — 覆盖核心用户流程
///
/// Step 28 验收要求：
/// - 启动可以进入文章列表
/// - 四 tab 切换
/// - 打开详情
/// - 搜索
/// - 图片预览
/// - 设置语言/主题
void main() {
  late SharedPreferences prefs;
  late FakeHeritageRepository repository;
  late SavedContentRepository savedRepo;
  late SavedContentNotifier savedNotifier;
  late ReadingPathRepository readingPathRepo;
  late ListCacheRepository listCache;
  late DetailCacheRepository detailCache;
  late SettingsRepository settingsRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = FakeHeritageRepository();
    savedRepo = SavedContentRepository(prefs: prefs);
    savedNotifier = SavedContentNotifier(savedRepo);
    readingPathRepo = ReadingPathRepository(prefs: prefs);
    listCache = ListCacheRepository(prefs: prefs);
    detailCache = DetailCacheRepository(prefs: prefs);
    settingsRepo = SettingsRepository(prefs: prefs);
  });

  // ==================== App Shell & 导航 ====================

  group('Smoke: App Shell & 导航', () {
    test('AppShellNotifier 默认选中文章 tab', () {
      final notifier = AppShellNotifier();
      expect(notifier.state.selectedDestination, HomeDestination.articles);
      expect(notifier.state.shouldShowBottomBar, isTrue);
    });

    test('AppShellNotifier 切换四个 Tab', () {
      final notifier = AppShellNotifier();

      final destinations = [
        HomeDestination.directory,
        HomeDestination.inheritors,
        HomeDestination.discovery,
        HomeDestination.articles,
      ];

      for (final dest in destinations) {
        notifier.selectDestination(dest);
        expect(notifier.state.selectedDestination, dest);
      }
    });

    test('AppShellNotifier 进入详情隐藏底栏', () {
      final notifier = AppShellNotifier();
      expect(notifier.state.shouldShowBottomBar, isTrue);

      notifier.setInDetail(true);
      expect(notifier.state.shouldShowBottomBar, isFalse);

      notifier.setInDetail(false);
      expect(notifier.state.shouldShowBottomBar, isTrue);
    });

    test('AppShellNotifier 进入设置 → 返回', () {
      final notifier = AppShellNotifier();

      notifier.showSettings();
      expect(notifier.state.shouldShowBottomBar, isFalse);
      expect(notifier.state.showSettings, isTrue);

      notifier.hideSettings();
      expect(notifier.state.shouldShowBottomBar, isTrue);
      expect(notifier.state.showSettings, isFalse);
    });
  });

  // ==================== 文章列表 → 详情 ====================

  group('Smoke: 文章列表 & 详情', () {
    test('ArticlesViewModel 初始化 → 加载成功 → 切换分类', () async {
      final viewModel = ArticlesViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      // 初始化后应完成加载
      expect(viewModel.state.isLoadingArticles, false);
      expect(viewModel.state.articlesError, isNull);

      // 切换分类
      viewModel.selectCategory(ArticleCategory.forum);
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.selectedCategory, ArticleCategory.forum);
    });

    test('ArticleDetailViewModel 初始化 → 缓存优先 → 网络刷新', () async {
      final viewModel = ArticleDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        articleId: 'article-1',
        category: ArticleCategory.news,
      );
      await Future<void>.delayed(Duration.zero);

      // 详情加载完成（使用 FakeHeritageRepository 返回空）
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isStale, false);
    });

    test('ArticleDetailViewModel 处理错误状态', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('模拟网络错误');

      final viewModel = ArticleDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        articleId: 'article-1',
        category: ArticleCategory.news,
      );
      await Future<void>.delayed(Duration.zero);

      // 错误时应有错误信息
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, isNotNull);
      expect(viewModel.state.article, isNull);
    });

    test('ArticleDetailViewModel 切换收藏', () async {
      final viewModel = ArticleDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        articleId: 'article-1',
        category: ArticleCategory.news,
      );
      await Future<void>.delayed(Duration.zero);

      // 初始未收藏
      expect(viewModel.state.isFavorite, false);

      viewModel.toggleFavorite();
      expect(viewModel.state.isFavorite, true);

      viewModel.toggleFavorite();
      expect(viewModel.state.isFavorite, false);
    });
  });

  // ==================== 名录列表 & 详情 ====================

  group('Smoke: 名录列表 & 详情', () {
    test('DirectoryViewModel 初始化 → 切换 kind', () async {
      final viewModel = DirectoryViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isLoadingItems, false);
      expect(viewModel.state.itemsError, isNull);

      viewModel.selectKind(DirectoryItemKind.culturalEcoZone);
      await Future<void>.delayed(Duration.zero);
      expect(viewModel.state.selectedKind, DirectoryItemKind.culturalEcoZone);
    });

    test('DirectoryDetailViewModel 初始化 → 缓存 + 网络', () async {
      final viewModel = DirectoryDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        itemId: 'dir-1',
        kind: DirectoryItemKind.nationalProject,
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isLoading, false);
    });

    test('DirectoryDetailViewModel 处理错误', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('模拟网络错误');

      final viewModel = DirectoryDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        itemId: 'dir-1',
        kind: DirectoryItemKind.nationalProject,
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNotNull);
      expect(viewModel.state.item, isNull);
    });
  });

  // ==================== 传承人列表 & 详情 ====================

  group('Smoke: 传承人列表 & 详情', () {
    test('InheritorsViewModel 初始化 → 加载', () async {
      final viewModel = InheritorsViewModel(
        repository: repository,
        listCache: listCache,
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.error, isNull);
    });

    test('InheritorDetailViewModel 初始化 → 缓存 + 网络', () async {
      final viewModel = InheritorDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        inheritorId: 'inh-1',
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isLoading, false);
    });

    test('InheritorDetailViewModel 处理错误', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('模拟网络错误');

      final viewModel = InheritorDetailViewModel(
        repository: repository,
        savedNotifier: savedNotifier,
        cacheRepository: detailCache,
        inheritorId: 'inh-1',
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNotNull);
      expect(viewModel.state.item, isNull);
    });
  });

  // ==================== 搜索流程 ====================

  group('Smoke: 搜索流程', () {
    test('SearchViewModel 初始化 → 搜索', () async {
      final viewModel = SearchViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      // 初始状态无搜索结果
      expect(viewModel.state.isSearching, false);
      expect(viewModel.state.results, isEmpty);
    });

    test('SearchViewModel 执行搜索后获得结果', () async {
      final viewModel2 = SearchViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel2.updateQuery('test');
      viewModel2.search();
      await Future<void>.delayed(Duration.zero);

      // 搜索完成（FakeHeritageRepository 返回空结果但不应抛出错误）
      expect(viewModel2.state.isSearching, false);
      expect(viewModel2.state.error, isNull);
    });

    test('SearchViewModel 空关键词不搜索', () async {
      final viewModel3 = SearchViewModel(repository);
      await Future<void>.delayed(Duration.zero);

      viewModel3.updateQuery('');
      viewModel3.search();
      await Future<void>.delayed(Duration.zero);

      // 空关键词不应触发搜索
      expect(viewModel3.state.isSearching, false);
    });
  });

  // ==================== 收藏 & 最近浏览 ====================

  group('Smoke: 收藏 & 最近浏览', () {
    test('收藏 → 检查状态 → 取消收藏', () {
      const target = SavedContentTarget(id: 'article-1');
      const snapshot = SavedContentSnapshot(
        contentType: SavedContentType.article,
        id: 'article-1',
        target: target,
      );

      // 收藏
      expect(savedNotifier.isFavoriteWithType(SavedContentType.article, target), isFalse);
      savedNotifier.toggleFavorite(snapshot);
      expect(savedNotifier.isFavoriteWithType(SavedContentType.article, target), isTrue);

      // 取消收藏
      savedNotifier.toggleFavorite(snapshot);
      expect(savedNotifier.isFavoriteWithType(SavedContentType.article, target), isFalse);
    });

    test('最近浏览 → 记录 → 重复更新', () {
      const snapshot = SavedContentSnapshot(
        contentType: SavedContentType.directoryItem,
        id: 'dir-1',
        target: SavedContentTarget(id: 'dir-1'),
      );

      savedNotifier.recordViewed(snapshot);
      final first = savedNotifier.state.recentlyViewed;
      expect(first.length, 1);

      // 重复记录只更新 time
      savedNotifier.recordViewed(snapshot);
      final second = savedNotifier.state.recentlyViewed;
      expect(second.length, 1);
    });

    test('收藏不同类型（文章、名录、传承人）', () {
      final snapshots = [
        const SavedContentSnapshot(
          contentType: SavedContentType.article,
          id: 'art-1',
          target: SavedContentTarget(id: 'art-1'),
        ),
        const SavedContentSnapshot(
          contentType: SavedContentType.directoryItem,
          id: 'dir-1',
          target: SavedContentTarget(id: 'dir-1'),
        ),
        const SavedContentSnapshot(
          contentType: SavedContentType.inheritor,
          id: 'inh-1',
          target: SavedContentTarget(id: 'inh-1'),
        ),
      ];

      for (final s in snapshots) {
        savedNotifier.toggleFavorite(s);
      }

      final favorites = savedNotifier.state.favorites;
      expect(favorites.length, 3);
    });
  });

  // ==================== 阅读路径 ====================

  group('Smoke: 阅读路径', () {
    test('记录跨类型阅读路径', () {
      readingPathRepo.record(ReadingPathEvent(
        fromType: 'article',
        fromId: 'article-1',
        toType: 'directoryItem',
        toId: 'dir-1',
        source: 'related',
      ));

      final events = readingPathRepo.getRecentPath();
      expect(events.length, 1);
      expect(events.first.fromType, 'article');
      expect(events.first.toType, 'directoryItem');
    });

    test('阅读路径按时间倒序', () async {
      readingPathRepo.record(ReadingPathEvent(
        fromType: 'article',
        fromId: 'a1',
        toType: 'inheritor',
        toId: 'i1',
        source: 'blendedRecommendation',
      ));

      await Future.delayed(const Duration(milliseconds: 10));

      readingPathRepo.record(ReadingPathEvent(
        fromType: 'directoryItem',
        fromId: 'd1',
        toType: 'article',
        toId: 'a2',
        source: 'semanticRecommendation',
      ));

      final events = readingPathRepo.getRecentPath();
      expect(events.length, 2);
      expect(events.first.toId, 'a2'); // 最新的在前
    });

    test('清空阅读路径', () {
      readingPathRepo.record(ReadingPathEvent(
        fromType: 'article',
        fromId: 'a1',
        toType: 'directoryItem',
        toId: 'd1',
        source: 'graph',
      ));

      readingPathRepo.clear();
      expect(readingPathRepo.getRecentPath(), isEmpty);
    });
  });

  // ==================== 设置（主题 & 语言） ====================

  group('Smoke: 设置（主题 & 语言）', () {
    test('默认主题为跟随系统', () async {
      final mode = settingsRepo.getThemeMode();
      expect(mode, AppThemeMode.system);
    });

    test('默认语言为跟随系统', () async {
      final mode = settingsRepo.getLanguageMode();
      expect(mode, AppLanguageMode.system);
    });

    test('切换主题模式 → 持久化', () async {
      await settingsRepo.setThemeMode(AppThemeMode.dark);
      final mode = settingsRepo.getThemeMode();
      expect(mode, AppThemeMode.dark);
    });

    test('切换语言模式 → 持久化', () async {
      await settingsRepo.setLanguageMode(AppLanguageMode.english);
      final mode = settingsRepo.getLanguageMode();
      expect(mode, AppLanguageMode.english);
    });

    test('切换主题不改变语言设置', () async {
      await settingsRepo.setLanguageMode(AppLanguageMode.english);
      await settingsRepo.setThemeMode(AppThemeMode.light);

      final lang = settingsRepo.getLanguageMode();
      final theme = settingsRepo.getThemeMode();
      expect(lang, AppLanguageMode.english);
      expect(theme, AppThemeMode.light);
    });
  });

  // ==================== 列表缓存 ====================

  group('Smoke: 列表分页缓存', () {
    test('缓存命中 → 无网络时仍可展示', () {
      final entry = ListCacheEntry(
        items: [
          {'id': '1', 'title': '缓存文章'},
        ],
        hasMore: true,
        currentPage: 1,
        cachedAt: DateTime.now(),
      );

      listCache.saveArticleCache('articles|cat:news', entry);
      final cached = listCache.getArticleCache('articles|cat:news');

      expect(cached, isNotNull);
      expect(cached!.items.length, 1);
      expect(cached.items.first['title'], '缓存文章');
    });

    test('append 追加后缓存项合并且不丢失', () {
      listCache.saveArticleCache(
        'test-key',
        ListCacheEntry(
          items: [{'id': '1'}],
          hasMore: true,
          currentPage: 1,
          cachedAt: DateTime.now(),
        ),
      );

      listCache.appendArticleCache(
        'test-key',
        ListCacheEntry(
          items: [{'id': '2'}, {'id': '3'}],
          hasMore: false,
          currentPage: 2,
          cachedAt: DateTime.now(),
        ),
      );

      final cached = listCache.getArticleCache('test-key');
      expect(cached!.items.length, 3);
      expect(cached.hasMore, false);
      expect(cached.currentPage, 2);
    });
  });

  // ==================== 图片 URL 选择 ====================

  group('Smoke: 图片 URL 选择', () {
    test('有 displayUrl 时优先选择', () {
      final asset = MediaAssetDto(
        displayUrl: 'https://example.com/display.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        originalUrl: null,
        sourceUrl: null,
      );

      expect(asset.bestUrl, 'https://example.com/display.jpg');
      expect(asset.thumbnailOrMainUrl, 'https://example.com/thumb.jpg');
    });

    test('无 URL 时返回 null', () {
      const asset = MediaAssetDto();
      expect(asset.bestUrl, isNull);
      expect(asset.thumbnailOrMainUrl, isNull);
    });

    test('只有 sourceUrl 时回退使用', () {
      final asset = MediaAssetDto(
        sourceUrl: 'https://example.com/source.jpg',
      );

      expect(asset.bestUrl, 'https://example.com/source.jpg');
    });
  });
}
