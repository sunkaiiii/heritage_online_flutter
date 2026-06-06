import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('ListCard', () {
    testWidgets('should render horizontal layout by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListCard(
            image: const SizedBox(
              width: 80,
              height: 80,
              child: ImagePlaceholder(text: '图'),
            ),
            text: const Column(
              children: [
                MetaChip(text: '新闻'),
                Text('标题'),
              ],
            ),
          ),
        ),
      );

      // 横向布局使用 Row
      expect(find.byType(Row), findsWidgets);
      expect(find.text('标题'), findsOneWidget);
    });

    testWidgets('should render vertical layout when prominent', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListCard(
            prominent: true,
            image: const SizedBox(
              height: 120,
              child: ImagePlaceholder(text: '大图'),
            ),
            text: const Column(
              children: [
                Text('竖版标题'),
              ],
            ),
          ),
        ),
      );

      // 纵向布局不包含横向 Row（但有 Column 内部的）
      expect(find.byType(Row), findsNothing);
      expect(find.text('竖版标题'), findsOneWidget);
    });

    testWidgets('should handle tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ListCard(
            onTap: () {
              tapped = true;
            },
            image: const SizedBox(
              width: 80,
              height: 80,
              child: ImagePlaceholder(text: '图'),
            ),
            text: const Text('可点击'),
          ),
        ),
      );

      await tester.tap(find.text('可点击'));
      expect(tapped, isTrue);
    });

    testWidgets('should use ContentCard internally', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListCard(
            image: const SizedBox(
              width: 80,
              height: 80,
              child: ImagePlaceholder(text: '图'),
            ),
            text: const Text('内容'),
          ),
        ),
      );

      expect(find.byType(ContentCard), findsOneWidget);
    });
  });
}
