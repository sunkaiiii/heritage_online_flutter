import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_ui_state.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_view_model.dart';

void main() {
  group('DirectoryDetailUiState', () {
    test('should have default values', () {
      const state = DirectoryDetailUiState();

      expect(state.isLoading, isTrue);
      expect(state.item, isNull);
      expect(state.error, isNull);
      expect(state.isFavorite, isFalse);
    });

    test('copyWith should update values', () {
      const state = DirectoryDetailUiState();
      final updated = state.copyWith(
        isLoading: false,
        item: const DirectoryItemDetailDto(
          id: '123',
          title: 'Test Directory',
          kind: DirectoryItemKind.unescoEntry,
        ),
      );

      expect(updated.isLoading, isFalse);
      expect(updated.item, isNotNull);
      expect(updated.item!.id, '123');
      expect(updated.item!.kind, DirectoryItemKind.unescoEntry);
    });

    test('copyWith should preserve values when not specified', () {
      const state = DirectoryDetailUiState(isFavorite: true);
      final updated = state.copyWith(isLoading: false);

      expect(updated.isFavorite, isTrue);
    });

    test('copyWith should allow clearing error', () {
      const state = DirectoryDetailUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('DirectoryDetailParams', () {
    test('should create with itemId', () {
      const params = DirectoryDetailParams(itemId: '123');
      expect(params.itemId, '123');
      expect(params.sourceId, isNull);
      expect(params.kind, DirectoryItemKind.nationalProject);
    });

    test('should create with sourceId', () {
      const params = DirectoryDetailParams(sourceId: 'source-123');
      expect(params.itemId, isNull);
      expect(params.sourceId, 'source-123');
    });

    test('should create with custom kind', () {
      const params = DirectoryDetailParams(
        itemId: '123',
        kind: DirectoryItemKind.unescoEntry,
      );
      expect(params.kind, DirectoryItemKind.unescoEntry);
    });

    test('equality should work correctly', () {
      const params1 = DirectoryDetailParams(itemId: '123');
      const params2 = DirectoryDetailParams(itemId: '123');
      const params3 = DirectoryDetailParams(itemId: '456');

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('hashCode should be consistent', () {
      const params1 = DirectoryDetailParams(itemId: '123');
      const params2 = DirectoryDetailParams(itemId: '123');

      expect(params1.hashCode, equals(params2.hashCode));
    });
  });
}
