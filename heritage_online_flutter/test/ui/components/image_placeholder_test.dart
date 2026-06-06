import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('ImagePlaceholder', () {
    testWidgets('should render text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ImagePlaceholder(text: 'E迹'),
          ),
        ),
      );

      expect(find.text('E迹'), findsOneWidget);
    });

    testWidgets('should have correct decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ImagePlaceholder(text: 'E迹'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('should center text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ImagePlaceholder(text: 'E迹'),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });
  });
}
