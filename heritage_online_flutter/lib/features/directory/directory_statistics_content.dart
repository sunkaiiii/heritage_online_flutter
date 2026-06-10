import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/directory/directory_ui_state.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 名录统计内容
/// 匹配 Android DirectoryStatisticsContent 的视觉设计
class DirectoryStatisticsContent extends StatelessWidget {
  final DirectoryStatisticsState stats;
  final DirectoryItemKind selectedKind;
  final VoidCallback onRetry;

  const DirectoryStatisticsContent({
    super.key,
    required this.stats,
    required this.selectedKind,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Loading
    if (stats.isLoading && stats.overview == null) {
      return _StatisticsLoadingContent();
    }

    // Error
    if (stats.error != null && stats.overview == null) {
      return _StatisticsErrorContent(
        onRetry: onRetry,
      );
    }

    final overview = stats.overview;
    if (overview == null) return _StatisticsLoadingContent();

    final yearItems = stats.yearBreakdown?.items ?? [];
    final categoryItems = stats.categoryBreakdown?.items ?? [];
    final regionItems = stats.regionBreakdown?.items ?? [];

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 8),

          // 总览卡片
          _StatisticsOverviewCard(
            total: overview.total,
            kindLabel: localizedDirectoryKind(context, selectedKind.wireName) ?? selectedKind.wireName,
            generatedAt: overview.generatedAt,
            dimensionCount: overview.dimensions.length,
            l10n: l10n,
          ),

          // 年份分布
          if (yearItems.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: l10n.statisticsYearTitle),
            const SizedBox(height: 12),
            _YearBarChart(items: yearItems),
          ],

          // 类别分布
          if (categoryItems.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: l10n.statisticsCategoryTitle),
            const SizedBox(height: 12),
            _CategoryCardGrid(items: categoryItems, total: overview.total),
          ],

          // 地区排行
          if (regionItems.isNotEmpty) ...[
            const SizedBox(height: 18),
            SectionHeader(title: l10n.statisticsRegionTitle),
            const SizedBox(height: 12),
            _RegionRankingList(
              items: regionItems.take(20).toList(),
              maxValue: regionItems.isNotEmpty ? regionItems.first.value : 1,
            ),
          ],

          // 全部为空
          if (yearItems.isEmpty && categoryItems.isEmpty && regionItems.isEmpty)
            _StatisticsEmptyContent(),

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

// ==================== 总览卡片 ====================

class _StatisticsOverviewCard extends StatelessWidget {
  final int total;
  final String kindLabel;
  final String? generatedAt;
  final int dimensionCount;
  final AppLocalizations l10n;

