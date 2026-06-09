// ignore_for_file: prefer_initializing_formals

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/heritage_repository.dart';
import 'package:heritage_online_flutter/core/data/repository_provider.dart';

import 'learning_path_ui_state.dart';

/// 学习路径详情 ViewModel
class LearningPathViewModel extends StateNotifier<LearningPathUiState> {
  final HeritageRepository _repository;
  final String _pathId;

  LearningPathViewModel(
    this._repository, {
    required String pathId,
  })  : _pathId = pathId,
        super(const LearningPathUiState(isLoading: true)) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repository.learningPathDetail(_pathId, limit: 6);

      final map = data as Map<String, dynamic>;

      state = LearningPathUiState(
        isLoading: false,
        title: map['title']?.toString(),
        subtitle: map['subtitle']?.toString(),
        tags: _parseTags(map['tags']),
        estimatedItemCount: (map['estimatedItemCount'] as int?) ?? 0,
        stepCount: (map['stepCount'] as int?) ?? 0,
        steps: _parseSteps(map['steps']),
        featuredItems: _parseFeaturedItems(map['featuredItems']),
        relatedTopics: _parseRelatedTopics(map['relatedTopics']),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void retry() => load();

  // ==================== JSON 解析 ====================

  List<String> _parseTags(dynamic tagsData) {
    final list = (tagsData as List?) ?? [];
    return list.map((e) => e.toString()).toList();
  }

  List<LearningPathStep> _parseSteps(dynamic stepsData) {
    final list = (stepsData as List?) ?? [];
    return list.asMap().entries.map((entry) {
      final i = entry.key;
      final map = entry.value as Map<String, dynamic>;
      return LearningPathStep(
        index: i + 1,
        title: map['title']?.toString(),
        description: map['description']?.toString(),
        items: _parseFeaturedItems(map['items']),
      );
    }).toList();
  }

  List<LearningPathFeaturedItem> _parseFeaturedItems(dynamic itemsData) {
    final list = (itemsData as List?) ?? [];
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return LearningPathFeaturedItem(
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

  List<LearningPathRelatedTopic> _parseRelatedTopics(dynamic relatedData) {
    final list = (relatedData as List?) ?? [];
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return LearningPathRelatedTopic(
        type: map['type']?.toString(),
        key: map['key']?.toString(),
        title: map['title']?.toString(),
      );
    }).toList();
  }
}

/// 学习路径详情 ViewModel Provider
final learningPathViewModelProvider = StateNotifierProvider.autoDispose
    .family<LearningPathViewModel, LearningPathUiState, String>(
        (ref, pathId) {
  final repository = ref.watch(heritageRepositoryProvider);
  return LearningPathViewModel(repository, pathId: pathId);
});
