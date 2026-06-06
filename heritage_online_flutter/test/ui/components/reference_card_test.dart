import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('ReferenceCard', () {
    testWidgets('should render title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReferenceCard(
            title: '相关文章标题',
          ),
        ),
      );

      expect(find.text('相关文章标题'), findsOneWidget);
    });

    testWidgets('should render meta when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReferenceCard(
            title: '相关文章标题',
            meta: '2024-01-15 · 新闻',
          ),
        ),
      );

      expect(find.text('2024-01-15 · 新闻'), findsOneWidget);
    });

    testWidgets('should not render meta when null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReferenceCard(
            title: '相关文章标题',
          ),
        ),
      );

      // 仅标题存在
      expect(find.text('相关文章标题'), findsOneWidget);
    });

    testWidgets('should handle tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ReferenceCard(
            title: '相关文章标题',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('相关文章标题'));
      expect(tapped, isTrue);
    });
  });
}
