/// 探索主题详情 UI 状态
class ExploreTopicUiState {
  final bool isLoading;
  final String? error;
  final String? title;
  final String? subtitle;
  final String? type;
  final String? key;
  final int total;
  final int articleCount;
  final int directoryItemCount;
  final int inheritorCount;
  final List<TopicSection> sections;
  final List<TopicTimelineItem> timeline;
  final List<TopicRelatedItem> relatedTopics;
  final List<TopicSectionItem> featuredItems;

  const ExploreTopicUiState({
    this.isLoading = false,
    this.error,
    this.title,
    this.subtitle,
    this.type,
    this.key,
    this.total = 0,
    this.articleCount = 0,
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.sections = const [],
    this.timeline = const [],
    this.relatedTopics = const [],
    this.featuredItems = const [],
  });

  ExploreTopicUiState copyWith({
    bool? isLoading,
    String? error,
    String? title,
    String? subtitle,
    String? type,
    String? key,
    int? total,
    int? articleCount,
    int? directoryItemCount,
    int? inheritorCount,
    List<TopicSection>? sections,
    List<TopicTimelineItem>? timeline,
    List<TopicRelatedItem>? relatedTopics,
    List<TopicSectionItem>? featuredItems,
  }) {
    return ExploreTopicUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      key: key ?? this.key,
      total: total ?? this.total,
      articleCount: articleCount ?? this.articleCount,
      directoryItemCount: directoryItemCount ?? this.directoryItemCount,
      inheritorCount: inheritorCount ?? this.inheritorCount,
      sections: sections ?? this.sections,
      timeline: timeline ?? this.timeline,
      relatedTopics: relatedTopics ?? this.relatedTopics,
      featuredItems: featuredItems ?? this.featuredItems,
    );
  }
}

/// 主题 Section
class TopicSection {
  final String? title;
  final String? subtitle;
  final List<TopicSectionItem> items;

  const TopicSection({
    this.title,
    this.subtitle,
    this.items = const [],
  });
}

/// Section 中的 item
class TopicSectionItem {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? imageUrl;
  final String? sourceId;
  final String? sourceUrl;
  final String? category;
  final String? kind;

  const TopicSectionItem({
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

/// 时间线条目
class TopicTimelineItem {
  final String? year;
  final String? title;
  final String? type;
  final String? id;

  const TopicTimelineItem({this.year, this.title, this.type, this.id});
}

/// 相关主题
class TopicRelatedItem {
  final String? type;
  final String? key;
  final String? title;
  final String? subtitle;

  const TopicRelatedItem({this.type, this.key, this.title, this.subtitle});
}
