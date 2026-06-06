import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('ErrorRetryRow', () {
    testWidgets('should render error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorRetryRow(
            message: '网络请求失败',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('网络请求失败'), findsOneWidget);
    });

    testWidgets('should render retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorRetryRow(
            message: '加载失败',
            onRetry: () {},
            retryText: '重试',
          ),
        ),
      );

      expect(find.text('重试'), findsOneWidget);
    });

    testWidgets('should show error icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorRetryRow(
            message: '加载失败',
            onRetry: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should call onRetry when tapped', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorRetryRow(
            message: '加载失败',
            onRetry: () {
              retried = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });

    testWidgets('should use custom retry text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorRetryRow(
            message: '加载失败',
            onRetry: () {},
            retryText: '点击重试',
          ),
        ),
      );

      expect(find.text('点击重试'), findsOneWidget);
    });
  });
}
