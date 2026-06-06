import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('FilterButton', () {
    testWidgets('should render icon button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FilterButton(
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should show badge when has active filters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FilterButton(
            activeFilterCount: 3,
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should not show badge when no active filters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FilterButton(
            activeFilterCount: 0,
            onPressed: () {},
          ),
        ),
      );

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: FilterButton(
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });

    testWidgets('should have correct tooltip', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FilterButton(
            onPressed: () {},
            tooltip: '筛选',
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.tooltip, '筛选');
    });
  });
}
