// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/cache/detail_cache_provider.dart';
import 'package:heritage_online_flutter/core/cache/detail_cache_repository.dart';
import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/saved/saved.dart';

import 'directory_detail_ui_state.dart';

/// 名录详情 ViewModel
class DirectoryDetailViewModel extends StateNotifier<DirectoryDetailUiState> {
  final HeritageRepository _repository;
  final SavedContentRepository _savedRepository;
  final DetailCacheRepository _cacheRepository;
  final String? itemId;
  final String? sourceId;
  final DirectoryItemKind kind;

  DirectoryDetailViewModel({
    required HeritageRepository repository,
    required SavedContentRepository savedRepository,
    required DetailCacheRepository cacheRepository,
    this.itemId,
    this.sourceId,
    this.kind = DirectoryItemKind.nationalProject,
  })  : _repository = repository,
        _savedRepository = savedRepository,
        _cacheRepository = cacheRepository,
        super(const DirectoryDetailUiState()) {
    loadItem();
  }

  /// 加载名录详情（缓存优先）
  Future<void> loadItem() async {
    state = state.copyWith(isLoading: true, error: null, isStale: false);

    final lookup = DirectoryDetailLookup(
      itemId: itemId,
      sourceId: sourceId,
      kind: kind,
    );

    // 1. 尝试从缓存加载
    final cacheKey = itemId ?? sourceId;
    if (cacheKey != null && cacheKey.isNotEmpty) {
      final cached = _cacheRepository.getDirectoryCache(cacheKey);
      if (cached != null) {
        try {
          final item = DirectoryItemDetailDto.fromJson(cached);
          final target = _buildTarget(item);
          final isFavorite = _savedRepository.isFavorite(target);
          final isStale = _cacheRepository.isStaleEntry('directory', cacheKey);

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
    }

    // 2. 从网络刷新
    try {
      final item = await _repository.directoryItemDetail(lookup);

      final target = _buildTarget(item);
      final isFavorite = _savedRepository.isFavorite(target);

      state = state.copyWith(
        isLoading: false,
        item: item,
        isFavorite: isFavorite,
        isStale: false,
        error: null,
      );

      // 3. 更新缓存
      if (cacheKey != null && cacheKey.isNotEmpty) {
        _cacheRepository.saveDirectoryCache(cacheKey, item.toJson());
      }

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
    _savedRepository.toggleFavorite(snapshot);

    final target = _buildTarget(item);
    final isFavorite = _savedRepository.isFavorite(target);
    state = state.copyWith(isFavorite: isFavorite);
  }

  SavedContentTarget _buildTarget(dynamic item) {
    return SavedContentTarget(
      id: item.id,
      sourceId: sourceId,
      sourceUrl: item.sourceUrl,
      kind: item.kind.wireName,
    );
  }

  SavedContentSnapshot _buildSnapshot(dynamic item) {
    return SavedContentSnapshot(
      contentType: SavedContentType.directoryItem,
      id: item.id,
      title: item.title,
      summary: item.summary,
      coverImageJson: item.coverImage != null ? 'true' : null,
      category: item.category,
      region: item.region,
      year: item.publishedYear,
      sourceUrl: item.sourceUrl,
      target: _buildTarget(item),
    );
  }

  void _recordViewed(dynamic item) {
    final snapshot = _buildSnapshot(item);
    _savedRepository.recordViewed(snapshot);
  }
}

/// 名录详情参数
class DirectoryDetailParams {
  final String? itemId;
  final String? sourceId;
  final DirectoryItemKind kind;

  const DirectoryDetailParams({
    this.itemId,
    this.sourceId,
    this.kind = DirectoryItemKind.nationalProject,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DirectoryDetailParams &&
        other.itemId == itemId &&
        other.sourceId == sourceId &&
        other.kind == kind;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^ sourceId.hashCode ^ kind.hashCode;
  }
}

/// 名录详情 ViewModel Provider
final directoryDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<DirectoryDetailViewModel, DirectoryDetailUiState, DirectoryDetailParams>(
  (ref, params) {
    final repository = ref.watch(heritageRepositoryProvider);
    final savedRepository = ref.watch(savedContentRepositoryProvider);
    final cacheRepository = ref.watch(detailCacheRepositoryProvider);
    return DirectoryDetailViewModel(
      repository: repository,
      savedRepository: savedRepository,
      cacheRepository: cacheRepository,
      itemId: params.itemId,
      sourceId: params.sourceId,
      kind: params.kind,
    );
  },
);
