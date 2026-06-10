import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'discovery_ui_state.dart';

/// 发现页 ViewModel
class DiscoveryViewModel extends StateNotifier<DiscoveryUiState> {
  final HeritageRepository _repository;

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
    state = state.copyWith(
      topics: state.topics.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.exploreTopics(limit: 12);
      state = state.copyWith(
        topics: state.topics.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      state = state.copyWith(
        topics: state.topics.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 加载学习路径
  Future<void> loadLearningPaths() async {
    state = state.copyWith(
      learningPaths: state.learningPaths.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.learningPaths();
      state = state.copyWith(
        learningPaths: state.learningPaths.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      state = state.copyWith(
        learningPaths: state.learningPaths.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 加载精选合集
  Future<void> loadFeaturedCollections() async {
    state = state.copyWith(
      collections: state.collections.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.featuredCollections();
      state = state.copyWith(
        collections: state.collections.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      state = state.copyWith(
        collections: state.collections.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// 加载地区图谱
  Future<void> loadRegionAtlas() async {
    state = state.copyWith(
      regionAtlas: state.regionAtlas.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.regionAtlas();
      state = state.copyWith(
        regionAtlas: state.regionAtlas.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      state = state.copyWith(
        regionAtlas: state.regionAtlas.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  // ==================== 发现增强 API ====================

  Future<void> loadToday() async {
    state = state.copyWith(
      today: state.today.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.discoveryToday();
      state = state.copyWith(
        today: state.today.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      state = state.copyWith(
        today: state.today.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> loadTrending() async {
    state = state.copyWith(
      trending: state.trending.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.discoveryTrending();
      state = state.copyWith(
        trending: state.trending.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
      state = state.copyWith(
        trending: state.trending.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> loadWeekly() async {
    state = state.copyWith(
      weekly: state.weekly.copyWith(isLoading: true, error: null),
    );
    try {
      final data = await _repository.discoveryWeekly();
      state = state.copyWith(
        weekly: state.weekly.copyWith(isLoading: false, data: data),
      );
    } catch (e) {
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
