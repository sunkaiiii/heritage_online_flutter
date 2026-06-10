import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'discovery_ui_state.dart';

/// 发现页 ViewModel
class DiscoveryViewModel extends StateNotifier<DiscoveryUiState> {
  final HeritageRepository _repository;

  /// 各区块的请求版本号，用于竞态保护
  int _topicsVersion = 0;
  int _learningVersion = 0;
  int _collectionsVersion = 0;
  int _regionAtlasVersion = 0;
  int _todayVersion = 0;
  int _trendingVersion = 0;
  int _weeklyVersion = 0;

  DiscoveryViewModel(this._repository) : super(const DiscoveryUiState()) {
    loadAll();
  }

  /// 加载所有区块
  void loadAll() {
    loadTopics();
    loadLearningPaths();
    loadFeaturedCollections();
    loadRegionAtlas();
    loadToday();
    loadTrending();
    loadWeekly();
  }

  // ==================== 探索主题 ====================

  Future<void> loadTopics() async {
    final version = ++_topicsVersion;
    state = state.copyWith(
      topics: state.topics.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.exploreTopics(limit: 12);
      if (version != _topicsVersion) return;
      state = state.copyWith(
        topics: state.topics.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _topicsVersion) return;
      state = state.copyWith(
        topics: state.topics.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 加载学习路径
  Future<void> loadLearningPaths() async {
    final version = ++_learningVersion;
    state = state.copyWith(
      learningPaths: state.learningPaths.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.learningPaths();
      if (version != _learningVersion) return;
      state = state.copyWith(
        learningPaths: state.learningPaths.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _learningVersion) return;
      state = state.copyWith(
        learningPaths: state.learningPaths.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 加载精选合集
  Future<void> loadFeaturedCollections() async {
    final version = ++_collectionsVersion;
    state = state.copyWith(
      collections: state.collections.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.featuredCollections();
      if (version != _collectionsVersion) return;
      state = state.copyWith(
        collections: state.collections.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _collectionsVersion) return;
      state = state.copyWith(
        collections: state.collections.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 加载地区图谱
  Future<void> loadRegionAtlas() async {
    final version = ++_regionAtlasVersion;
    state = state.copyWith(
      regionAtlas: state.regionAtlas.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.regionAtlas();
      if (version != _regionAtlasVersion) return;
      state = state.copyWith(
        regionAtlas: state.regionAtlas.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _regionAtlasVersion) return;
      state = state.copyWith(
        regionAtlas: state.regionAtlas.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  // ==================== 发现增强 API ====================

  Future<void> loadToday() async {
    final version = ++_todayVersion;
    state = state.copyWith(
      today: state.today.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.discoveryToday();
      if (version != _todayVersion) return;
      state = state.copyWith(
        today: state.today.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _todayVersion) return;
      state = state.copyWith(
        today: state.today.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> loadTrending() async {
    final version = ++_trendingVersion;
    state = state.copyWith(
      trending: state.trending.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.discoveryTrending();
      if (version != _trendingVersion) return;
      state = state.copyWith(
        trending: state.trending.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _trendingVersion) return;
      state = state.copyWith(
        trending: state.trending.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> loadWeekly() async {
    final version = ++_weeklyVersion;
    state = state.copyWith(
      weekly: state.weekly.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.discoveryWeekly();
      if (version != _weeklyVersion) return;
      state = state.copyWith(
        weekly: state.weekly.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      if (version != _weeklyVersion) return;
      state = state.copyWith(
        weekly: state.weekly.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 随便看看
  Future<void> serendipity() async {
    state = state.copyWith(serendipityLoading: true);
    try {
      final item = await _repository.discoverySerendipity();
      state = state.copyWith(
        serendipityLoading: false,
        serendipityItem: item,
      );
    } catch (e) {
      state = state.copyWith(
        serendipityLoading: false,
        serendipityItem: null,
      );
    }
  }

  /// 刷新所有
  void refresh() {
    loadAll();
  }
}

/// 发现页 ViewModel Provider
final discoveryViewModelProvider =
    StateNotifierProvider<DiscoveryViewModel, DiscoveryUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return DiscoveryViewModel(repository);
});
