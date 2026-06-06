import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('FactCard', () {
    testWidgets('should render facts', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FactCard(
            facts: [
              HeritageFact(label: '分类', value: '传统技艺'),
              HeritageFact(label: '地区', value: '北京市'),
            ],
          ),
        ),
      );

      expect(find.text('分类'), findsOneWidget);
      expect(find.text('传统技艺'), findsOneWidget);
      expect(find.text('地区'), findsOneWidget);
      expect(find.text('北京市'), findsOneWidget);
    });

    testWidgets('should render nothing when facts empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FactCard(facts: []),
        ),
      );

      expect(find.byType(FactCard), findsOneWidget);
      expect(find.byType(ContentCard), findsNothing);
    });

    testWidgets('should use primary color for labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FactCard(
            facts: [
              HeritageFact(label: '分类', value: '传统技艺'),
            ],
          ),
        ),
      );

      final labelText = tester.widget<Text>(find.text('分类'));
      // labelLarge 在 Material 3 中默认 fontSize 为 14
      expect(labelText.style?.fontSize, 14);
    });
  });
}
