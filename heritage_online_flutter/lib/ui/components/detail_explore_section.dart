import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/network/dto/context_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/digest_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/recommendation_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/content_navigator.dart';

/// 详情探索区状态
class DetailExploreState {
  final ContentDigestDto? digest;
  final bool digestLoading;
  final String? digestError;

  final DetailContextDto? context;
  final bool contextLoading;
  final String? contextError;

  final BlendedRecommendationResponseDto? blended;
  final bool blendedLoading;
  final String? blendedError;

  const DetailExploreState({
    this.digest,
    this.digestLoading = false,
    this.digestError,
    this.context,
    this.contextLoading = false,
    this.contextError,
    this.blended,
    this.blendedLoading = false,
    this.blendedError,
  });

  /// 是否有任何数据、loading 或 error
  bool get hasAnyContent =>
      digest != null ||
      digestLoading ||
      digestError != null ||
      context != null ||
      contextLoading ||
      contextError != null ||
      blended != null ||
      blendedLoading ||
      blendedError != null;

  /// 是否有有效的综合推荐条目
  bool get hasValidBlendedItems =>
      blended != null &&
      blended!.items.any((item) => item.id.isNotEmpty && item.title.isNotEmpty);
}

/// 导航回调类型定义
typedef NavigateCallback = void Function({
  required String toType,
  required String toId,
  required String source,
  String? toTitle,
  String? toCategory,
  String? toKind,
  String? toSourceId,
  String? toSourceUrl,
});

/// 详情页底部探索区
/// 匹配 Android DetailExploreSection 的视觉设计
/// 顺序：Digest → Blended Recommendations → Context (Related, Recommendations, Semantic, Collections, Topics, Graph)
class DetailExploreSection extends StatelessWidget {
  final DetailExploreState state;
  final String contentType;
  final String contentId;
  final String? contentTitle;
  final VoidCallback? onDigestRetry;
  final VoidCallback? onContextRetry;
  final VoidCallback? onBlendedRetry;
  final NavigateCallback? onNavigate;

  const DetailExploreSection({
    super.key,
    required this.state,
    required this.contentType,
    required this.contentId,
    this.contentTitle,
    this.onDigestRetry,
    this.onContextRetry,
    this.onBlendedRetry,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // 所有区块都没有数据、loading、error 时隐藏整个探索区
    if (!state.hasAnyContent) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        SectionHeader(title: l10n.exploreSectionTitle),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.exploreSectionSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 16),

        // 1. Digest
        _buildDigest(context, l10n),

        // 2. Blended Recommendations
        _buildBlended(context, l10n),

        // 3-8. Context sections
        _buildContext(context, l10n),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDigest(BuildContext context, AppLocalizations l10n) {
    if (state.digestLoading) {
      return _ContextLoadingPlaceholder(l10n: l10n);
    }

    if (state.digestError != null) {
      return _ContextErrorRow(
        message: l10n.commonError,
        onRetry: onDigestRetry ?? () {},
        l10n: l10n,
      );
    }

    final digest = state.digest;
    if (digest == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _DigestCard(digest: digest, l10n: l10n),
    );
  }

  Widget _buildBlended(BuildContext context, AppLocalizations l10n) {
    if (state.blendedLoading) {
      return _ContextLoadingPlaceholder(l10n: l10n);
    }

    if (state.blendedError != null) {
      return _ContextErrorRow(
        message: l10n.commonError,
        onRetry: onBlendedRetry ?? () {},
        l10n: l10n,
      );
    }

    if (!state.hasValidBlendedItems) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _BlendedRecommendationsSection(
        items: state.blended!.items
            .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
            .toList(),
        l10n: l10n,
        fromType: contentType,
        fromId: contentId,
        fromTitle: contentTitle,
        onNavigate: onNavigate,
      ),
    );
  }

