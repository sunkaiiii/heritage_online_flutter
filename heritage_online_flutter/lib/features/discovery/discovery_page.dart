import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/features/discovery/discovery_ui_state.dart';
import 'package:heritage_online_flutter/features/discovery/discovery_view_model.dart';
import 'package:heritage_online_flutter/features/discovery/placeholder_pages.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 发现页
class DiscoveryPage extends ConsumerWidget {
  final ValueChanged<bool>? onDetailChanged;

  const DiscoveryPage({
    super.key,
    this.onDetailChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(discoveryViewModelProvider);

    return Scaffold(
      appBar: _buildAppBar(context, ref, l10n),
      body: PageBackground(
        child: _buildBody(context, ref, state, l10n),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.discoveryTitle),
          Text(
            l10n.discoverySubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.actionRefresh,
          onPressed: () =>
              ref.read(discoveryViewModelProvider.notifier).refresh(),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DiscoveryUiState state,
    AppLocalizations l10n,
  ) {
    // 全部失败时显示全页错误
    if (state.isAllFailed) {
      return ErrorRetryRow(
        message: l10n.commonError,
        onRetry: () => ref.read(discoveryViewModelProvider.notifier).refresh(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async =>
          ref.read(discoveryViewModelProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 搜索框入口
          _buildSearchEntry(context, l10n),
          const SizedBox(height: 24),

          // 随便看看按钮
          _buildSerendipityButton(context, ref, state, l10n),
          const SizedBox(height: 16),

          // 今日发现
          _buildDiscoverySection(
            context,
            title: l10n.discoveryToday,
            sectionState: state.today,
            onRetry: () =>
                ref.read(discoveryViewModelProvider.notifier).loadToday(),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 正在被看见
          _buildDiscoverySection(
            context,
            title: l10n.discoveryTrending,
            sectionState: state.trending,
            onRetry: () =>
                ref.read(discoveryViewModelProvider.notifier).loadTrending(),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 本周非遗包
          _buildDiscoverySection(
            context,
            title: l10n.discoveryWeekly,
            sectionState: state.weekly,
            onRetry: () =>
                ref.read(discoveryViewModelProvider.notifier).loadWeekly(),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 今日探索
          _buildNavigationSection(
            context,
            title: l10n.discoveryExploreTopics,
            icon: Icons.explore,
            onTap: () => _navigateTo(context, const ExploreTopicsPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 学习路径
          _buildNavigationSection(
            context,
            title: l10n.discoveryLearningPaths,
            icon: Icons.school,
            onTap: () => _navigateTo(context, const LearningPathsPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 精选合集
          _buildNavigationSection(
            context,
            title: l10n.discoveryFeaturedCollections,
            icon: Icons.collections_bookmark,
            onTap: () => _navigateTo(context, const FeaturedCollectionsPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 地区图谱
          _buildNavigationSection(
            context,
            title: l10n.discoveryRegionAtlas,
            icon: Icons.map,
            onTap: () => _navigateTo(context, const RegionAtlasPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 时间线
          _buildNavigationSection(
            context,
            title: l10n.discoveryTimeline,
            subtitle: l10n.discoveryTimelineSubtitle,
            icon: Icons.timeline,
            onTap: () => _navigateTo(context, const TimelinePage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 主题库
          _buildNavigationSection(
            context,
            title: l10n.discoveryTaxonomy,
            icon: Icons.category,
            onTap: () => _navigateTo(context, const TaxonomyPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 数据故事
          _buildNavigationSection(
            context,
            title: l10n.discoveryStories,
            icon: Icons.auto_stories,
            onTap: () => _navigateTo(context, const StoriesPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 主题对比
          _buildNavigationSection(
            context,
            title: l10n.compareTitle,
            icon: Icons.compare_arrows,
            onTap: () => _navigateTo(context, const ComparePlaceholderPage()),
            l10n: l10n,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ==================== 搜索框 ====================

  Widget _buildSearchEntry(BuildContext context, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _navigateTo(context, const SearchPage()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.discoverySearchPlaceholder,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== 随便看看 ====================

  Widget _buildSerendipityButton(
    BuildContext context,
    WidgetRef ref,
    DiscoveryUiState state,
    AppLocalizations l10n,
  ) {
    return ContentCard(
      onTap: state.serendipityLoading
          ? null
          : () => ref
              .read(discoveryViewModelProvider.notifier)
              .serendipity(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.shuffle,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              state.serendipityLoading
                  ? l10n.discoverySerendipityLoading
                  : l10n.discoverySerendipity,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (state.serendipityLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  // ==================== 发现内容区块 ====================

  Widget _buildDiscoverySection(
    BuildContext context, {
    required String title,
    required DiscoverySectionState sectionState,
    required VoidCallback onRetry,
    required AppLocalizations l10n,
  }) {
    // loading 态 — 显示区块 placeholder
    if (sectionState.isLoading && !sectionState.hasData) {
      return _buildPlaceholderBlock(context, title);
    }

    // error 态 — 显示 retry
    if (sectionState.hasError) {
      return ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: title),
            const SizedBox(height: 8),
            ErrorRetryRow(message: l10n.commonError, onRetry: onRetry),
          ],
        ),
      );
    }

    // 无数据 — 隐藏区块
    if (!sectionState.hasData) {
      return const SizedBox.shrink();
    }

    // 有数据 — 显示内容卡片（第一版用动态列表渲染）
    return _buildDataBlock(context, title: title, data: sectionState.data, l10n: l10n);
  }

  Widget _buildPlaceholderBlock(BuildContext context, String title) {
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          const SizedBox(height: 12),
          const LoadingPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildDataBlock(
    BuildContext context, {
    required String title,
    required dynamic data,
    required AppLocalizations l10n,
  }) {
    // 第一版：将数据以简化卡片形式展示
    // 后续 Step 可替换为专用卡片组件
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          const SizedBox(height: 8),
          Text(
            l10n.commonEmpty, // 占位 — 实际显示逻辑由后续 DTO 类型化后完善
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // ==================== 导航区块 ====================

  Widget _buildNavigationSection(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required AppLocalizations l10n,
  }) {
    return ContentCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
