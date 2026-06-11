import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/api_error.dart';
import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';

import 'collection_ui_state.dart';

/// 合集详情参数
class CollectionDetailParams {
  final String? id;
  final String? type;
  final String? topicKey;

  const CollectionDetailParams({this.id, this.type, this.topicKey});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionDetailParams &&
          id == other.id &&
          type == other.type &&
          topicKey == other.topicKey;

  @override
  int get hashCode => Object.hash(id, type, topicKey);
}

/// 合集详情页 ViewModel
class CollectionDetailViewModel extends StateNotifier<CollectionDetailUiState> {
  final HeritageRepository _repository;
  final CollectionDetailParams params;

  CollectionDetailViewModel(this._repository, this.params)
      : super(const CollectionDetailUiState()) {
    loadCollection();
  }

  /// 加载合集详情
  Future<void> loadCollection() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final collection = await _fetchCollection();
      state = state.copyWith(isLoading: false, collection: collection);
    } on ApiError catch (e) {
      // 404 时返回空合集而非报错（context 中的合集 id 可能是 topic key）
      if (e.type == ApiErrorType.notFound) {
        state = state.copyWith(
          isLoading: false,
          collection: const CollectionDto(),
        );
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 重试加载
  void retry() {
    loadCollection();
  }

  /// 根据参数选择 API
  Future<dynamic> _fetchCollection() async {
    if (params.id != null && params.id!.isNotEmpty) {
      return _repository.collection(params.id!);
    }
    if (params.type != null &&
        params.type!.isNotEmpty &&
        params.topicKey != null &&
        params.topicKey!.isNotEmpty) {
      return _repository.topicCollection(params.type!, params.topicKey!);
    }
    throw ArgumentError('Missing collection identifier');
  }
}

/// 合集详情页 ViewModel Provider
final collectionDetailViewModelProvider = StateNotifierProvider.autoDispose
    .family<CollectionDetailViewModel, CollectionDetailUiState, CollectionDetailParams>(
  (ref, params) {
    final repository = ref.watch(heritageRepositoryProvider);
    return CollectionDetailViewModel(repository, params);
  },
);
