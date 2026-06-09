import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/network/dto/context_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/digest_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/network/dto/recommendation_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/explore_topic/explore_topic_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

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

/// 详情页底部探索区
/// 按顺序渲染：Digest → Blended Recommendations → Context (Related, Recommendations, Semantic, Collections, Topics, Graph)
class DetailExploreSection extends StatelessWidget {
  final DetailExploreState state;
  final String contentType;
  final String contentId;
  final VoidCallback? onDigestRetry;
  final VoidCallback? onContextRetry;
  final VoidCallback? onBlendedRetry;

  const DetailExploreSection({
    super.key,
    required this.state,
    required this.contentType,
    required this.contentId,
    this.onDigestRetry,
    this.onContextRetry,
    this.onBlendedRetry,
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
        const SizedBox(height: 12),

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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LoadingPlaceholder(),
      );
    }

    if (state.digestError != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ErrorRetryRow(
          message: l10n.commonError,
          onRetry: onDigestRetry ?? () {},
        ),
      );
    }

    final digest = state.digest;
    if (digest == null) return const SizedBox.shrink();

    return _DigestCard(digest: digest, l10n: l10n);
  }

  Widget _buildBlended(BuildContext context, AppLocalizations l10n) {
    if (state.blendedLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LoadingPlaceholder(),
      );
    }

    if (state.blendedError != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ErrorRetryRow(
          message: l10n.commonError,
          onRetry: onBlendedRetry ?? () {},
        ),
      );
    }

    if (!state.hasValidBlendedItems) return const SizedBox.shrink();

    return _BlendedRecommendationsSection(
      items: state.blended!.items
          .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
          .toList(),
      l10n: l10n,
    );
  }

  Widget _buildContext(BuildContext context, AppLocalizations l10n) {
    if (state.contextLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LoadingPlaceholder(),
      );
    }

    if (state.contextError != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ErrorRetryRow(
          message: l10n.commonError,
          onRetry: onContextRetry ?? () {},
        ),
      );
    }

    final ctx = state.context;
    if (ctx == null) return const SizedBox.shrink();

    return _DetailContextSection(
      context: ctx,
      contentType: contentType,
      contentId: contentId,
      l10n: l10n,
    );
  }
}

/// 速览卡片
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(l10n.digestTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          // quickRead
          if (digest.quickRead != null && digest.quickRead!.isNotEmpty) ...[
            Text(digest.quickRead!,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
          ],

          // 阅读时间
          if (digest.readingTimeMinutes > 0)
            Text(l10n.digestReadingTime(digest.readingTimeMinutes),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),

          // 要点
          if (showHighlights) ...[
            const SizedBox(height: 12),
            Text(l10n.digestHighlights,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            ...digest.highlights
                .take(_expanded ? digest.highlights.length : 3)
                .map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Expanded(
                              child: Text(h,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                        ],
                      ),
                    )),
            if (digest.highlights.length > 3)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? '收起' : '展开',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
          ],

          // 关键信息
          if (showKeyFacts) ...[
            const SizedBox(height: 12),
            Text(l10n.digestKeyFacts,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: digest.keyFacts
                  .map((f) => MetaChip(text: '${f.label}: ${f.value}'))
                  .toList(),
            ),
          ],

          // 关键词
          if (showKeywords) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children:
                  digest.keywords.map((k) => MetaChip(text: k)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// 综合推荐区块
class _BlendedRecommendationsSection extends StatelessWidget {
  final List<BlendedRecommendationItemDto> items;
  final AppLocalizations l10n;

  const _BlendedRecommendationsSection({
    required this.items,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(l10n.blendedRecommendationsTitle,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _BlendedRecommendationCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

/// 综合推荐卡片
class _BlendedRecommendationCard extends StatelessWidget {
  final BlendedRecommendationItemDto item;

  const _BlendedRecommendationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ContentCard(
        onTap: () => _navigateToDetail(context),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类型和分类
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: [
                if (item.type.isNotEmpty)
                  MetaChip(
                      text:
                          localizedContentType(context, item.type) ?? item.type),
                if (item.category != null && item.category!.isNotEmpty)
                  MetaChip(text: item.category!),
              ],
            ),
            const SizedBox(height: 6),

            // 标题
            Text(item.title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),

            // 副标题
            if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(item.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],

            // 地区
            if (item.region != null && item.region!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(item.region!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ],

            const Spacer(),

            // 推荐理由
            if (item.reasons.isNotEmpty)
              Text(item.reasons.first,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    final type = item.type;
    final id = item.id;

    if (type == 'article') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ArticleDetailPage(
            articleId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl.isNotEmpty ? item.sourceUrl : null,
            category: item.category?.isNotEmpty == true
                ? ArticleCategory.fromWireName(item.category!)
                : ArticleCategory.news,
            onBack: () => Navigator.of(context).pop()),
      ));
    } else if (type == 'directoryItem') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DirectoryDetailPage(
            itemId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            kind: item.kind?.isNotEmpty == true
                ? DirectoryItemKind.fromWireName(item.kind!)
                : DirectoryItemKind.nationalProject,
            onBack: () => Navigator.of(context).pop()),
      ));
    } else if (type == 'inheritor') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => InheritorDetailPage(
            inheritorId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop()),
      ));
    }
  }
}

