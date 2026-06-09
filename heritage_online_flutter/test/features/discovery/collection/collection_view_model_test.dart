import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/collection_dtos.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_view_model.dart';

import '../../../core/data/fake_heritage_repository.dart';

void main() {
  group('CollectionDetailViewModel', () {
    late FakeHeritageRepository repository;

    setUp(() {
      repository = FakeHeritageRepository();
    });

    test('should load collection by id successfully', () async {
      repository.mockCollection = const CollectionDto(
        id: 'national-projects',
        title: '国家级项目精选',
        subtitle: '代表性国家级非遗项目',
        type: 'featured',
        tags: ['国家级'],
        items: [
          CollectionItemDto(id: '1', type: 'article', title: '文章1'),
          CollectionItemDto(id: '2', type: 'directoryItem', title: '名录1'),
        ],
      );

      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(id: 'national-projects'),
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.collection, isNotNull);
      expect(state.collection!.title, '国家级项目精选');
      expect(state.collection!.items.length, 2);
      expect(state.error, isNull);

      viewModel.dispose();
    });

    test('should load collection by type and key successfully', () async {
      repository.mockCollection = const CollectionDto(
        id: 'topic-collection',
        title: '北京主题合集',
        items: [
          CollectionItemDto(id: '1', type: 'inheritor', title: '传承人1'),
        ],
      );

      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(type: 'region', topicKey: 'beijing'),
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.collection, isNotNull);
      expect(state.collection!.title, '北京主题合集');
      expect(state.collection!.items.length, 1);
      expect(state.error, isNull);

      viewModel.dispose();
    });

    test('should handle loading error', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Network error');

      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(id: 'some-id'),
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.collection, isNull);
      expect(state.error, isNotNull);

      viewModel.dispose();
    });

    test('should handle missing identifier', () async {
      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(),
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.collection, isNull);
      expect(state.error, isNotNull);

      viewModel.dispose();
    });

    test('should load empty collection without error', () async {
      repository.mockCollection = const CollectionDto(
        id: 'empty',
        title: '空合集',
        items: [],
      );

      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(id: 'empty'),
      );
      await Future<void>.delayed(Duration.zero);

      final state = viewModel.state;
      expect(state.isLoading, false);
      expect(state.collection, isNotNull);
      expect(state.collection!.items, isEmpty);
      expect(state.error, isNull);

      viewModel.dispose();
    });

    test('should retry successfully', () async {
      repository.shouldThrow = true;
      repository.mockError = Exception('Timeout');

      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(id: 'retry-test'),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNotNull);

      // Fix error and retry
      repository.shouldThrow = false;
      repository.mockCollection = const CollectionDto(
        id: 'retry-test',
        title: '重试成功',
        items: [CollectionItemDto(id: '1', title: '条目1')],
      );

      viewModel.retry();
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.error, isNull);
      expect(viewModel.state.collection!.title, '重试成功');

      viewModel.dispose();
    });

    test('should prefer id over type/key when both provided', () async {
      repository.mockCollection = const CollectionDto(
        id: 'by-id',
        title: '按 ID 加载',
      );

      final viewModel = CollectionDetailViewModel(
        repository,
        const CollectionDetailParams(
          id: 'by-id',
          type: 'region',
          topicKey: 'beijing',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.collection!.title, '按 ID 加载');

      viewModel.dispose();
    });

    test('params equality should work correctly', () {
      const p1 = CollectionDetailParams(id: 'test');
      const p2 = CollectionDetailParams(id: 'test');
      const p3 = CollectionDetailParams(id: 'other');
      const p4 = CollectionDetailParams(type: 'region', topicKey: 'beijing');
      const p5 = CollectionDetailParams(type: 'region', topicKey: 'beijing');

      expect(p1, equals(p2));
      expect(p1, isNot(equals(p3)));
      expect(p4, equals(p5));
      expect(p1, isNot(equals(p4)));
    });
  });
}
