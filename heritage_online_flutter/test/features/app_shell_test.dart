import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/core/settings/settings_provider.dart';
import 'package:heritage_online_flutter/features/app_shell.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Widget createTestWidget({required Widget child}) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  group('AppShell', () {
    testWidgets('should display four navigation tabs', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationDestination), findsNWidgets(4));
    });

    testWidgets('should display articles page by default', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 验证文章页面标题显示
      expect(find.text('E迹'), findsOneWidget);
    });

    testWidgets('should switch tabs on tap', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 初始状态选中第一个 tab
      final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navigationBar.selectedIndex, 0);

      // 点击第二个 tab
      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();

      // 验证选中状态改变
      final updatedNavigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(updatedNavigationBar.selectedIndex, 1);
    });

    testWidgets('should hide bottom bar when in settings', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 点击设置按钮
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // 验证底部导航栏隐藏
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('should show bottom bar when back from settings', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 点击设置按钮
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // 验证底部导航栏隐藏
      expect(find.byType(NavigationBar), findsNothing);

      // 点击返回按钮
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // 验证底部导航栏显示
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('should preserve tab state when switching', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 切换到名录 tab
      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();

      // 切换回文章 tab
      await tester.tap(find.byType(NavigationDestination).at(0));
      await tester.pumpAndSettle();

      // 验证文章页面仍然显示
      expect(find.text('E迹'), findsOneWidget);
    });

    testWidgets('should navigate to my page from settings', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 点击设置按钮
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // 找到我的页入口（第一个带图标的 ListTile）
      final myPageTile = find.byWidgetPredicate((widget) =>
          widget is ListTile && widget.leading is Icon);
      expect(myPageTile, findsWidgets);

      // 点击第一个 ListTile（我的页入口）
      await tester.tap(myPageTile.first);
      await tester.pumpAndSettle();

      // 验证我的页显示 - 有返回按钮
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should back from my page to settings', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppShell()));
      await tester.pumpAndSettle();

      // 点击设置按钮
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // 找到并点击我的页入口
      final myPageTile = find.byWidgetPredicate((widget) =>
          widget is ListTile && widget.leading is Icon);
      await tester.tap(myPageTile.first);
      await tester.pumpAndSettle();

      // 点击返回按钮
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // 验证回到设置页（AppBar 标题）
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('HomeDestination', () {
    test('should have correct labels', () {
      expect(HomeDestination.values.length, 4);
      expect(HomeDestination.articles.index, 0);
      expect(HomeDestination.directory.index, 1);
      expect(HomeDestination.inheritors.index, 2);
      expect(HomeDestination.discovery.index, 3);
    });

    test('should have correct icons', () {
      expect(HomeDestination.articles.icon, Icons.article_outlined);
      expect(HomeDestination.articles.selectedIcon, Icons.article);
      expect(HomeDestination.directory.icon, Icons.menu_book_outlined);
      expect(HomeDestination.directory.selectedIcon, Icons.menu_book);
      expect(HomeDestination.inheritors.icon, Icons.people_outline);
      expect(HomeDestination.inheritors.selectedIcon, Icons.people);
      expect(HomeDestination.discovery.icon, Icons.explore_outlined);
      expect(HomeDestination.discovery.selectedIcon, Icons.explore);
    });
  });

  group('AppShellState', () {
    test('should have default values', () {
      const state = AppShellState();
      expect(state.selectedDestination, HomeDestination.articles);
      expect(state.showSettings, isFalse);
      expect(state.showMyPage, isFalse);
      expect(state.isInDetail, isFalse);
    });

    test('shouldShowBottomBar should be true by default', () {
      const state = AppShellState();
      expect(state.shouldShowBottomBar, isTrue);
    });

    test('shouldShowBottomBar should be false when showSettings is true', () {
      const state = AppShellState(showSettings: true);
      expect(state.shouldShowBottomBar, isFalse);
    });

    test('shouldShowBottomBar should be false when showMyPage is true', () {
      const state = AppShellState(showMyPage: true);
      expect(state.shouldShowBottomBar, isFalse);
    });

    test('shouldShowBottomBar should be false when isInDetail is true', () {
      const state = AppShellState(isInDetail: true);
      expect(state.shouldShowBottomBar, isFalse);
    });

    test('copyWith should work correctly', () {
      const state = AppShellState();
      final updated = state.copyWith(
        selectedDestination: HomeDestination.directory,
        showSettings: true,
      );

      expect(updated.selectedDestination, HomeDestination.directory);
      expect(updated.showSettings, isTrue);
      expect(updated.showMyPage, isFalse);
      expect(updated.isInDetail, isFalse);
    });
  });

  group('AppShellNotifier', () {
    late AppShellNotifier notifier;

    setUp(() {
      notifier = AppShellNotifier();
    });

    test('initial state should be correct', () {
      expect(notifier.state.selectedDestination, HomeDestination.articles);
      expect(notifier.state.showSettings, isFalse);
      expect(notifier.state.showMyPage, isFalse);
      expect(notifier.state.isInDetail, isFalse);
    });

    test('selectDestination should update destination', () {
      notifier.selectDestination(HomeDestination.directory);
      expect(notifier.state.selectedDestination, HomeDestination.directory);
    });

    test('selectDestination should hide settings', () {
      notifier.showSettings();
      notifier.selectDestination(HomeDestination.directory);
      expect(notifier.state.showSettings, isFalse);
    });

    test('selectDestination should hide my page', () {
      notifier.showMyPage();
      notifier.selectDestination(HomeDestination.directory);
      expect(notifier.state.showMyPage, isFalse);
    });

    test('showSettings should work', () {
      notifier.showSettings();
      expect(notifier.state.showSettings, isTrue);
    });

    test('hideSettings should work', () {
      notifier.showSettings();
      notifier.hideSettings();
      expect(notifier.state.showSettings, isFalse);
    });

    test('showMyPage should work', () {
      notifier.showMyPage();
      expect(notifier.state.showMyPage, isTrue);
    });

    test('hideMyPage should work', () {
      notifier.showMyPage();
      notifier.hideMyPage();
      expect(notifier.state.showMyPage, isFalse);
    });

    test('setInDetail should work', () {
      notifier.setInDetail(true);
      expect(notifier.state.isInDetail, isTrue);
      notifier.setInDetail(false);
      expect(notifier.state.isInDetail, isFalse);
    });
  });
}
