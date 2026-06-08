import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/models/detail_lookup.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'inheritor_detail_ui_state.dart';

/// 传承人详情 ViewModel
class InheritorDetailViewModel extends StateNotifier<InheritorDetailUiState> {
  final HeritageRepository _repository;
  final String? inheritorId;
  final String? sourceId;

  InheritorDetailViewModel({
    required HeritageRepository repository,
    this.inheritorId,
    this.sourceId,
  })  : _repository = repository,
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
    return InheritorDetailViewModel(
      repository: repository,
      inheritorId: params.inheritorId,
      sourceId: params.sourceId,
    );
  },
);
