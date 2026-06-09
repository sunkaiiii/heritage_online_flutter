import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/features/learning/learning_path_ui_state.dart';

void main() {
  group('LearningPathUiState', () {
    test('should have default values', () {
      const state = LearningPathUiState();

      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.title, isNull);
      expect(state.subtitle, isNull);
      expect(state.tags, isEmpty);
      expect(state.estimatedItemCount, 0);
      expect(state.stepCount, 0);
      expect(state.steps, isEmpty);
      expect(state.featuredItems, isEmpty);
      expect(state.relatedTopics, isEmpty);
    });

    test('copyWith should work correctly', () {
      const state = LearningPathUiState();
      final updated = state.copyWith(
        isLoading: true,
        title: 'Test Path',
        stepCount: 5,
      );

      expect(updated.isLoading, isTrue);
      expect(updated.title, 'Test Path');
      expect(updated.stepCount, 5);
    });

    test('copyWith should preserve values when not specified', () {
      const state = LearningPathUiState(title: 'Original');
      final updated = state.copyWith(isLoading: true);

      expect(updated.title, 'Original');
      expect(updated.isLoading, isTrue);
    });

    test('copyWith should allow clearing error', () {
      const state = LearningPathUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('LearningPathStep', () {
    test('should create with default values', () {
      const step = LearningPathStep();

      expect(step.index, 0);
      expect(step.title, isNull);
      expect(step.description, isNull);
      expect(step.items, isEmpty);
    });

    test('should create with custom values', () {
      const step = LearningPathStep(
        index: 3,
        title: 'Step 3',
        description: 'Learn about heritage',
      );

      expect(step.index, 3);
      expect(step.title, 'Step 3');
      expect(step.description, 'Learn about heritage');
    });
  });

  group('LearningPathFeaturedItem', () {
    test('isArticle should detect article type', () {
      const item = LearningPathFeaturedItem(type: 'article');
      expect(item.isArticle, isTrue);
      expect(item.isDirectoryItem, isFalse);
      expect(item.isInheritor, isFalse);
    });

    test('isDirectoryItem should detect directoryItem type', () {
      const item = LearningPathFeaturedItem(type: 'directoryItem');
      expect(item.isArticle, isFalse);
      expect(item.isDirectoryItem, isTrue);
      expect(item.isInheritor, isFalse);
    });

    test('isInheritor should detect inheritor type', () {
      const item = LearningPathFeaturedItem(type: 'inheritor');
      expect(item.isArticle, isFalse);
      expect(item.isDirectoryItem, isFalse);
      expect(item.isInheritor, isTrue);
    });
  });
}
