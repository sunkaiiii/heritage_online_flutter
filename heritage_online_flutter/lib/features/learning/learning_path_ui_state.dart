/// 学习路径详情 UI 状态
class LearningPathUiState {
  final bool isLoading;
  final String? error;
  final String? title;
  final String? subtitle;
  final List<String> tags;
  final int estimatedItemCount;
  final int stepCount;
  final List<LearningPathStep> steps;
  final List<LearningPathFeaturedItem> featuredItems;
  final List<LearningPathRelatedTopic> relatedTopics;

  const LearningPathUiState({
    this.isLoading = false,
    this.error,
    this.title,
    this.subtitle,
    this.tags = const [],
    this.estimatedItemCount = 0,
    this.stepCount = 0,
    this.steps = const [],
    this.featuredItems = const [],
    this.relatedTopics = const [],
  });

  LearningPathUiState copyWith({
    bool? isLoading,
    String? error,
    String? title,
    String? subtitle,
    List<String>? tags,
    int? estimatedItemCount,
    int? stepCount,
    List<LearningPathStep>? steps,
    List<LearningPathFeaturedItem>? featuredItems,
    List<LearningPathRelatedTopic>? relatedTopics,
  }) {
    return LearningPathUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      tags: tags ?? this.tags,
      estimatedItemCount: estimatedItemCount ?? this.estimatedItemCount,
      stepCount: stepCount ?? this.stepCount,
      steps: steps ?? this.steps,
      featuredItems: featuredItems ?? this.featuredItems,
      relatedTopics: relatedTopics ?? this.relatedTopics,
    );
  }
}

/// 学习路径步骤
class LearningPathStep {
  final int index;
  final String? title;
  final String? description;
  final List<LearningPathFeaturedItem> items;

  const LearningPathStep({
    this.index = 0,
    this.title,
    this.description,
    this.items = const [],
  });
}

/// 学习路径精选 item
class LearningPathFeaturedItem {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? imageUrl;
  final String? sourceId;
  final String? sourceUrl;
  final String? category;
  final String? kind;

  const LearningPathFeaturedItem({
    this.id,
    this.type,
    this.title,
    this.summary,
    this.imageUrl,
    this.sourceId,
    this.sourceUrl,
    this.category,
    this.kind,
  });

  bool get isArticle => type == 'article';
  bool get isDirectoryItem => type == 'directoryItem';
  bool get isInheritor => type == 'inheritor';
}

/// 相关主题
class LearningPathRelatedTopic {
  final String? type;
  final String? key;
  final String? title;

  const LearningPathRelatedTopic({this.type, this.key, this.title});
}
