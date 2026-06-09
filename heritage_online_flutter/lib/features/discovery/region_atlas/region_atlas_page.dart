import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/region_dtos.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_atlas_ui_state.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_atlas_view_model.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 地区图谱首页
class RegionAtlasListPage extends ConsumerWidget {
  final VoidCallback onBack;

  const RegionAtlasListPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(regionAtlasViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.discoveryRegionAtlas),
      ),
      body: PageBackground(
        child: _buildBody(context, l10n, state, ref),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    RegionAtlasUiState state,
    WidgetRef ref,
  ) {
    if (state.isLoading) {
      return const LoadingPlaceholder();
    }

    if (state.error != null) {
      return ErrorRetryRow(
        message: l10n.commonError,
        onRetry: () => ref.read(regionAtlasViewModelProvider.notifier).retry(),
      );
    }

    final atlas = state.atlas;
    if (atlas == null || atlas.regions.isEmpty) {
      return EmptyState(message: l10n.commonEmpty);
    }

    return _RegionAtlasContent(
      atlas: atlas,
      l10n: l10n,
      onRegionTap: (region) => _navigateToDetail(context, region),
    );
  }

  void _navigateToDetail(BuildContext context, String region) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegionDetailPage(
          region: region,
          onBack: () => Navigator.of(context).pop(),
          onRegionTap: (r) => _navigateToDetail(context, r),
        ),
      ),
    );
  }
}

/// 地区图谱内容
class _RegionAtlasContent extends StatelessWidget {
  final RegionAtlasDto atlas;
  final AppLocalizations l10n;
  final ValueChanged<String> onRegionTap;

  const _RegionAtlasContent({
    required this.atlas,
    required this.l10n,
    required this.onRegionTap,
  });

  @override
  Widget build(BuildContext context) {
    final totals = atlas.totals;

    return CustomScrollView(
      slivers: [
        // 全局统计
        if (totals != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _TotalsBar(totals: totals, l10n: l10n),
            ),
          ),

        // 地区卡片网格
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = atlas.regions[index];
                return _RegionCard(
                  item: item,
                  onTap: () => onRegionTap(item.region ?? ''),
                );
              },
              childCount: atlas.regions.length,
            ),
          ),
        ),

        // 底部间距
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

/// 全局统计栏
class _TotalsBar extends StatelessWidget {
  final RegionAtlasTotalsDto totals;
  final AppLocalizations l10n;

  const _TotalsBar({required this.totals, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '${totals.directoryItemCount}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.regionAtlasDirectoryItems,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '${totals.inheritorCount}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.regionAtlasInheritors,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onTertiaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: colorScheme.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    l10n.regionAtlasTotalRegions(totals.regionCount),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 地区卡片
class _RegionCard extends StatelessWidget {
  final RegionAtlasItemDto item;
  final VoidCallback onTap;

  const _RegionCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

    return ContentCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片区域
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: imageUrl != null
                  ? ListImage(imageUrl: imageUrl, fallbackText: item.displayName ?? '')
                  : ImagePlaceholder(
                      text: item.displayName?.isNotEmpty == true
                          ? item.displayName!.substring(0, 1)
                          : '',
                    ),
            ),
          ),

          // 文本区域
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 地区名称
                Text(
                  item.displayName ?? item.region ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // 统计标签
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    MetaChip(text: '${item.directoryItemCount}'),
                    MetaChip(text: '${item.inheritorCount}'),
                    MetaChip(text: '${item.total}'),
                  ],
                ),

                // Top categories
                if (item.topCategories.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.topCategories
                        .take(2)
                        .map((c) => c.key ?? '')
                        .where((s) => s.isNotEmpty)
                        .join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Top kinds
                if (item.topKinds.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.topKinds
                        .take(2)
                        .map((k) => k.key ?? '')
                        .where((s) => s.isNotEmpty)
                        .join(' · '),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
