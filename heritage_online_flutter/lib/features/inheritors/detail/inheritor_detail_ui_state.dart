import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';

/// 传承人详情 UI 状态
class InheritorDetailUiState {
  final bool isLoading;
  final InheritorDetailDto? item;
  final String? error;
  final bool isFavorite;

  const InheritorDetailUiState({
    this.isLoading = true,
    this.item,
    this.error,
    this.isFavorite = false,
  });

  InheritorDetailUiState copyWith({
    bool? isLoading,
    InheritorDetailDto? item,
    String? error,
    bool? isFavorite,
  }) {
    return InheritorDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      item: item ?? this.item,
      error: error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
