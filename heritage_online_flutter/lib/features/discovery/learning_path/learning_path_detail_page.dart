import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/explore_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/learning_path_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/explore_topic/explore_topic_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 学习路径详情页
class LearningPathDetailPage extends ConsumerStatefulWidget {
  final String pathId;
  final VoidCallback onBack;

  const LearningPathDetailPage({
    super.key,
    required this.pathId,
    required this.onBack,
  });

  @override
  ConsumerState<LearningPathDetailPage> createState() => _LearningPathDetailPageState();
}

class _LearningPathDetailPageState extends ConsumerState<LearningPathDetailPage> {
  LearningPathDetailDto? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(heritageRepositoryProvider);
      final result = await repo.learningPathDetail(widget.pathId, limit: 6);
      if (mounted) {
        setState(() {
          _data = result as LearningPathDetailDto?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(_data?.title ?? l10n.discoveryLearningPaths),
      ),
      body: _buildBody(context, l10n),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return const PageBackground(child: LoadingPlaceholder());
    }

    if (_error != null) {
      return PageBackground(
        child: ErrorRetryRow(
          message: _error!,
          onRetry: _loadData,
        ),
      );
    }

    final data = _data;
    if (data == null) {
      return PageBackground(child: EmptyState(message: l10n.commonEmpty));
    }

    return PageBackground(
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 标题和描述
            Text(
              data.title ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (data.subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                data.subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (data.description != null) ...[
              const SizedBox(height: 12),
              Text(
                data.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (data.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: data.tags.map((tag) => MetaChip(text: tag)).toList(),
              ),
            ],
            const SizedBox(height: 24),

            // Steps
            if (data.steps.isNotEmpty) ...[
              Text(
                l10n.learningPathSteps,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...data.steps.asMap().entries.map(
                    (entry) => _buildStep(context, entry.key + 1, entry.value),
                  ),
            ],

            // Featured Items
            if (data.featuredItems.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.learningPathFeatured,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...data.featuredItems.map((item) => _buildItem(context, item)),
            ],

            // Related Topics
            if (data.relatedTopics.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.learningRelatedTopics,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...data.relatedTopics.map((topic) => _buildRelatedTopic(context, topic)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int index, LearningPathStepDto step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    '$index',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (step.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          step.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (step.items.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...step.items.map((item) => _buildItem(context, item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, ExploreTopicItemDto item) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListCard(
        onTap: () => _navigateToDetail(context, item),
        image: SizedBox(
          width: 60,
          height: 60,
          child: imageUrl != null
              ? ListImage(imageUrl: imageUrl, fallbackText: item.title ?? '')
              : ImagePlaceholder(
                  text: item.title?.isNotEmpty == true
                      ? item.title!.substring(0, 1)
                      : '',
                ),
        ),
        text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.type != null)
              MetaChip(text: localizedContentType(context, item.type!) ?? item.type!),
            const SizedBox(height: 4),
            Text(
              item.title ?? '',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedTopic(BuildContext context, ExploreTopicLinkDto topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReferenceCard(
        title: topic.title ?? '',
        meta: topic.type,
        onTap: () {
          if (topic.type != null && topic.key != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExploreTopicDetailPage(
                  type: topic.type!,
                  topicKey: topic.key!,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ExploreTopicItemDto item) {
    final type = item.type ?? '';

    if (type == 'article') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ArticleDetailPage(
            articleId: item.id?.isNotEmpty == true ? item.id : null,
            sourceUrl: item.sourceUrl,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (type == 'directoryItem') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DirectoryDetailPage(
            itemId: item.id?.isNotEmpty == true ? item.id : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } else if (type == 'inheritor') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InheritorDetailPage(
            inheritorId: item.id?.isNotEmpty == true ? item.id : null,
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }
}
