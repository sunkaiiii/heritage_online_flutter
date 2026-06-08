import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_ui_state.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_view_model.dart';

void main() {
  group('InheritorDetailUiState', () {
    test('should have default values', () {
      const state = InheritorDetailUiState();

      expect(state.isLoading, isTrue);
      expect(state.item, isNull);
      expect(state.error, isNull);
      expect(state.isFavorite, isFalse);
    });

    test('copyWith should update values', () {
      const state = InheritorDetailUiState();
      final updated = state.copyWith(
        isLoading: false,
        item: const InheritorDetailDto(
          id: '123',
          name: 'Test Inheritor',
        ),
      );

      expect(updated.isLoading, isFalse);
      expect(updated.item, isNotNull);
      expect(updated.item!.id, '123');
      expect(updated.item!.name, 'Test Inheritor');
    });

    test('copyWith should preserve values when not specified', () {
      const state = InheritorDetailUiState(isFavorite: true);
      final updated = state.copyWith(isLoading: false);

      expect(updated.isFavorite, isTrue);
    });

    test('copyWith should allow clearing error', () {
      const state = InheritorDetailUiState(error: 'error');
      final updated = state.copyWith(error: null);

      expect(updated.error, isNull);
    });
  });

  group('InheritorDetailParams', () {
    test('should create with inheritorId', () {
      const params = InheritorDetailParams(inheritorId: '123');
      expect(params.inheritorId, '123');
      expect(params.sourceId, isNull);
    });

    test('should create with sourceId', () {
      const params = InheritorDetailParams(sourceId: 'source-123');
      expect(params.inheritorId, isNull);
      expect(params.sourceId, 'source-123');
    });

    test('equality should work correctly', () {
      const params1 = InheritorDetailParams(inheritorId: '123');
      const params2 = InheritorDetailParams(inheritorId: '123');
      const params3 = InheritorDetailParams(inheritorId: '456');

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('hashCode should be consistent', () {
      const params1 = InheritorDetailParams(inheritorId: '123');
      const params2 = InheritorDetailParams(inheritorId: '123');

      expect(params1.hashCode, equals(params2.hashCode));
    });
  });
}
