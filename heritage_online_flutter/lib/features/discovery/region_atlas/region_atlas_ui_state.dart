import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';

/// 地区图谱首页 UI 状态
class RegionAtlasUiState {
  final bool isLoading;
  final RegionAtlasDto? atlas;
  final String? error;

  const RegionAtlasUiState({
    this.isLoading = true,
    this.atlas,
    this.error,
  });

  RegionAtlasUiState copyWith({
    bool? isLoading,
    RegionAtlasDto? atlas,
    String? error,
    bool clearError = false,
  }) {
    return RegionAtlasUiState(
      isLoading: isLoading ?? this.isLoading,
      atlas: atlas ?? this.atlas,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// 地区详情页 UI 状态
class RegionDetailUiState {
  final bool isLoading;
  final RegionAtlasDetailDto? detail;
  final String? error;

  const RegionDetailUiState({
    this.isLoading = true,
    this.detail,
    this.error,
  });

  RegionDetailUiState copyWith({
    bool? isLoading,
    RegionAtlasDetailDto? detail,
    String? error,
    bool clearError = false,
  }) {
    return RegionDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
