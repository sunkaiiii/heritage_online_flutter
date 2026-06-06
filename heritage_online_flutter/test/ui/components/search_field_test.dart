import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('SearchField', () {
    testWidgets('should render text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField(
              value: '',
              onChanged: (_) {},
              label: '搜索文章',
              placeholder: '标题或关键词',
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show search icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField(
              value: '',
              onChanged: (_) {},
              label: '搜索',
              placeholder: '关键词',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should show clear icon when has value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField(
              value: '测试',
              onChanged: (_) {},
              label: '搜索',
              placeholder: '关键词',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should not show clear icon when empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField(
              value: '',
              onChanged: (_) {},
              label: '搜索',
              placeholder: '关键词',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      String changedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchField(
              value: '',
              onChanged: (value) {
                changedValue = value;
              },
              label: '搜索',
              placeholder: '关键词',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '新搜索');
      expect(changedValue, '新搜索');
    });
  });
}
