import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

import 'directory_detail_ui_state.dart';

/// 名录详情 ViewModel
class DirectoryDetailViewModel extends StateNotifier<DirectoryDetailUiState> {
  final HeritageRepository _repository;
  final String? itemId;
  final String? sourceId;
  final DirectoryItemKind kind;

  DirectoryDetailViewModel({
    required HeritageRepository repository,
    this.itemId,
    this.sourceId,
    this.kind = DirectoryItemKind.nationalProject,
  })  : _repository = repository,
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
      state = state.copyWith(
        isLoading: false,
        item: item,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 切换收藏状态
  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
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
    return DirectoryDetailViewModel(
      repository: repository,
      itemId: params.itemId,
      sourceId: params.sourceId,
      kind: params.kind,
    );
  },
);
