import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';

/// 合集详情页 UI 状态
class CollectionDetailUiState {
  final bool isLoading;
  final CollectionDto? collection;
  final String? error;

  const CollectionDetailUiState({
    this.isLoading = true,
    this.collection,
    this.error,
  });

  CollectionDetailUiState copyWith({
    bool? isLoading,
    CollectionDto? collection,
    String? error,
    bool clearError = false,
  }) {
    return CollectionDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      collection: collection ?? this.collection,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