/// Context 区块（Related, Recommendations, Semantic, Collections, Topics, Graph）
class _DetailContextSection extends StatelessWidget {
  final DetailContextDto context;
  final String contentType;
  final String contentId;
  final AppLocalizations l10n;

  const _DetailContextSection({
    required this.context,
    required this.contentType,
    required this.contentId,
    required this.l10n,
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
          const SizedBox(height: 16),
          Text(l10n.contextRelatedTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...ctx.related.map((item) => _RelatedItemRow(
                item: item,
                fromType: contentType,
                fromId: contentId,
              )),
        ],
        if (hasRecommendations) ...[
          const SizedBox(height: 16),
          Text(l10n.contextRecommendationsTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ctx.recommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RecommendationCard(
                item: ctx.recommendations[index],
                fromType: contentType,
                fromId: contentId,
              ),
            ),
          ),
        ],
        if (hasSemantic) ...[
          const SizedBox(height: 16),
          Text(l10n.contextSemanticTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ctx.semanticRecommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _RecommendationCard(
                item: ctx.semanticRecommendations[index],
                fromType: contentType,
                fromId: contentId,
              ),
            ),
          ),
        ],
        if (hasCollections) ...[
          const SizedBox(height: 16),
          Text(l10n.contextCollectionsTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...ctx.collections
              .map((c) => _ContextCollectionCard(collection: c)),
        ],
        if (hasTopics) ...[
          const SizedBox(height: 16),
          Text(l10n.contextTopicsTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ctx.exploreTopics
                .map((topic) => ActionChip(
                      label: Text(topic.title ?? topic.key ?? ''),
                      onPressed: () {
                        if (topic.type != null && topic.key != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ExploreTopicDetailPage(
                              type: topic.type!,
                              topicKey: topic.key!,
                              onBack: () => Navigator.of(context).pop(),
                            ),
                          ));
                        }
                      },
                    ))
                .toList(),
          ),
        ],
        if (hasGraph) ...[
          const SizedBox(height: 16),
          Text(l10n.contextGraphTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...ctx.graph!.edges.map((edge) => _GraphEdgeRow(edge: edge)),
        ],
      ],
    );
  }
}

/// 相关内容行
class _RelatedItemRow extends StatelessWidget {
  final RelatedSummaryDto item;
  final String fromType;
  final String fromId;

  const _RelatedItemRow({
    required this.item,
    required this.fromType,
    required this.fromId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReferenceCard(
        title: item.title ?? '',
        meta: localizedContentType(context, item.type ?? '') ?? item.type,
        onTap: () => _navigateToDetail(context),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    final type = item.type ?? '';
    final id = item.id ?? '';

    if (type == 'article') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ArticleDetailPage(
            articleId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl?.isNotEmpty == true ? item.sourceUrl : null,
            onBack: () => Navigator.of(context).pop()),
      ));
    } else if (type == 'directoryItem') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DirectoryDetailPage(
            itemId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop()),
      ));
    } else if (type == 'inheritor') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => InheritorDetailPage(
            inheritorId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop()),
      ));
    }
  }
}

/// 推荐卡片（横向滚动）
class _RecommendationCard extends StatelessWidget {
  final RecommendationDto item;
  final String fromType;
  final String fromId;

  const _RecommendationCard({
    required this.item,
    required this.fromType,
    required this.fromId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ContentCard(
        onTap: () => _navigateToDetail(context),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.type != null)
              MetaChip(
                  text: localizedContentType(context, item.type!) ??
                      item.type!),
            const SizedBox(height: 4),
            Text(item.title ?? '',
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            if (item.reason != null && item.reason!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(item.reason!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    final type = item.type ?? '';
    final id = item.id ?? '';

    if (type == 'article') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ArticleDetailPage(
            articleId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl?.isNotEmpty == true ? item.sourceUrl : null,
            category: item.category?.isNotEmpty == true
                ? ArticleCategory.fromWireName(item.category!)
                : ArticleCategory.news,
            onBack: () => Navigator.of(context).pop()),
      ));
    } else if (type == 'directoryItem') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DirectoryDetailPage(
            itemId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            kind: item.kind?.isNotEmpty == true
                ? DirectoryItemKind.fromWireName(item.kind!)
                : DirectoryItemKind.nationalProject,
            onBack: () => Navigator.of(context).pop()),
      ));
    } else if (type == 'inheritor') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => InheritorDetailPage(
            inheritorId: id.isNotEmpty ? id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop()),
      ));
    }
  }
}

/// Context 中的合集卡片
class _ContextCollectionCard extends StatelessWidget {
  final ContextCollectionDto collection;

  const _ContextCollectionCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ContentCard(
        onTap: () {
          if (collection.id != null) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CollectionDetailPage(
                collectionId: collection.id,
                onBack: () => Navigator.of(context).pop(),
              ),
            ));
          }
        },
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.collections_bookmark,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(collection.title ?? '',
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// 图边行
class _GraphEdgeRow extends StatelessWidget {
  final GraphEdgeDto edge;

  const _GraphEdgeRow({required this.edge});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(edge.fromId ?? '',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('→',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
          ),
          Expanded(
            child: Text(edge.label ?? edge.toId ?? '',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
