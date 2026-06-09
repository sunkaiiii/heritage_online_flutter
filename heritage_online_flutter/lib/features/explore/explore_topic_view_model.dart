// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'explore_topic_ui_state.dart';

/// 探索主题详情 ViewModel
class ExploreTopicViewModel extends StateNotifier<ExploreTopicUiState> {
  final HeritageRepository _repository;
  final String _type;
  final String _topicKey;

  ExploreTopicViewModel(
    this._repository, {
    required String type,
    required String key,
  })  : _type = type,
        _topicKey = key,
        super(const ExploreTopicUiState(isLoading: true)) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repository.exploreTopic(_type, _topicKey, limit: 6);

      final map = data as Map<String, dynamic>;

      state = ExploreTopicUiState(
        isLoading: false,
        title: map['title']?.toString(),
        subtitle: map['subtitle']?.toString(),
        type: map['type']?.toString(),
        key: map['key']?.toString(),
        total: (map['total'] as int?) ?? 0,
        articleCount: (map['articleCount'] as int?) ?? 0,
        directoryItemCount: (map['directoryItemCount'] as int?) ?? 0,
        inheritorCount: (map['inheritorCount'] as int?) ?? 0,
        sections: _parseSections(map['sections']),
        timeline: _parseTimeline(map['timeline']),
        relatedTopics: _parseRelatedTopics(map['relatedTopics']),
        featuredItems: _parseSectionItems(map['featuredItems']),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void retry() => load();

  // ==================== JSON 解析 ====================

  List<TopicSection> _parseSections(dynamic sectionsData) {
    final list = (sectionsData as List?) ?? [];
    return list.map((s) {
      final map = s as Map<String, dynamic>;
      return TopicSection(
        title: map['title']?.toString(),
        subtitle: map['subtitle']?.toString(),
        items: _parseSectionItems(map['items']),
      );
    }).toList();
  }

  List<TopicTimelineItem> _parseTimeline(dynamic timelineData) {
    final list = (timelineData as List?) ?? [];
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return TopicTimelineItem(
        year: map['year']?.toString(),
        title: map['title']?.toString(),
        type: map['type']?.toString(),
        id: map['id']?.toString(),
      );
    }).toList();
  }

  List<TopicRelatedItem> _parseRelatedTopics(dynamic relatedData) {
    final list = (relatedData as List?) ?? [];
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return TopicRelatedItem(
        type: map['type']?.toString(),
        key: map['key']?.toString(),
        title: map['title']?.toString(),
        subtitle: map['subtitle']?.toString(),
      );
    }).toList();
  }

  List<TopicSectionItem> _parseSectionItems(dynamic itemsData) {
    final list = (itemsData as List?) ?? [];
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return TopicSectionItem(
        id: map['id']?.toString(),
        type: map['type']?.toString(),
        title: map['title']?.toString(),
        summary: map['summary']?.toString(),
        imageUrl: map['imageUrl']?.toString(),
        sourceId: map['sourceId']?.toString(),
        sourceUrl: map['sourceUrl']?.toString(),
        category: map['category']?.toString(),
        kind: map['kind']?.toString(),
      );
    }).toList();
  }
}

/// 探索主题详情 ViewModel Provider
final exploreTopicViewModelProvider = StateNotifierProvider.autoDispose
    .family<ExploreTopicViewModel, ExploreTopicUiState, ExploreTopicParams>(
        (ref, params) {
  final repository = ref.watch(heritageRepositoryProvider);
  return ExploreTopicViewModel(
    repository,
    type: params.type,
    key: params.key,
  );
});

/// 探索主题参数
class ExploreTopicParams {
  final String type;
  final String key;

  const ExploreTopicParams({required this.type, required this.key});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExploreTopicParams && type == other.type && key == other.key;

  @override
  int get hashCode => type.hashCode ^ key.hashCode;
}
