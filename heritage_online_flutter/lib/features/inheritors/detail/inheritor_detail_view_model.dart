// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/saved/saved.dart';

import 'inheritor_detail_ui_state.dart';

/// 传承人详情 ViewModel
class InheritorDetailViewModel extends StateNotifier<InheritorDetailUiState> {
  final HeritageRepository _repository;
  final SavedContentRepository _savedRepository;
  final String? inheritorId;
  final String? sourceId;

  InheritorDetailViewModel({
    required HeritageRepository repository,
    required SavedContentRepository savedRepository,
    this.inheritorId,
    this.sourceId,
  })  : _repository = repository,
        _savedRepository = savedRepository,
        super(const InheritorDetailUiState()) {
    loadItem();
  }

  /// 加载传承人详情
  Future<void> loadItem() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lookup = InheritorDetailLookup(
        inheritorId: inheritorId,
        sourceId: sourceId,
      );

      final item = await _repository.inheritorDetail(lookup);

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
    );
  }

  SavedContentSnapshot _buildSnapshot(dynamic item) {
    return SavedContentSnapshot(
      contentType: SavedContentType.inheritor,
      id: item.id,
      title: item.name,
      summary: item.description,
      category: item.category,
      region: item.region,
      sourceUrl: item.sourceUrl,
      target: _buildTarget(item),
    );
  }

  void _recordViewed(dynamic item) {
    final snapshot = _buildSnapshot(item);
    _savedRepository.recordViewed(snapshot);
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
    final savedRepository = ref.watch(savedContentRepositoryProvider);
    return InheritorDetailViewModel(
      repository: repository,
      savedRepository: savedRepository,
      inheritorId: params.inheritorId,
      sourceId: params.sourceId,
    );
  },
);
