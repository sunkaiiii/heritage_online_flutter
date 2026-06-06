import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('ListImage', () {
    testWidgets('should show placeholder when imageUrl is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ListImage(
              imageUrl: null,
              fallbackText: '无图',
            ),
          ),
        ),
      );

      expect(find.byType(ImagePlaceholder), findsOneWidget);
      expect(find.text('无图'), findsOneWidget);
    });

    testWidgets('should show placeholder when imageUrl is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ListImage(
              imageUrl: '',
              fallbackText: '空URL',
            ),
          ),
        ),
      );

      expect(find.byType(ImagePlaceholder), findsOneWidget);
    });

    testWidgets('should attempt to load image when URL provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ListImage(
              imageUrl: 'https://example.com/image.jpg',
              fallbackText: '加载',
            ),
          ),
        ),
      );

      // 初始显示占位（加载中）
      expect(find.byType(ImagePlaceholder), findsOneWidget);
    });

    testWidgets('should show error placeholder on load failure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 100,
            height: 100,
            child: ListImage(
              imageUrl: 'https://invalid.example.com/broken.jpg',
              fallbackText: '加载失败',
            ),
          ),
        ),
      );

      // 加载失败应显示占位
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(ImagePlaceholder), findsOneWidget);
    });
  });
}
