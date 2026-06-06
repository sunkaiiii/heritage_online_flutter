import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/features/articles/articles_page.dart';
import 'package:heritage_online_flutter/features/directory/directory_page.dart';
import 'package:heritage_online_flutter/features/discovery/discovery_page.dart';
import 'package:heritage_online_flutter/features/inheritors/inheritors_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// App Shell - 主页面框架
/// 包含底部导航栏，切换四个主 Tab
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ArticlesPage(),
    DirectoryPage(),
    InheritorsPage(),
    DiscoveryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.article_outlined),
            selectedIcon: const Icon(Icons.article),
            label: l10n.tabArticles,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.tabDirectory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.tabInheritors,
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: l10n.tabDiscovery,
          ),
        ],
      ),
    );
  }
}