  Widget _buildContext(BuildContext context, AppLocalizations l10n) {
    if (state.contextLoading) {
      return _ContextLoadingPlaceholder(l10n: l10n);
    }

    if (state.contextError != null) {
      return _ContextErrorRow(
        message: l10n.commonError,
        onRetry: onContextRetry ?? () {},
        l10n: l10n,
      );
    }

    final ctx = state.context;
    if (ctx == null) return const SizedBox.shrink();

    return _DetailContextSection(
      context: ctx,
      contentType: contentType,
      contentId: contentId,
      contentTitle: contentTitle,
      onNavigate: onNavigate,
      l10n: l10n,
    );
  }
}

// ==================== Digest 卡片 ====================

class _DigestCard extends StatefulWidget {
  final ContentDigestDto digest;
  final AppLocalizations l10n;

  const _DigestCard({required this.digest, required this.l10n});

  @override
  State<_DigestCard> createState() => _DigestCardState();
}

class _DigestCardState extends State<_DigestCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final digest = widget.digest;
    final l10n = widget.l10n;
    final showHighlights = digest.highlights.isNotEmpty;
    final showKeyFacts = digest.keyFacts.isNotEmpty;
    final showKeywords = digest.keywords.isNotEmpty;

    return ContentCard(
      padding: const EdgeInsets.all(14),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(l10n.digestTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 10),

            // quickRead
            if (digest.quickRead != null && digest.quickRead!.isNotEmpty) ...[
              Text(digest.quickRead!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
              const SizedBox(height: 10),
            ],

            // 阅读时间
            if (digest.readingTimeMinutes > 0) ...[
              Text(l10n.digestReadingTime(digest.readingTimeMinutes),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
              const SizedBox(height: 10),
            ],

            // 要点
            if (showHighlights) ...[
              Text(l10n.digestHighlights,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
              const SizedBox(height: 4),
              ...digest.highlights
                  .take(_expanded ? digest.highlights.length : 3)
                  .map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: Theme.of(context).textTheme.bodySmall),
                            Expanded(
                                child: Text(h,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ))),
                          ],
                        ),
                      )),
              if (digest.highlights.length > 3)
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _expanded ? l10n.showLess : l10n.showMore,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
            ],

            // 关键信息
            if (showKeyFacts) ...[
              const SizedBox(height: 10),
              Text(l10n.digestKeyFacts,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: digest.keyFacts
                    .map((f) => ActionChip(
                          label: Text('${f.label}: ${f.value}',
                              style: Theme.of(context).textTheme.bodySmall),
                          onPressed: () {},
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(
                            color:
                                Theme.of(context).colorScheme.outlineVariant,
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          pressElevation: 0,
                        ))
                    .toList(),
              ),
            ],

            // 关键词
            if (showKeywords) ...[
              const SizedBox(height: 10),
              Text(l10n.digestKeywords,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children:
                    digest.keywords.map((k) => ActionChip(
                      label: Text(k, style: Theme.of(context).textTheme.bodySmall),
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pressElevation: 0,
                    )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== 综合推荐 ====================

class _BlendedRecommendationsSection extends StatelessWidget {
  final List<BlendedRecommendationItemDto> items;
  final AppLocalizations l10n;
  final String fromType;
  final String fromId;
  final String? fromTitle;
  final NavigateCallback? onNavigate;

  const _BlendedRecommendationsSection({
    required this.items,
    required this.l10n,
    required this.fromType,
    required this.fromId,
    this.fromTitle,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.blendedRecommendationsTitle,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            l10n.blendedSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _BlendedRecommendationCard(
              item: items[index],
              fromType: fromType,
              fromId: fromId,
              fromTitle: fromTitle,
              onNavigate: onNavigate,
              l10n: l10n,
            ),
          ),
        ),
      ],
    );
  }
}

class _BlendedRecommendationCard extends StatefulWidget {
  final BlendedRecommendationItemDto item;
  final String fromType;
  final String fromId;
  final String? fromTitle;
  final NavigateCallback? onNavigate;
  final AppLocalizations l10n;

  const _BlendedRecommendationCard({
    required this.item,
    required this.fromType,
    required this.fromId,
    this.fromTitle,
    this.onNavigate,
    required this.l10n,
  });

  @override
  State<_BlendedRecommendationCard> createState() =>
      _BlendedRecommendationCardState();
}

class _BlendedRecommendationCardState
    extends State<_BlendedRecommendationCard> {
  bool _showAllReasons = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final l10n = widget.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 240,
      child: ContentCard(
        onTap: () => _navigateToDetail(context),
        padding: const EdgeInsets.all(12),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行 + 箭头
              Row(
                children: [
                  Expanded(
                    child: Text(item.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.chevron_right,
                      size: 18, color: colorScheme.onSurfaceVariant),
                ],
              ),

              // 副标题
              if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(item.subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],

              // Meta chips
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 2,
                children: [
                  if (item.type.isNotEmpty)
                    MetaChip(
                        text: localizedContentType(context, item.type) ??
                            item.type),
                  if (item.category != null && item.category!.isNotEmpty)
                    MetaChip(text: item.category!),
                  if (item.region != null && item.region!.isNotEmpty)
                    MetaChip(text: item.region!),
                ],
              ),

              // 推荐理由
              if (item.reasons.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(l10n.blendedReasons,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        )),
                const SizedBox(height: 2),
                ...item.reasons
                    .take(_showAllReasons ? item.reasons.length : 2)
                    .map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style:
                                      Theme.of(context).textTheme.bodySmall),
                              Expanded(
                                child: Text(r,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )),
                if (item.reasons.length > 2)
                  TextButton(
                    onPressed: () =>
                        setState(() => _showAllReasons = !_showAllReasons),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _showAllReasons ? l10n.showLess : l10n.showMore,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                          ),
                    ),
                  ),
              ],

              const Spacer(),

              // 得分分解条
              if (item.score > 0)
                _ScoreBreakdownBar(breakdown: item.scoreBreakdown),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    final item = widget.item;
    widget.onNavigate?.call(
      toType: item.type,
      toId: item.id,
      source: 'blendedRecommendation',
      toTitle: item.title,
      toCategory: item.category,
      toKind: item.kind,
      toSourceId: item.sourceId,
      toSourceUrl: item.sourceUrl.isNotEmpty ? item.sourceUrl : null,
    );

    ContentNavigator.toDetail(
      context,
      type: item.type,
      id: item.id.isNotEmpty ? item.id : null,
      sourceId: item.sourceId,
      sourceUrl: item.sourceUrl.isNotEmpty ? item.sourceUrl : null,
      category: item.category,
      kind: item.kind,
    );
  }
}

