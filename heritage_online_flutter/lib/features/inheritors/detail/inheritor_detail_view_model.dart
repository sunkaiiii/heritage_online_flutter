// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/cache/detail_cache_provider.dart';
import 'package:heritage_online_flutter/core/cache/detail_cache_repository.dart';
import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/saved/saved.dart';

import 'inheritor_detail_ui_state.dart';

/// 传承人详情 ViewModel
class InheritorDetailViewModel extends StateNotifier<InheritorDetailUiState> {
  final HeritageRepository _repository;
  final SavedContentNotifier _savedNotifier;
  final DetailCacheRepository _cacheRepository;
  final String? inheritorId;
  final String? sourceId;

  InheritorDetailViewModel({
    required HeritageRepository repository,
    required SavedContentNotifier savedNotifier,
    required DetailCacheRepository cacheRepository,
    this.inheritorId,
    this.sourceId,
  })  : _repository = repository,
        _savedNotifier = savedNotifier,
        _cacheRepository = cacheRepository,
        super(const InheritorDetailUiState()) {
    loadItem();
  }

  /// 加载传承人详情（缓存优先）
  Future<void> loadItem() async {
    state = state.copyWith(isLoading: true, error: null, isStale: false);

    final lookup = InheritorDetailLookup(
      inheritorId: inheritorId,
      sourceId: sourceId,
    );

    // 1. 尝试从缓存加载（alias-aware）
    final cached = _cacheRepository.getInheritorCacheWithFallback(
      inheritorId: inheritorId, sourceId: sourceId,
    );
    if (cached != null) {
      try {
        final item = InheritorDetailDto.fromJson(cached);
        final isFavorite = _checkIsFavorite(item);
        final isStale = _cacheRepository.isInheritorStale(
          inheritorId: inheritorId, sourceId: sourceId,
        );

        state = state.copyWith(
          isLoading: false,
          item: item,
          isFavorite: isFavorite,
          isStale: isStale,
        );
      } catch (_) {
        // 缓存解析失败，忽略
      }
    }

    // 2. 从网络刷新
    try {
      final item = await _repository.inheritorDetail(lookup);

      final isFavorite = _checkIsFavorite(item);

      state = state.copyWith(
        isLoading: false,
        item: item,
        isFavorite: isFavorite,
        isStale: false,
        error: null,
      );

      // 3. 更新缓存（保存所有 alias key）
      _cacheRepository.saveInheritorCacheWithAliases(
        id: item.id, sourceId: sourceId, json: item.toJson(),
      );

      // 记录浏览
      _recordViewed(item);
    } catch (e) {
      // 4. 网络失败：如果有缓存数据则显示 stale 提示，否则显示错误
      if (state.item != null) {
        state = state.copyWith(
          isLoading: false,
          isStale: true,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// 切换收藏状态
  void toggleFavorite() {
    final item = state.item;
    if (item == null) return;

    final snapshot = _buildSnapshot(item);
    _savedNotifier.toggleFavorite(snapshot);

    final isFavorite = _checkIsFavorite(item);
    state = state.copyWith(isFavorite: isFavorite);
  }

  bool _checkIsFavorite(dynamic item) {
    final target = _buildTarget(item);
    return _savedNotifier.isFavoriteWithType(SavedContentType.inheritor, target);
  }

  SavedContentTarget _buildTarget(dynamic item) {
    return SavedContentTarget(
      id: item.id,
      sourceId: sourceId,
      sourceUrl: item.sourceUrl,
    );
  }

  SavedContentSnapshot _buildSnapshot(dynamic item) {
    return SavedContentSnapshot(
      contentType: SavedContentType.inheritor,
      id: item.id,
      title: item.name,
      summary: item.description,
      coverImageJson: item.coverImage != null ? 'true' : null,
      category: item.category,
      region: item.region,
      sourceUrl: item.sourceUrl,
      target: _buildTarget(item),
    );
  }

  void _recordViewed(dynamic item) {
    final snapshot = _buildSnapshot(item);
    _savedNotifier.recordViewed(snapshot);
  }
}

/// 传承人详情参数
class InheritorDetailParams {
  final String? inheritorId;
  final String? sourceId;

  const InheritorDetailParams({
    this.inheritorId,
    this.sourceId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InheritorDetailParams &&
        other.inheritorId == inheritorId &&
        other.sourceId == sourceId;
  }

  @override
  int get hashCode {
    return inheritorId.hashCode ^ sourceId.hashCode;
  }
}

/// 传承人详情 ViewModel Provider
final inheritorDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<InheritorDetailViewModel, InheritorDetailUiState, InheritorDetailParams>(
  (ref, params) {
    final repository = ref.watch(heritageRepositoryProvider);
    final savedNotifier = ref.watch(savedContentNotifierProvider.notifier);
    final cacheRepository = ref.watch(detailCacheRepositoryProvider);
    return InheritorDetailViewModel(
      repository: repository,
      savedNotifier: savedNotifier,
      cacheRepository: cacheRepository,
      inheritorId: params.inheritorId,
      sourceId: params.sourceId,
    );
  },
);