  const _StatisticsOverviewCard({
    required this.total,
    required this.kindLabel,
    this.generatedAt,
    required this.dimensionCount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$total',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            kindLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (generatedAt != null && generatedAt!.isNotEmpty)
            Text(
              l10n.statisticsGeneratedAt(
                generatedAt!.length >= 10 ? generatedAt!.substring(0, 10) : generatedAt!,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          if (dimensionCount > 0)
            Text(
              l10n.statisticsDimensionsCount(dimensionCount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}

// ==================== 年份柱状图 ====================

const _barColors = [
  Color(0xFFE8B86D),
  Color(0xFFC74B4B),
  Color(0xFFA67C52),
  Color(0xFF6B8E6B),
  Color(0xFFD4956B),
  Color(0xFF8B6B5A),
  Color(0xFFB8865A),
  Color(0xFFCD7F5A),
];

class _YearBarChart extends StatelessWidget {
  final List<DirectoryStatisticItemDto> items;

  const _YearBarChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final maxValue = items.fold<int>(0, (max, item) => math.max(max, item.value));
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 240,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final ratio = maxValue > 0 ? item.value / maxValue : 0.0;
            final color = item.value == maxValue ? primaryColor : _barColors[index % _barColors.length];
            final yearLabel = item.name ?? item.key ?? '';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 数量
                  Text(
                    '${item.value}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  // 柱状图
                  CustomPaint(
                    size: const Size(40, 180),
                    painter: _BarPainter(
                      ratio: ratio.clamp(0.02, 1.0),
                      color: color,
                      cornerRadius: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 年份标签
                  SizedBox(
                    width: 40,
                    child: Text(
                      yearLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final double ratio;
  final Color color;
  final double cornerRadius;

  _BarPainter({
    required this.ratio,
    required this.color,
    this.cornerRadius = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barHeight = size.height * ratio;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height - barHeight, size.width, barHeight),
      Radius.circular(cornerRadius),
    );
    final paint = Paint()..color = color;
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      oldDelegate.ratio != ratio || oldDelegate.color != color;
}

// ==================== 类别卡片网格 ====================

const _categoryColors = [
  Color(0xFFE8B86D),
  Color(0xFFC74B4B),
  Color(0xFF6B8E6B),
  Color(0xFFD4956B),
  Color(0xFF8B7355),
  Color(0xFFCD7F5A),
  Color(0xFF5B8C85),
  Color(0xFFB8865A),
  Color(0xFF9B6B5A),
  Color(0xFF7B8B6B),
];

class _CategoryCardGrid extends StatelessWidget {
  final List<DirectoryStatisticItemDto> items;
  final int total;

  const _CategoryCardGrid({required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final color = _categoryColors[index % _categoryColors.length];
        final icon = _categoryIcon(item.name ?? item.key);
        final name = item.name ?? item.key ?? '';
        final percentage = total > 0 ? (item.value / total * 100.0) : 0.0;

        return _CategoryCard(
          name: name,
          count: item.value,
          percentage: percentage,
          icon: icon,
          color: color,
        );
      }),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final int count;
  final double percentage;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.name,
    required this.count,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ContentCard(
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        width: 152,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              l10n.statisticsPercentageFormat(percentage),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 根据类别名称映射图标
IconData _categoryIcon(String? text) {
  final t = (text ?? '').trim();
  if (t.contains('音乐')) return Icons.music_note;
  if (t.contains('舞蹈')) return Icons.directions_run;
  if (t.contains('戏剧') || t.contains('戏曲')) return Icons.theater_comedy;
  if (t.contains('曲艺')) return Icons.mic;
  if (t.contains('体育') || t.contains('杂技') || t.contains('游艺')) return Icons.emoji_events;
  if (t.contains('美术')) return Icons.palette;
  if (t.contains('技艺')) return Icons.build;
  if (t.contains('医药') || t.contains('医学')) return Icons.local_pharmacy;
  if (t.contains('民俗')) return Icons.festival;
  if (t.contains('文学') || t.contains('传说') || t.contains('故事')) return Icons.menu_book;
  return Icons.emoji_events;
}

// ==================== 地区排行 ====================

class _RegionRankingList extends StatelessWidget {
  final List<DirectoryStatisticItemDto> items;
  final int maxValue;

  const _RegionRankingList({required this.items, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final name = item.name ?? item.key ?? '';
          final ratio = maxValue > 0 ? item.value / maxValue : 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RegionRankRow(
              rank: index + 1,
              name: name,
              count: item.value,
              ratio: ratio.clamp(0.0, 1.0),
            ),
          );
        }),
      ),
    );
  }
}

class _RegionRankRow extends StatelessWidget {
  final int rank;
  final String name;
  final int count;
  final double ratio;

  const _RegionRankRow({
    required this.rank,
    required this.name,
    required this.count,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // 排名
        _buildRankIndicator(context),
        const SizedBox(width: 10),
        // 名称
        Expanded(
          flex: 32,
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        // 进度条
        Expanded(
          flex: 52,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(
                rank <= 3 ? colorScheme.primary : colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // 数量
        SizedBox(
          width: 36,
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildRankIndicator(BuildContext context) {
    switch (rank) {
      case 1:
        return _MedalBadge(color: const Color(0xFFFFD700), label: '1');
      case 2:
        return _MedalBadge(color: const Color(0xFFC0C0C0), label: '2');
      case 3:
        return _MedalBadge(color: const Color(0xFFCD7F32), label: '3');
      default:
        return SizedBox(
          width: 20,
          child: Text(
            '$rank',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}

class _MedalBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _MedalBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ==================== 辅助组件 ====================

class _StatisticsLoadingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              l10n.statisticsLoading,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsErrorContent extends StatelessWidget {
  final VoidCallback onRetry;

  const _StatisticsErrorContent({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.statisticsLoadFailed,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.commonError,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsEmptyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          l10n.statisticsEmptyMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
