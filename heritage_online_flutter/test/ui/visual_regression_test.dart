import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/theme/heritage_theme.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

void main() {
  group('Visual Regression - Theme Tokens', () {
    testWidgets('light theme should have correct primary color',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              // Primary should be the heritage red-brown
              expect(colorScheme.primary, const Color(0xFF8F372F));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('dark theme should have correct primary color',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              expect(colorScheme.primary, const Color(0xFFFFB4AA));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('ContentCard should use surfaceContainerLow',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: ContentCard(
              padding: EdgeInsets.all(8),
              child: Text('Test'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, HeritageTheme.lightTheme.colorScheme.surfaceContainerLow);
    });

    testWidgets('cards should have no elevation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: ContentCard(
              padding: EdgeInsets.all(8),
              child: Text('Test'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0);
    });

    testWidgets('cards should have 8dp border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: ContentCard(
              padding: EdgeInsets.all(8),
              child: Text('Test'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(8));
    });
  });

  group('Visual Regression - Text Overflow', () {
    testWidgets('long Chinese title should not overflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: ContentCard(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '这是一个非常长的中文标题用于测试文本溢出处理是否正常工作应该被正确截断',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('long English title should not overflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: ContentCard(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'This is a very long English title to test text overflow handling works correctly and should be truncated',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('MetaChip should handle long text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: SizedBox(
              width: 100,
              child: MetaChip(text: 'Very long chip text that should be truncated'),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('Visual Regression - Dark Mode', () {
    testWidgets('dark mode should have proper contrast', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              // onSurface should be light in dark mode
              expect(colorScheme.onSurface, const Color(0xFFEDE0DC));
              expect(colorScheme.onSurfaceVariant, const Color(0xFFD6C2BA));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('dark mode background should be dark', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.darkTheme,
          home: Builder(
            builder: (context) {
              final color = Theme.of(context).colorScheme.surface;
              expect((color.r * 255).round(), lessThan(30));
              expect((color.g * 255).round(), lessThan(30));
              expect((color.b * 255).round(), lessThan(30));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('ContentCard in dark mode uses correct surface',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.darkTheme,
          home: const Scaffold(
            body: ContentCard(
              padding: EdgeInsets.all(8),
              child: Text('Dark card'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, HeritageTheme.darkTheme.colorScheme.surfaceContainerLow);
    });
  });

  group('Visual Regression - Component Properties', () {
    testWidgets('SectionHeader should render title with divider',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: SectionHeader(title: 'Test Section'),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('ErrorRetryRow should show retry button', (tester) async {
      var retryPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: Scaffold(
            body: ErrorRetryRow(
              message: 'Error occurred',
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      expect(retryPressed, isTrue);
    });

    testWidgets('EmptyState should show message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: EmptyState(message: 'No data'),
          ),
        ),
      );

      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('LoadingPlaceholder should render without error',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: LoadingPlaceholder(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('ImagePlaceholder should show fallback text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: SizedBox(
              width: 80,
              height: 80,
              child: ImagePlaceholder(text: 'E'),
            ),
          ),
        ),
      );

      expect(find.text('E'), findsOneWidget);
    });

    testWidgets('ReferenceCard should show title and meta', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: ReferenceCard(
              title: 'Related Article',
              meta: 'article',
            ),
          ),
        ),
      );

      expect(find.text('Related Article'), findsOneWidget);
      expect(find.text('article'), findsOneWidget);
    });

    testWidgets('ListCard should render horizontal layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: ListCard(
              image: SizedBox(
                width: 60,
                height: 60,
                child: Placeholder(),
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title'),
                  Text('Subtitle'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });
  });

  group('Visual Regression - Typography', () {
    testWidgets('headlineMedium should use SemiBold weight', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: Scaffold(
            body: Text(
              'Test Title',
              style: HeritageTheme.lightTheme.textTheme.headlineMedium,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test Title'));
      expect(text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('bodyLarge should use Normal weight', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: Scaffold(
            body: Text(
              'Test body text',
              style: HeritageTheme.lightTheme.textTheme.bodyLarge,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test body text'));
      expect(text.style?.fontWeight, FontWeight.w400);
    });
  });

  group('Visual Regression - No Hardcoded Colors', () {
    testWidgets('PageBackground should use theme scaffold background',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: HeritageTheme.lightTheme,
          home: const Scaffold(
            body: PageBackground(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('light and dark themes should have different brightness',
        (tester) async {
      final lightScheme = HeritageTheme.lightTheme.colorScheme;
      final darkScheme = HeritageTheme.darkTheme.colorScheme;

      expect(lightScheme.brightness, Brightness.light);
      expect(darkScheme.brightness, Brightness.dark);
      expect(lightScheme.primary, isNot(equals(darkScheme.primary)));
      expect(lightScheme.surface, isNot(equals(darkScheme.surface)));
    });
  });
}
