import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'region_atlas_ui_state.dart';

/// 地区图谱首页 ViewModel
class RegionAtlasViewModel extends StateNotifier<RegionAtlasUiState> {
  final HeritageRepository _repository;

  RegionAtlasViewModel(this._repository) : super(const RegionAtlasUiState()) {
    loadAtlas();
  }

  /// 加载地区图谱
  Future<void> loadAtlas() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final atlas = await _repository.regionAtlas();
      state = state.copyWith(isLoading: false, atlas: atlas);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 重试加载
  void retry() {
    loadAtlas();
  }
}

/// 地区图谱首页 ViewModel Provider
final regionAtlasViewModelProvider =
    StateNotifierProvider.autoDispose<RegionAtlasViewModel, RegionAtlasUiState>((ref) {
  final repository = ref.watch(heritageRepositoryProvider);
  return RegionAtlasViewModel(repository);
});

/// 地区详情页 ViewModel
class RegionDetailViewModel extends StateNotifier<RegionDetailUiState> {
  final HeritageRepository _repository;
  final String region;

  RegionDetailViewModel(this._repository, this.region)
      : super(const RegionDetailUiState()) {
    loadDetail();
  }

  /// 加载地区详情
  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final detail = await _repository.regionAtlasDetail(region);
      state = state.copyWith(isLoading: false, detail: detail);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 重试加载
  void retry() {
    loadDetail();
  }
}

/// 地区详情页 ViewModel Provider（带 region 参数）
final regionDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<RegionDetailViewModel, RegionDetailUiState, String>((ref, region) {
  final repository = ref.watch(heritageRepositoryProvider);
  return RegionDetailViewModel(repository, region);
});
