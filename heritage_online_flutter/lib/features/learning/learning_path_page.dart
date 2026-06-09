import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/features/learning/learning_path_ui_state.dart';
import 'package:heritage_online_flutter/features/learning/learning_path_view_model.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 学习路径详情页
class LearningPathDetailPage extends ConsumerWidget {
  final String pathId;

  const LearningPathDetailPage({
    super.key,
    required this.pathId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(learningPathViewModelProvider(pathId));

    return Scaffold(
      appBar: AppBar(title: Text(state.title ?? l10n.commonLoading)),
      body: _buildBody(context, ref, state, pathId, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    LearningPathUiState state,
    String pathId,
    AppLocalizations l10n,
  ) {
    if (state.isLoading) {
      return const LoadingPlaceholder();
    }

    if (state.error != null && state.title == null) {
      return ErrorRetryRow(
        message: state.error!,
        onRetry: () =>
            ref.read(learningPathViewModelProvider(pathId).notifier).retry(),
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
          const SizedBox(height: 12),
        ],

        // Tags
        if (state.tags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: state.tags
                .map((tag) => MetaChip(text: tag))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],

        // Stat chips
        if (state.estimatedItemCount > 0 || state.stepCount > 0) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (state.stepCount > 0)
                MetaChip(text: '${state.stepCount} steps'),
              if (state.estimatedItemCount > 0)
                MetaChip(text: '${state.estimatedItemCount} items'),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Featured items
        if (state.featuredItems.isNotEmpty) ...[
          SectionHeader(title: l10n.learningFeaturedItems),
          const SizedBox(height: 8),
          ...state.featuredItems
              .map((item) => _buildFeaturedItem(context, item, l10n)),
          const SizedBox(height: 16),
        ],

        // Steps (stepper style)
        if (state.steps.isNotEmpty) ...[
          SectionHeader(title: l10n.learningPathSteps),
          const SizedBox(height: 8),
          ...state.steps.map((step) => _buildStep(context, step, l10n)),
          const SizedBox(height: 16),
        ],

        // Related topics
        if (state.relatedTopics.isNotEmpty) ...[
          SectionHeader(title: l10n.learningRelatedTopics),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: state.relatedTopics.map((t) {
              return ActionChip(
                label: Text(t.title ?? ''),
                onPressed: () {
                  // related topic 点击暂无跳转目标
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

  // ==================== Featured Item ====================

  Widget _buildFeaturedItem(
    BuildContext context,
    LearningPathFeaturedItem item,
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
                  fallbackText: item.title?.isNotEmpty == true
                      ? item.title!.substring(0, 1)
                      : '',
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

  // ==================== Step ====================

  Widget _buildStep(
    BuildContext context,
    LearningPathStep step,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧序号节点
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step.index}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
              // 连接线
              Container(
                width: 2,
                height: 24,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ],
          ),
          const SizedBox(width: 16),
          // 右侧内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (step.title != null)
                  Text(
                    step.title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                if (step.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    step.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
                if (step.items.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...step.items.map(
                      (item) => _buildFeaturedItem(context, item, l10n)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Navigation ====================

  void _navigateToItem(BuildContext context, LearningPathFeaturedItem item) {
    if (item.isArticle) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleDetailPage(
            articleId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId:
                item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            sourceUrl: item.sourceUrl?.isNotEmpty == true
                ? item.sourceUrl
                : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (item.isDirectoryItem) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DirectoryDetailPage(
            itemId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId:
                item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (item.isInheritor) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InheritorDetailPage(
            inheritorId: item.id?.isNotEmpty == true ? item.id : null,
            sourceId:
                item.sourceId?.isNotEmpty == true ? item.sourceId : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }
}
