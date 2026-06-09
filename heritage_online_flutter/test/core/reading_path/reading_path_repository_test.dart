import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/reading_path/reading_path_repository.dart';
import 'package:heritage_online_flutter/core/reading_path/reading_path_types.dart';

void main() {
  late SharedPreferences prefs;
  late ReadingPathRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = ReadingPathRepository(prefs: prefs);
  });

  group('ReadingPathRepository', () {
    test('should return empty list by default', () {
      final events = repository.getRecentPath();
      expect(events, isEmpty);
    });

    test('should record event', () {
      final event = ReadingPathEvent(
        fromType: 'article',
        fromId: 'article-1',
        fromTitle: 'From Article',
        toType: 'directoryItem',
        toId: 'dir-1',
        toTitle: 'To Directory',
        source: 'related',
      );

      repository.record(event);
      final events = repository.getRecentPath();

      expect(events.length, 1);
      expect(events[0].fromType, 'article');
      expect(events[0].fromId, 'article-1');
      expect(events[0].toType, 'directoryItem');
      expect(events[0].toId, 'dir-1');
      expect(events[0].source, 'related');
    });

    test('should sort by createdAt descending', () async {
      final event1 = ReadingPathEvent(
        fromType: 'article',
        fromId: 'article-1',
        toType: 'directoryItem',
        toId: 'dir-1',
        source: 'related',
      );

      await Future.delayed(const Duration(milliseconds: 10));

      final event2 = ReadingPathEvent(
        fromType: 'directoryItem',
        fromId: 'dir-1',
        toType: 'inheritor',
        toId: 'inh-1',
        source: 'related',
      );

      repository.record(event1);
      repository.record(event2);
      final events = repository.getRecentPath();

      expect(events.length, 2);
      expect(events[0].toId, 'inh-1');
      expect(events[1].toId, 'dir-1');
    });

    test('should limit results', () {
      for (var i = 0; i < 10; i++) {
        repository.record(ReadingPathEvent(
          toType: 'article',
          toId: 'article-$i',
          source: 'list',
        ));
      }

      final events = repository.getRecentPath(limit: 5);
      expect(events.length, 5);
    });

    test('should clear all events', () {
      repository.record(ReadingPathEvent(
        toType: 'article',
        toId: 'article-1',
        source: 'list',
      ));
      repository.record(ReadingPathEvent(
        toType: 'article',
        toId: 'article-2',
        source: 'list',
      ));

      repository.clear();
      final events = repository.getRecentPath();

      expect(events, isEmpty);
    });

    test('should persist across instances', () {
      repository.record(ReadingPathEvent(
        fromType: 'article',
        fromId: 'article-1',
        toType: 'directoryItem',
        toId: 'dir-1',
        source: 'related',
      ));

      final newRepo = ReadingPathRepository(prefs: prefs);
      final events = newRepo.getRecentPath();

      expect(events.length, 1);
      expect(events[0].toId, 'dir-1');
    });

    group('ReadingPathSource', () {
      test('wireName should match expected values', () {
        expect(ReadingPathSource.blendedRecommendation.wireName, 'blendedRecommendation');
        expect(ReadingPathSource.related.wireName, 'related');
        expect(ReadingPathSource.recommendation.wireName, 'recommendation');
        expect(ReadingPathSource.semanticRecommendation.wireName, 'semanticRecommendation');
        expect(ReadingPathSource.graph.wireName, 'graph');
        expect(ReadingPathSource.list.wireName, 'list');
      });

      test('fromWireName should parse correctly', () {
        expect(ReadingPathSource.fromWireName('related'), ReadingPathSource.related);
        expect(ReadingPathSource.fromWireName('blendedRecommendation'), ReadingPathSource.blendedRecommendation);
      });

      test('fromWireName should default to list for unknown', () {
        expect(ReadingPathSource.fromWireName('unknown'), ReadingPathSource.list);
        expect(ReadingPathSource.fromWireName(null), ReadingPathSource.list);
      });
    });

    group('ReadingPathEvent', () {
      test('should generate id automatically', () {
        final event = ReadingPathEvent(
          toType: 'article',
          toId: 'article-1',
          source: 'list',
        );

        expect(event.id, isNotEmpty);
      });

      test('should generate createdAt automatically', () {
        final event = ReadingPathEvent(
          toType: 'article',
          toId: 'article-1',
          source: 'list',
        );

        expect(event.createdAt, greaterThan(0));
      });

      test('toMap and fromMap should round-trip', () {
        final original = ReadingPathEvent(
          fromType: 'article',
          fromId: 'article-1',
          fromTitle: 'From Article',
          toType: 'directoryItem',
          toId: 'dir-1',
          toTitle: 'To Directory',
          source: 'related',
          toCategory: 'traditional-crafts',
          toKind: 'nationalProject',
          toSourceId: 'source-123',
        );

        final map = original.toMap();
        final restored = ReadingPathEvent.fromMap(map);

        expect(restored.fromType, original.fromType);
        expect(restored.fromId, original.fromId);
        expect(restored.toType, original.toType);
        expect(restored.toId, original.toId);
        expect(restored.source, original.source);
        expect(restored.toCategory, original.toCategory);
        expect(restored.toKind, original.toKind);
        expect(restored.toSourceId, original.toSourceId);
      });
    });
  });
}
