import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('ContentCard', () {
    testWidgets('should render child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContentCard(
            child: Text('Card Content'),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('should have correct card properties', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContentCard(
            child: SizedBox(),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0);
      expect(card.shape, RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ));
    });

    testWidgets('should handle tap when onTap provided', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ContentCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Tappable Card'),
          ),
        ),
      );

      await tester.tap(find.text('Tappable Card'));
      expect(tapped, isTrue);
    });

    testWidgets('should apply padding when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ContentCard(
            padding: EdgeInsets.all(16),
            child: Text('Padded Card'),
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
    });
  });
}
