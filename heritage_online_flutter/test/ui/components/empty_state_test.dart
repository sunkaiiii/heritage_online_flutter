import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('EmptyState', () {
    testWidgets('should render message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyState(message: '暂无数据'),
        ),
      );

      expect(find.text('暂无数据'), findsOneWidget);
    });

    testWidgets('should render default icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyState(message: '暂无数据'),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('should render custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyState(
            message: '暂无数据',
            icon: Icons.search_off,
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should show retry button when onRetry provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EmptyState(
            message: '加载失败',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('重试'), findsOneWidget);
    });

    testWidgets('should not show retry button when onRetry null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyState(message: '暂无数据'),
        ),
      );

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('should use custom retry text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EmptyState(
            message: '加载失败',
            onRetry: () {},
            retryText: '点击重试',
          ),
        ),
      );

      expect(find.text('点击重试'), findsOneWidget);
    });

    testWidgets('should call onRetry when tapped', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: EmptyState(
            message: '加载失败',
            onRetry: () {
              retried = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('重试'));
      expect(retried, isTrue);
    });
  });
}