/// 得分分解条
class _ScoreBreakdownBar extends StatelessWidget {
  final RecommendationScoreBreakdownDto breakdown;

  const _ScoreBreakdownBar({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = breakdown.explicit +
        breakdown.inferred +
        breakdown.embedding +
        breakdown.sameCategory +
        breakdown.sameRegion;

    if (total <= 0) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 6,
        child: Row(
          children: [
            if (breakdown.explicit > 0)
              Expanded(
                flex: (breakdown.explicit * 1000).round(),
                child: Container(color: colorScheme.primary),
              ),
            if (breakdown.inferred > 0)
              Expanded(
                flex: (breakdown.inferred * 1000).round(),
                child: Container(color: colorScheme.secondary),
              ),
            if (breakdown.embedding > 0)
              Expanded(
                flex: (breakdown.embedding * 1000).round(),
                child: Container(color: colorScheme.tertiary),
              ),
            if (breakdown.sameCategory > 0)
              Expanded(
                flex: (breakdown.sameCategory * 1000).round(),
                child: Container(color: colorScheme.primaryContainer),
              ),
            if (breakdown.sameRegion > 0)
              Expanded(
                flex: (breakdown.sameRegion * 1000).round(),
                child: Container(color: colorScheme.secondaryContainer),
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== Context 区块 ====================

class _DetailContextSection extends StatelessWidget {
  final DetailContextDto context;
  final String contentType;
  final String contentId;
  final String? contentTitle;
  final AppLocalizations l10n;
  final NavigateCallback? onNavigate;

  const _DetailContextSection({
    required this.context,
    required this.contentType,
    required this.contentId,
    this.contentTitle,
    required this.l10n,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final ctx = this.context;
    final hasRelated = ctx.related.isNotEmpty;
    final hasRecommendations = ctx.recommendations.isNotEmpty;
    final hasSemantic = ctx.semanticRecommendations.isNotEmpty;
    final hasCollections = ctx.collections.isNotEmpty;
    final hasTopics = ctx.exploreTopics.isNotEmpty;
    final hasGraph = ctx.graph != null && ctx.graph!.edges.isNotEmpty;

    if (!hasRelated &&
        !hasRecommendations &&
        !hasSemantic &&
        !hasCollections &&
        !hasTopics &&
        !hasGraph) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasRelated) ...[
          SectionHeader(title: l10n.contextRelatedTitle),
          const SizedBox(height: 8),
          ...ctx.related.map((item) => _RelatedItemRow(
                item: item,
                fromType: contentType,
                fromId: contentId,
                fromTitle: contentTitle,
                onNavigate: onNavigate,
              )),
          const SizedBox(height: 16),
        ],
        if (hasRecommendations) ...[
          SectionHeader(title: l10n.contextRecommendationsTitle),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ctx.recommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RecommendationCard(
                item: ctx.recommendations[index],
                fromType: contentType,
                fromId: contentId,
                fromTitle: contentTitle,
                source: 'recommendation',
                onNavigate: onNavigate,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hasSemantic) ...[
          SectionHeader(title: l10n.contextSemanticTitle),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ctx.semanticRecommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RecommendationCard(
                item: ctx.semanticRecommendations[index],
                fromType: contentType,
                fromId: contentId,
                fromTitle: contentTitle,
                source: 'semanticRecommendation',
                onNavigate: onNavigate,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hasCollections) ...[
          SectionHeader(title: l10n.contextCollectionsTitle),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ctx.collections.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _ContextCollectionCard(collection: ctx.collections[index], l10n: l10n),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hasTopics) ...[
          SectionHeader(title: l10n.contextTopicsTitle),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: ctx.exploreTopics
                  .map((topic) => FilterChip(
                        label: Text(topic.title ?? topic.key ?? ''),
                        selected: false,
                        onSelected: (_) {
                          if (topic.type != null && topic.key != null) {
                            ContentNavigator.toExploreTopic(
                              context,
                              type: topic.type!,
                              topicKey: topic.key!,
                            );
                          }
                        },
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (hasGraph) ...[
          SectionHeader(title: l10n.contextGraphTitle),
          const SizedBox(height: 8),
          ...ctx.graph!.edges.map((edge) => _GraphEdgeRow(
                edge: edge,
                nodes: ctx.graph!.nodes,
                fromType: contentType,
                fromId: contentId,
                onNavigate: onNavigate,
              )),
        ],
      ],
    );
  }
}

// ==================== 相关内容行 ====================

class _RelatedItemRow extends StatelessWidget {
  final RelatedSummaryDto item;
  final String fromType;
  final String fromId;
  final String? fromTitle;
  final NavigateCallback? onNavigate;

  const _RelatedItemRow({
    required this.item,
    required this.fromType,
    required this.fromId,
    this.fromTitle,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // 构建 meta 字符串：category . region . kind
    final metaParts = <String>[];
    if (item.category != null && item.category!.isNotEmpty) metaParts.add(item.category!);
    if (item.region != null && item.region!.isNotEmpty) metaParts.add(item.region!);
    if (item.kind != null && item.kind!.isNotEmpty) metaParts.add(item.kind!);
    final meta = metaParts.isNotEmpty
        ? metaParts.join(' · ')
        : (localizedContentType(context, item.type ?? '') ?? item.type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ReferenceCard(
        title: item.title ?? '',
        meta: meta,
        onTap: () => _navigateToDetail(context),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    onNavigate?.call(
      toType: item.type ?? '',
      toId: item.id ?? '',
      source: 'related',
      toTitle: item.title,
      toCategory: item.category,
      toKind: item.kind,
      toSourceId: item.sourceId,
      toSourceUrl: item.sourceUrl,
    );

    ContentNavigator.toDetail(
      context,
      type: item.type ?? '',
      id: item.id?.isNotEmpty == true ? item.id : null,
      sourceId: item.sourceId,
      sourceUrl: item.sourceUrl?.isNotEmpty == true ? item.sourceUrl : null,
    );
  }
}

// ==================== 推荐卡片 ====================

class _RecommendationCard extends StatelessWidget {
  final RecommendationDto item;
  final String fromType;
  final String fromId;
  final String? fromTitle;
  final String source;
  final NavigateCallback? onNavigate;

  const _RecommendationCard({
    required this.item,
    required this.fromType,
    required this.fromId,
    this.fromTitle,
    this.source = 'recommendation',
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ContentCard(
        onTap: () => _navigateToDetail(context),
        padding: EdgeInsets.zero,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta chip
                if (item.type != null)
                  MetaChip(
                      text:
                          localizedContentType(context, item.type!) ?? item.type!),
                if (item.category != null && item.category!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  MetaChip(text: item.category!),
                ],
                const SizedBox(height: 4),
                // 标题
                Text(item.title ?? '',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                // 理由
                if (item.reason != null && item.reason!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(item.reason!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    onNavigate?.call(
      toType: item.type ?? '',
      toId: item.id ?? '',
      source: source,
      toTitle: item.title,
      toCategory: item.category,
      toKind: item.kind,
      toSourceId: item.sourceId,
      toSourceUrl: item.sourceUrl,
    );

    ContentNavigator.toDetail(
      context,
      type: item.type ?? '',
      id: item.id?.isNotEmpty == true ? item.id : null,
      sourceId: item.sourceId,
      sourceUrl: item.sourceUrl?.isNotEmpty == true ? item.sourceUrl : null,
      category: item.category,
      kind: item.kind,
    );
  }
}

// ==================== 合集卡片 ====================

class _ContextCollectionCard extends StatelessWidget {
  final ContextCollectionDto collection;
  final AppLocalizations l10n;

  const _ContextCollectionCard({required this.collection, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: ContentCard(
        onTap: () {
          if (collection.id != null) {
            ContentNavigator.toCollection(
              context,
              collectionId: collection.id,
            );
          }
        },
        padding: EdgeInsets.zero,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(collection.title ?? '',
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Text(
                  l10n.collectionItemCount(collection.items.length),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== 图边行 ====================

class _GraphEdgeRow extends StatelessWidget {
  final GraphEdgeDto edge;
  final List<GraphNodeDto> nodes;
  final String fromType;
  final String fromId;
  final NavigateCallback? onNavigate;

  const _GraphEdgeRow({
    required this.edge,
    required this.nodes,
    required this.fromType,
    required this.fromId,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 查找 from/to 节点标题
    final fromNode = _findNode(edge.fromId);
    final toNode = _findNode(edge.toId);
    final fromTitle = fromNode?.title ?? edge.fromId ?? '';
    final toTitle = toNode?.title ?? edge.toId ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ContentCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From -> To 行
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: fromNode != null ? () => _navigateToNode(context, fromNode) : null,
                    child: Text(fromTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('→',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                          )),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: toNode != null ? () => _navigateToNode(context, toNode) : null,
                    child: Text(toTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            // 标签和理由
            if (edge.label != null && edge.label!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(edge.label!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
            ],
            if (edge.reason != null && edge.reason!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(edge.reason!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }

  GraphNodeDto? _findNode(String? id) {
    if (id == null) return null;
    try {
      return nodes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  void _navigateToNode(BuildContext context, GraphNodeDto node) {
    final type = node.type ?? '';
    final id = node.id ?? '';

    onNavigate?.call(
      toType: type,
      toId: id,
      source: 'graph',
      toTitle: node.title,
      toCategory: node.category,
      toSourceUrl: node.sourceUrl,
    );

    ContentNavigator.toDetail(
      context,
      type: type,
      id: id.isNotEmpty ? id : null,
      sourceUrl: node.sourceUrl,
      category: node.category,
    );
  }
}

// ==================== 辅助组件 ====================

/// Context 区块加载占位
class _ContextLoadingPlaceholder extends StatelessWidget {
  final AppLocalizations l10n;

  const _ContextLoadingPlaceholder({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.contextLoading,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

/// Context 区块错误行
class _ContextErrorRow extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ContextErrorRow({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ContentCard(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}
