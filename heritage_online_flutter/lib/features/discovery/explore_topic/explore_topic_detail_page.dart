import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/explore_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 探索主题详情页
class ExploreTopicDetailPage extends ConsumerStatefulWidget {
  final String type;
  final String topicKey;
  final VoidCallback onBack;

  const ExploreTopicDetailPage({
    super.key,
    required this.type,
    required this.topicKey,
    required this.onBack,
  });

  @override
  ConsumerState<ExploreTopicDetailPage> createState() => _ExploreTopicDetailPageState();
}

class _ExploreTopicDetailPageState extends ConsumerState<ExploreTopicDetailPage> {
  ExploreTopicV2Dto? _data;
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
      final result = await repo.exploreTopic(widget.type, widget.topicKey, limit: 6);
      if (mounted) {
        setState(() {
          _data = result as ExploreTopicV2Dto?;
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
        title: Text(_data?.topic?.title ?? l10n.discoveryExploreTopics),
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
            if (data.topic != null) ...[
              Text(
                data.topic!.title ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (data.topic!.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  data.topic!.subtitle!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
              const SizedBox(height: 16),
            ],

            // Stats
            if (data.stats.isNotEmpty) ...[
              _buildStats(context, data.stats),
              const SizedBox(height: 24),
            ],

            // Sections
            ...data.sections.map((section) => _buildSection(context, section, l10n)),

            // Related Topics
            if (data.relatedTopics.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                '相关主题',
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

  Widget _buildStats(BuildContext context, List<ExploreTopicStatDto> stats) {
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: stats.map((stat) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${stat.value}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                stat.name ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ExploreTopicSectionDto section,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.title != null) ...[
          const SizedBox(height: 16),
          Text(
            section.title!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
        ],
        ...section.items.map((item) => _buildItem(context, item)),
      ],
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
            if (item.summary != null) ...[
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
