import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/features/articles/articles_page.dart';
import 'package:heritage_online_flutter/features/directory/directory_page.dart';
import 'package:heritage_online_flutter/features/discovery/discovery_page.dart';
import 'package:heritage_online_flutter/features/inheritors/inheritors_page.dart';
import 'package:heritage_online_flutter/features/settings/settings_page.dart';
import 'package:heritage_online_flutter/features/my/my_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 主页目标
enum HomeDestination {
  articles,
  directory,
  inheritors,
  discovery;

  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case HomeDestination.articles:
        return l10n.tabArticles;
      case HomeDestination.directory:
        return l10n.tabDirectory;
      case HomeDestination.inheritors:
        return l10n.tabInheritors;
      case HomeDestination.discovery:
        return l10n.tabDiscovery;
    }
  }

  IconData get icon {
    switch (this) {
      case HomeDestination.articles:
        return Icons.article_outlined;
      case HomeDestination.directory:
        return Icons.menu_book_outlined;
      case HomeDestination.inheritors:
        return Icons.people_outline;
      case HomeDestination.discovery:
        return Icons.explore_outlined;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case HomeDestination.articles:
        return Icons.article;
      case HomeDestination.directory:
        return Icons.menu_book;
      case HomeDestination.inheritors:
        return Icons.people;
      case HomeDestination.discovery:
        return Icons.explore;
    }
  }
}

/// App Shell 状态管理
class AppShellState {
  final HomeDestination selectedDestination;
  final bool showSettings;
  final bool showMyPage;
  final bool isInDetail;

  const AppShellState({
    this.selectedDestination = HomeDestination.articles,
    this.showSettings = false,
    this.showMyPage = false,
    this.isInDetail = false,
  });

  /// 是否显示底部导航栏
  bool get shouldShowBottomBar => !showSettings && !showMyPage && !isInDetail;

  AppShellState copyWith({
    HomeDestination? selectedDestination,
    bool? showSettings,
    bool? showMyPage,
    bool? isInDetail,
  }) {
    return AppShellState(
      selectedDestination: selectedDestination ?? this.selectedDestination,
      showSettings: showSettings ?? this.showSettings,
      showMyPage: showMyPage ?? this.showMyPage,
      isInDetail: isInDetail ?? this.isInDetail,
    );
  }
}

/// App Shell 状态通知器
class AppShellNotifier extends StateNotifier<AppShellState> {
  AppShellNotifier() : super(const AppShellState());

  /// 切换 Tab
  void selectDestination(HomeDestination destination) {
    state = state.copyWith(
      selectedDestination: destination,
      showSettings: false,
      showMyPage: false,
    );
  }

  /// 显示设置页
  void showSettings() {
    state = state.copyWith(showSettings: true);
  }

  /// 隐藏设置页
  void hideSettings() {
    state = state.copyWith(showSettings: false);
  }

  /// 显示我的页
  void showMyPage() {
    state = state.copyWith(showMyPage: true);
  }

  /// 隐藏我的页
  void hideMyPage() {
    state = state.copyWith(showMyPage: false);
  }

  /// 设置是否在详情页
  void setInDetail(bool value) {
    state = state.copyWith(isInDetail: value);
  }
}

/// App Shell 状态 Provider
final appShellProvider = StateNotifierProvider<AppShellNotifier, AppShellState>((ref) {
  return AppShellNotifier();
});

/// App Shell - 主页面框架
/// 包含底部导航栏，切换四个主 Tab
/// 支持详情页隐藏底部导航
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appShellState = ref.watch(appShellProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      bottomNavigationBar: appShellState.shouldShowBottomBar
          ? NavigationBar(
              backgroundColor: colorScheme.surfaceContainerLow,
              elevation: 0,
              selectedIndex: appShellState.selectedDestination.index,
              onDestinationSelected: (index) {
                ref.read(appShellProvider.notifier).selectDestination(
                      HomeDestination.values[index],
                    );
              },
              destinations: HomeDestination.values.map((destination) {
                return NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: destination.getLabel(l10n),
                );
              }).toList(),
            )
          : null,
      body: _buildBody(context, ref, appShellState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AppShellState state) {
    // 设置页优先级高于我的页
    if (state.showSettings) {
      return SettingsPage(
        onBack: () => ref.read(appShellProvider.notifier).hideSettings(),
        onMyPageClick: () => ref.read(appShellProvider.notifier).showMyPage(),
      );
    }

    if (state.showMyPage) {
      return MyPage(
        onBack: () => ref.read(appShellProvider.notifier).hideMyPage(),
      );
    }

    return IndexedStack(
      index: state.selectedDestination.index,
      children: [
        ArticlesPage(
          onSettingsSelected: () => ref.read(appShellProvider.notifier).showSettings(),
          onDetailChanged: (inDetail) => ref.read(appShellProvider.notifier).setInDetail(inDetail),
        ),
        DirectoryPage(
          onDetailChanged: (inDetail) => ref.read(appShellProvider.notifier).setInDetail(inDetail),
        ),
        InheritorsPage(
          onDetailChanged: (inDetail) => ref.read(appShellProvider.notifier).setInDetail(inDetail),
        ),
        DiscoveryPage(
          onDetailChanged: (inDetail) => ref.read(appShellProvider.notifier).setInDetail(inDetail),
        ),
      ],
    );
  }
}
