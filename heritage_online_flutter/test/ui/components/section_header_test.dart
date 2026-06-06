import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('should render title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SectionHeader(title: '最新文章'),
        ),
      );

      expect(find.text('最新文章'), findsOneWidget);
    });

    testWidgets('should render divider', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SectionHeader(title: '最新文章'),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should use titleLarge text style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SectionHeader(title: '最新文章'),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('最新文章'));
      // titleLarge fontSize 在 Material 3 中默认为 22
      expect(titleWidget.style?.fontSize, 22);
    });
  });
}
