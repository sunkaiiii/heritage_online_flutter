import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';

/// 名录详情 UI 状态
class DirectoryDetailUiState {
  final bool isLoading;
  final DirectoryItemDetailDto? item;
  final String? error;
  final bool isFavorite;

  const DirectoryDetailUiState({
    this.isLoading = true,
    this.item,
    this.error,
    this.isFavorite = false,
  });

  DirectoryDetailUiState copyWith({
    bool? isLoading,
    DirectoryItemDetailDto? item,
    String? error,
    bool? isFavorite,
  }) {
    return DirectoryDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      item: item ?? this.item,
      error: error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
