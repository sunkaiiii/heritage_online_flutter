import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('MetaChip', () {
    testWidgets('should render text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MetaChip(text: '新闻'),
        ),
      );

      expect(find.text('新闻'), findsOneWidget);
    });

    testWidgets('should use correct text style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MetaChip(text: '新闻'),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('新闻'));
      // labelLarge 应该有 fontSize
      expect(textWidget.style?.fontSize, isNotNull);
    });

    testWidgets('should have correct decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MetaChip(text: '新闻'),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
      expect(decoration.border, isNotNull);
    });

    testWidgets('should handle long text with ellipsis', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            child: MetaChip(text: '这是一个很长的标签文本用于测试省略效果'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 1);
    });
  });
}
