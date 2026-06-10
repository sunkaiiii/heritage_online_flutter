import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/discovery_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/explore_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/learning_path_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';

/// 发现区块状态
class DiscoverySectionState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const DiscoverySectionState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  bool get hasData => data != null;
  bool get hasError => error != null && !hasData;

  DiscoverySectionState<T> copyWith({
    bool? isLoading,
    Object? data = _sentinel,
    String? error,
  }) {
    return DiscoverySectionState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: identical(data, _sentinel) ? this.data : data as T?,
      error: error,
    );
  }
}

const Object _sentinel = Object();

/// 发现页 UI 状态
class DiscoveryUiState {
  final DiscoverySectionState<DiscoveryTodayDto> today;
  final DiscoverySectionState<DiscoveryTrendingDto> trending;
  final DiscoverySectionState<DiscoveryWeeklyDto> weekly;
  final DiscoverySectionState<List<ExploreTopicInfoDto>> topics;
  final DiscoverySectionState<List<LearningPathDto>> learningPaths;
  final DiscoverySectionState<List<FeaturedCollectionDto>> collections;
  final DiscoverySectionState<RegionAtlasDto> regionAtlas;
  final bool serendipityLoading;
  final DiscoveryItemDto? serendipityItem;

  const DiscoveryUiState({
    this.today = const DiscoverySectionState(),
    this.trending = const DiscoverySectionState(),
    this.weekly = const DiscoverySectionState(),
    this.topics = const DiscoverySectionState(),
    this.learningPaths = const DiscoverySectionState(),
    this.collections = const DiscoverySectionState(),
    this.regionAtlas = const DiscoverySectionState(),
    this.serendipityLoading = false,
    this.serendipityItem,
  });

  bool get isAnyLoading =>
      today.isLoading || trending.isLoading || weekly.isLoading ||
      topics.isLoading || learningPaths.isLoading ||
      collections.isLoading || regionAtlas.isLoading;

  bool get isAllFailed {
    final sections = [today, trending, weekly, topics, learningPaths, collections, regionAtlas];
    return sections.every((s) => s.hasError);
  }

  DiscoveryUiState copyWith({
    DiscoverySectionState<DiscoveryTodayDto>? today,
    DiscoverySectionState<DiscoveryTrendingDto>? trending,
    DiscoverySectionState<DiscoveryWeeklyDto>? weekly,
    DiscoverySectionState<List<ExploreTopicInfoDto>>? topics,
    DiscoverySectionState<List<LearningPathDto>>? learningPaths,
    DiscoverySectionState<List<FeaturedCollectionDto>>? collections,
    DiscoverySectionState<RegionAtlasDto>? regionAtlas,
    bool? serendipityLoading,
    DiscoveryItemDto? serendipityItem,
  }) {
    return DiscoveryUiState(
      today: today ?? this.today,
      trending: trending ?? this.trending,
      weekly: weekly ?? this.weekly,
      topics: topics ?? this.topics,
      learningPaths: learningPaths ?? this.learningPaths,
      collections: collections ?? this.collections,
      regionAtlas: regionAtlas ?? this.regionAtlas,
      serendipityLoading: serendipityLoading ?? this.serendipityLoading,
      serendipityItem: serendipityItem ?? this.serendipityItem,
    );
  }
}
