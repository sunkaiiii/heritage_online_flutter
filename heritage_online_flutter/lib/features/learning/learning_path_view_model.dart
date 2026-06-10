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

      state = LearningPathUiState(
        isLoading: false,
        title: data.title,
        subtitle: data.subtitle,
        tags: data.tags,
        estimatedItemCount: data.featuredItems.length,
        stepCount: data.steps.length,
        steps: data.steps.asMap().entries.map((entry) {
          return LearningPathStep(
            index: entry.key + 1,
            title: entry.value.title,
            description: entry.value.subtitle,
            items: entry.value.items.map((item) => LearningPathFeaturedItem(
              id: item.id,
              type: item.type,
              title: item.title,
              summary: item.summary,
              sourceUrl: item.sourceUrl,
              category: item.category,
            )).toList(),
          );
        }).toList(),
        featuredItems: data.featuredItems.map((item) => LearningPathFeaturedItem(
          id: item.id,
          type: item.type,
          title: item.title,
          summary: item.summary,
          sourceUrl: item.sourceUrl,
          category: item.category,
        )).toList(),
        relatedTopics: data.relatedTopics.map((topic) => LearningPathRelatedTopic(
          type: topic.type,
          key: topic.key,
          title: topic.title,
        )).toList(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void retry() => load();
}

/// 学习路径详情 ViewModel Provider
final learningPathViewModelProvider = StateNotifierProvider.autoDispose
    .family<LearningPathViewModel, LearningPathUiState, String>(
        (ref, pathId) {
  final repository = ref.watch(heritageRepositoryProvider);
  return LearningPathViewModel(repository, pathId: pathId);
});
