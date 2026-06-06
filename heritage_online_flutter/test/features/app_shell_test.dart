import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/features/app_shell.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

void main() {
  /// 创建测试用的 MaterialApp，使用生成的本地化配置
  Widget createTestApp() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppShell(),
      ),
    );
  }

  group('AppShell', () {
    testWidgets('should display four navigation tabs', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // 验证底部导航栏存在
      expect(find.byType(NavigationBar), findsOneWidget);

      // 验证有四个导航目标
      expect(find.byType(NavigationDestination), findsNWidgets(4));
    });

    testWidgets('should switch tabs on tap', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // 初始状态选中第一个 tab
      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navigationBar.selectedIndex, 0);

      // 点击第二个 tab
      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();

      // 验证选中状态改变
      final updatedNavigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(updatedNavigationBar.selectedIndex, 1);
    });
  });
}
