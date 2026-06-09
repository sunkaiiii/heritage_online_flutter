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

  /// 注意：data 参数显式传递 null 可清空数据，省略则保留原值
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

/// 用于区分“未传递”与“显式传 null”的哨兵值
const Object _sentinel = Object();

/// 发现页 UI 状态
class DiscoveryUiState {
  /// 今日发现
  final DiscoverySectionState today;
  /// 正在被看见（趋势）
  final DiscoverySectionState trending;
  /// 本周非遗包
  final DiscoverySectionState weekly;
  /// 探索索引（主题、学习路径等会分别填充到子字段）
  final DiscoverySectionState exploreIndex;
  /// 探索主题列表
  final DiscoverySectionState<List<dynamic>> topics;
  /// 学习路径列表
  final DiscoverySectionState<List<dynamic>> learningPaths;
  /// 精选合集列表
  final DiscoverySectionState<List<dynamic>> collections;
  /// 地区图谱数据
  final DiscoverySectionState regionAtlas;
  /// 随便看看按钮 loading
  final bool serendipityLoading;

  const DiscoveryUiState({
    this.today = const DiscoverySectionState(),
    this.trending = const DiscoverySectionState(),
    this.weekly = const DiscoverySectionState(),
    this.exploreIndex = const DiscoverySectionState(),
    this.topics = const DiscoverySectionState(),
    this.learningPaths = const DiscoverySectionState(),
    this.collections = const DiscoverySectionState(),
    this.regionAtlas = const DiscoverySectionState(),
    this.serendipityLoading = false,
  });

  /// 是否有任何内容区块在加载
  bool get isAnyLoading =>
      today.isLoading ||
      trending.isLoading ||
      weekly.isLoading ||
      exploreIndex.isLoading ||
      topics.isLoading ||
      learningPaths.isLoading ||
      collections.isLoading ||
      regionAtlas.isLoading;

  /// 是否所有内容区块都加载失败（用于全页错误判断）
  bool get isAllFailed {
    final sections = [today, trending, weekly, exploreIndex, topics, learningPaths, collections, regionAtlas];
    return sections.every((s) => s.hasError);
  }

  DiscoveryUiState copyWith({
    DiscoverySectionState? today,
    DiscoverySectionState? trending,
    DiscoverySectionState? weekly,
    DiscoverySectionState? exploreIndex,
    DiscoverySectionState<List<dynamic>>? topics,
    DiscoverySectionState<List<dynamic>>? learningPaths,
    DiscoverySectionState<List<dynamic>>? collections,
    DiscoverySectionState? regionAtlas,
    bool? serendipityLoading,
  }) {
    return DiscoveryUiState(
      today: today ?? this.today,
      trending: trending ?? this.trending,
      weekly: weekly ?? this.weekly,
      exploreIndex: exploreIndex ?? this.exploreIndex,
      topics: topics ?? this.topics,
      learningPaths: learningPaths ?? this.learningPaths,
      collections: collections ?? this.collections,
      regionAtlas: regionAtlas ?? this.regionAtlas,
      serendipityLoading: serendipityLoading ?? this.serendipityLoading,
    );
  }
}
