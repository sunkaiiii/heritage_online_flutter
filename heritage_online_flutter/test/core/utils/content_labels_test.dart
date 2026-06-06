import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

void main() {
  group('localizedContentType', () {
    testWidgets('should return localized article type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'article') ?? '');
            },
          ),
        ),
      );

      expect(find.text('文章'), findsOneWidget);
    });

    testWidgets('should return localized directoryItem type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'directoryItem') ?? '');
            },
          ),
        ),
      );

      expect(find.text('名录'), findsOneWidget);
    });

    testWidgets('should return localized inheritor type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'inheritor') ?? '');
            },
          ),
        ),
      );

      expect(find.text('传承人'), findsOneWidget);
    });

    testWidgets('should return localized collection type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'collection') ?? '');
            },
          ),
        ),
      );

      expect(find.text('合集'), findsOneWidget);
    });

    testWidgets('should return localized topic type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'topic') ?? '');
            },
          ),
        ),
      );

      expect(find.text('探索主题'), findsOneWidget);
    });

    testWidgets('should return original value for unknown type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'unknownType') ?? '');
            },
          ),
        ),
      );

      expect(find.text('unknownType'), findsOneWidget);
    });

    testWidgets('should return null for null type', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              result = localizedContentType(context, null);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, isNull);
    });

    testWidgets('should return English article type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              return Text(localizedContentType(context, 'article') ?? '');
            },
          ),
        ),
      );

      expect(find.text('Article'), findsOneWidget);
    });
  });

  group('localizedArticleCategory', () {
    testWidgets('should return localized news category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedArticleCategory(context, 'news') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('新闻'), findsOneWidget);
    });

    testWidgets('should return localized forum category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedArticleCategory(context, 'forum') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('论坛'), findsOneWidget);
    });

    testWidgets('should return localized specialTopic category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedArticleCategory(context, 'specialTopic') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('专题'), findsOneWidget);
    });

    testWidgets('should return original value for unknown category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedArticleCategory(context, 'unknown') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('unknown'), findsOneWidget);
    });

    testWidgets('should return null for empty category', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              result = localizedArticleCategory(context, '');
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, isNull);
    });

    testWidgets('should return null for null category', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              result = localizedArticleCategory(context, null);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, isNull);
    });

    testWidgets('should return English news category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              return Text(localizedArticleCategory(context, 'news') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('News'), findsOneWidget);
    });
  });

  group('localizedDirectoryKind', () {
    testWidgets('should return localized nationalProject kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'nationalProject') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('国家级项目'), findsOneWidget);
    });

    testWidgets('should return localized culturalEcoZone kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'culturalEcoZone') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('文化生态区'), findsOneWidget);
    });

    testWidgets('should return localized productiveProtectionBase kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'productiveProtectionBase') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('保护基地'), findsOneWidget);
    });

    testWidgets('should return localized unescoEntry kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'unescoEntry') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('UNESCO'), findsOneWidget);
    });

    testWidgets('should return localized chinaUnescoEntry kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'chinaUnescoEntry') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('中国 UNESCO'), findsOneWidget);
    });

    testWidgets('should return localized contractingState kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'contractingState') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('缔约国'), findsOneWidget);
    });

    testWidgets('should return original value for unknown kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'unknownKind') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('unknownKind'), findsOneWidget);
    });

    testWidgets('should return null for empty kind', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              result = localizedDirectoryKind(context, '');
              return const SizedBox();
            },
          ),
        ),
      );

      expect(result, isNull);
    });

    testWidgets('should return English nationalProject kind', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              return Text(localizedDirectoryKind(context, 'nationalProject') ?? '-');
            },
          ),
        ),
      );

      expect(find.text('National Project'), findsOneWidget);
    });
  });

  group('localizedReadingPathSource', () {
    testWidgets('should return localized blendedRecommendation source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'blendedRecommendation'));
            },
          ),
        ),
      );

      expect(find.text('综合推荐'), findsOneWidget);
    });

    testWidgets('should return localized related source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'related'));
            },
          ),
        ),
      );

      expect(find.text('相关'), findsOneWidget);
    });

    testWidgets('should return localized recommendation source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'recommendation'));
            },
          ),
        ),
      );

      expect(find.text('推荐'), findsOneWidget);
    });

    testWidgets('should return localized semanticRecommendation source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'semanticRecommendation'));
            },
          ),
        ),
      );

      expect(find.text('语义推荐'), findsOneWidget);
    });

    testWidgets('should return localized collection source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'collection'));
            },
          ),
        ),
      );

      expect(find.text('合集'), findsOneWidget);
    });

    testWidgets('should return localized graph source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'graph'));
            },
          ),
        ),
      );

      expect(find.text('关系线索'), findsOneWidget);
    });

    testWidgets('should return localized exploreTopic source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'exploreTopic'));
            },
          ),
        ),
      );

      expect(find.text('探索主题'), findsOneWidget);
    });

    testWidgets('should return localized list source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'list'));
            },
          ),
        ),
      );

      expect(find.text('列表'), findsOneWidget);
    });

    testWidgets('should return original value for unknown source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('zh'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'unknownSource'));
            },
          ),
        ),
      );

      expect(find.text('unknownSource'), findsOneWidget);
    });

    testWidgets('should return English blendedRecommendation source', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              return Text(localizedReadingPathSource(context, 'blendedRecommendation'));
            },
          ),
        ),
      );

      expect(find.text('Blended'), findsOneWidget);
    });
  });
}
