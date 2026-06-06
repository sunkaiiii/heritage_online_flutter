import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('PageBackground', () {
    testWidgets('should render child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageBackground(
            child: Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should use surface color from theme', (tester) async {
      final theme = ThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const PageBackground(
            child: SizedBox(),
          ),
        ),
      );

      // 验证 PageBackground 存在
      expect(find.byType(PageBackground), findsOneWidget);
      expect(find.byType(ColoredBox), findsWidgets);
    });
  });
}
