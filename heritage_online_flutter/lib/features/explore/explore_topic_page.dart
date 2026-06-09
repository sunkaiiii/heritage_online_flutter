import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/explore/explore_topic_ui_state.dart';
import 'package:heritage_online_flutter/features/explore/explore_topic_view_model.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 探索主题详情页
class ExploreTopicDetailPage extends ConsumerWidget {
  final String type;
  final String topicKey;

  const ExploreTopicDetailPage({
    super.key,
    required this.type,
    required this.topicKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = ExploreTopicParams(type: type, key: topicKey);
    final state = ref.watch(exploreTopicViewModelProvider(params));

    return Scaffold(
      appBar: AppBar(title: Text(state.title ?? l10n.commonLoading)),
      body: _buildBody(context, ref, state, params, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ExploreTopicUiState state,
    ExploreTopicParams params,
    AppLocalizations l10n,
  ) {
    if (state.isLoading) {
      return const LoadingPlaceholder();
    }

    if (state.error != null && state.title == null) {
      return ErrorRetryRow(
        message: state.error!,
        onRetry: () =>
            ref.read(exploreTopicViewModelProvider(params).notifier).retry(),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        if (state.title != null) ...[
          Text(
            state.title!,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
        ],
        if (state.subtitle != null) ...[
          Text(
            state.subtitle!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
        ],

        // Stats chips
        if (state.total > 0) _buildStatsRow(context, state),
        const SizedBox(height: 16),

        // Sections
        ...state.sections.map((section) => _buildSection(context, section, l10n)),

        // Timeline
        if (state.timeline.isNotEmpty) ...[
          const SizedBox(height: 16),
          SectionHeader(title: l10n.exploreTopicTimeline),
          const SizedBox(height: 8),
          ...state.timeline.map((item) => _buildTimelineItem(context, item)),
        ],

        // Related topics
        if (state.relatedTopics.isNotEmpty) ...[
          const SizedBox(height: 16),
          SectionHeader(title: l10n.exploreTopicRelated),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: state.relatedTopics.map((t) {
              return ActionChip(
                label: Text(t.title ?? ''),
                onPressed: () {
                  if (t.type != null && t.key != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExploreTopicDetailPage(
                          type: t.type!,
                          topicKey: t.key!,
                        ),
                      ),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

  // ==================== Stats ====================

  Widget _buildStatsRow(BuildContext context, ExploreTopicUiState state) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        MetaChip(text: '${state.total} items'),
        if (state.articleCount > 0) MetaChip(text: '${state.articleCount} articles'),
        if (state.directoryItemCount > 0)
          MetaChip(text: '${state.directoryItemCount} directory'),
        if (state.inheritorCount > 0)
          MetaChip(text: '${state.inheritorCount} inheritors'),
      ],
    );
  }

  // ==================== Section ====================

  Widget _buildSection(
    BuildContext context,
    TopicSection section,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) SectionHeader(title: section.title!),
          if (section.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              section.subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 8),
          ...section.items.map((item) => _buildSectionItem(context, item, l10n)),
        ],
      ),
    );
  }

  Widget _buildSectionItem(
    BuildContext context,
    TopicSectionItem item,
    AppLocalizations l10n,
  ) {
    final typeLabel =
        localizedContentType(context, item.type) ?? item.type ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListCard(
        onTap: () => _navigateToItem(context, item),
        image: SizedBox(
          width: 60,
          height: 60,
          child: item.imageUrl != null && item.imageUrl!.isNotEmpty
              ? ListImage(
                  imageUrl: item.imageUrl!,
                  fallbackText:
                      item.title?.isNotEmpty == true ? item.title!.substring(0, 1) : '',
                )
              : ImagePlaceholder(
                  text: item.title?.isNotEmpty == true
                      ? item.title!.substring(0, 1)
                      : '',
                ),
        ),
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MetaChip(text: typeLabel),
            const SizedBox(height: 4),
            Text(
              item.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.summary != null && item.summary!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                item.summary!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToItem(BuildContext context, TopicSectionItem item) {
    if (item.isArticle) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleDetailPage(
            articleId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl?.isNotEmpty == true ? item.sourceUrl : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (item.isDirectoryItem) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DirectoryDetailPage(
            itemId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (item.isInheritor) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InheritorDetailPage(
            inheritorId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId: item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  // ==================== Timeline ====================

  Widget _buildTimelineItem(BuildContext context, TopicTimelineItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ContentCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (item.year != null) ...[
              MetaChip(text: item.year!),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item.title ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
