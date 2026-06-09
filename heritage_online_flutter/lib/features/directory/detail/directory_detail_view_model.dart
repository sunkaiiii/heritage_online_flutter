// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/saved/saved.dart';

import 'directory_detail_ui_state.dart';

/// 名录详情 ViewModel
class DirectoryDetailViewModel extends StateNotifier<DirectoryDetailUiState> {
  final HeritageRepository _repository;
  final SavedContentRepository _savedRepository;
  final String? itemId;
  final String? sourceId;
  final DirectoryItemKind kind;

  DirectoryDetailViewModel({
    required HeritageRepository repository,
    required SavedContentRepository savedRepository,
    this.itemId,
    this.sourceId,
    this.kind = DirectoryItemKind.nationalProject,
  })  : _repository = repository,
        _savedRepository = savedRepository,
        super(const DirectoryDetailUiState()) {
    loadItem();
  }

  /// 加载名录详情
  Future<void> loadItem() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lookup = DirectoryDetailLookup(
        itemId: itemId,
        sourceId: sourceId,
        kind: kind,
      );

      final item = await _repository.directoryItemDetail(lookup);

      // 检查收藏状态
      final target = _buildTarget(item);
      final isFavorite = _savedRepository.isFavorite(target);

      state = state.copyWith(
        isLoading: false,
        item: item,
        isFavorite: isFavorite,
      );

      // 记录浏览
      _recordViewed(item);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
      kind: item.kind?.wireName,
    );
  }

  SavedContentSnapshot _buildSnapshot(dynamic item) {
    return SavedContentSnapshot(
      contentType: SavedContentType.directoryItem,
      id: item.id,
      title: item.title,
      summary: item.summary,
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
    return DirectoryDetailViewModel(
      repository: repository,
      savedRepository: savedRepository,
      itemId: params.itemId,
      sourceId: params.sourceId,
      kind: params.kind,
    );
  },
);
