import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('LoadingPlaceholder', () {
    testWidgets('should show progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingPlaceholder(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingPlaceholder(message: '加载中...'),
        ),
      );

      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('should not show message when null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingPlaceholder(),
        ),
      );

      expect(find.byType(Text), findsNothing);
    });
  });
}
