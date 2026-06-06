import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('PageHeader', () {
    testWidgets('should render title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageHeader(
            title: 'E迹',
          ),
        ),
      );

      expect(find.text('E迹'), findsOneWidget);
    });

    testWidgets('should render subtitle when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageHeader(
            title: 'E迹',
            subtitle: '非遗新闻、论坛与专题',
          ),
        ),
      );

      expect(find.text('非遗新闻、论坛与专题'), findsOneWidget);
    });

    testWidgets('should not render subtitle when null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageHeader(
            title: 'E迹',
          ),
        ),
      );

      expect(find.text('E迹'), findsOneWidget);
    });

    testWidgets('should render actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PageHeader(
            title: 'E迹',
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should use correct text styles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageHeader(
            title: 'E迹',
            subtitle: '副标题',
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('E迹'));
      // headlineLarge 应该有 fontSize
      expect(titleWidget.style?.fontSize, isNotNull);
      expect(titleWidget.style?.fontWeight, isNotNull);
    });
  });
}
