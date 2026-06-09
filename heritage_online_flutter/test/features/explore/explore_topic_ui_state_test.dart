import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/features/explore/explore_topic_ui_state.dart';

void main() {
  group('ExploreTopicUiState', () {
    test('should have default values', () {
      const state = ExploreTopicUiState();

      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.title, isNull);
      expect(state.subtitle, isNull);
      expect(state.total, 0);
      expect(state.articleCount, 0);
      expect(state.directoryItemCount, 0);
      expect(state.inheritorCount, 0);
      expect(state.sections, isEmpty);
      expect(state.timeline, isEmpty);
      expect(state.relatedTopics, isEmpty);
      expect(state.featuredItems, isEmpty);
    });

    test('copyWith should work correctly', () {
      const state = ExploreTopicUiState();
      final updated = state.copyWith(
        isLoading: true,
        title: 'Test Topic',
        total: 42,
      );

      expect(updated.isLoading, isTrue);
      expect(updated.title, 'Test Topic');
      expect(updated.total, 42);
    });

    test('copyWith should preserve values when not specified', () {
      const state = ExploreTopicUiState(title: 'Original');
      final updated = state.copyWith(isLoading: true);

      expect(updated.title, 'Original');
      expect(updated.isLoading, isTrue);
    });

    test('copyWith should allow clearing error', () {
      const state = ExploreTopicUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('TopicSectionItem', () {
    test('isArticle should detect article type', () {
      const item = TopicSectionItem(type: 'article');
      expect(item.isArticle, isTrue);
      expect(item.isDirectoryItem, isFalse);
      expect(item.isInheritor, isFalse);
    });

    test('isDirectoryItem should detect directoryItem type', () {
      const item = TopicSectionItem(type: 'directoryItem');
      expect(item.isArticle, isFalse);
      expect(item.isDirectoryItem, isTrue);
      expect(item.isInheritor, isFalse);
    });

    test('isInheritor should detect inheritor type', () {
      const item = TopicSectionItem(type: 'inheritor');
      expect(item.isArticle, isFalse);
      expect(item.isDirectoryItem, isFalse);
      expect(item.isInheritor, isTrue);
    });
  });
}
