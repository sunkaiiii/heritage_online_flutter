import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/features/discovery/collection/featured_collections_page.dart';
import 'package:heritage_online_flutter/features/discovery/compare/compare_page.dart';
import 'package:heritage_online_flutter/features/discovery/region_atlas/region_atlas_page.dart';
import 'package:heritage_online_flutter/features/discovery/stories/stories_page.dart';
import 'package:heritage_online_flutter/features/discovery/taxonomy/taxonomy_page.dart';
import 'package:heritage_online_flutter/features/discovery/timeline/timeline_page.dart';
import 'package:heritage_online_flutter/features/explore/explore_topic_page.dart';
import 'package:heritage_online_flutter/features/learning/learning_path_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 搜索页占位
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoverySearchPlaceholder)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 探索主题列表页
class ExploreTopicsPage extends ConsumerWidget {
  const ExploreTopicsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryExploreTopics)),
      body: _buildBody(context, ref, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final repository = ref.watch(heritageRepositoryProvider);

    return FutureBuilder<List<dynamic>>(
      future: repository.exploreTopics(limit: 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPlaceholder();
        }

        if (snapshot.hasError) {
          return ErrorRetryRow(
            message: l10n.commonError,
            onRetry: () => ref.invalidate(heritageRepositoryProvider),
          );
        }

        final topics = snapshot.data ?? [];
        if (topics.isEmpty) {
          return EmptyState(message: l10n.commonEmpty);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index] as Map<String, dynamic>;
            final type = topic['type']?.toString() ?? '';
            final key = topic['key']?.toString() ?? '';
            final title = topic['title']?.toString() ?? '';
            final subtitle = topic['subtitle']?.toString();

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ContentCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExploreTopicDetailPage(
                        type: type,
                        topicKey: key,
                      ),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (subtitle != null && subtitle.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
              ),
            );
          },
        );
      },
    );
  }
}

/// 学习路径列表页
class LearningPathsPage extends ConsumerWidget {
  const LearningPathsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryLearningPaths)),
      body: _buildBody(context, ref, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final repository = ref.watch(heritageRepositoryProvider);

    return FutureBuilder<List<dynamic>>(
      future: repository.learningPaths(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPlaceholder();
        }

        if (snapshot.hasError) {
          return ErrorRetryRow(
            message: l10n.commonError,
            onRetry: () => ref.invalidate(heritageRepositoryProvider),
          );
        }

        final paths = snapshot.data ?? [];
        if (paths.isEmpty) {
          return EmptyState(message: l10n.commonEmpty);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: paths.length,
          itemBuilder: (context, index) {
            final path = paths[index] as Map<String, dynamic>;
            final id = path['id']?.toString() ?? '';
            final title = path['title']?.toString() ?? '';
            final subtitle = path['subtitle']?.toString();
            final tags = (path['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ContentCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LearningPathDetailPage(pathId: id),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: tags
                            .map((tag) => MetaChip(text: tag))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// 精选合集页 — 使用新的 FeaturedCollectionsPage 实现
class FeaturedCollectionsPage extends StatelessWidget {
  const FeaturedCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FeaturedCollectionsListPage(
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

/// 地区图谱页 — 使用新的 RegionAtlasListPage 实现
class RegionAtlasPage extends StatelessWidget {
  const RegionAtlasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RegionAtlasListPage(
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

/// 时间线页 — 使用新的 TimelineDetailPage 实现
class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TimelineDetailPage(
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

/// 主题库页 — 使用新的 TaxonomyIndexPage 实现
class TaxonomyPage extends StatelessWidget {
  const TaxonomyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TaxonomyIndexPage(
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

/// 数据故事页 — 使用新的 StoriesIndexPage 实现
class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoriesIndexPage(
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

/// 主题对比页 — 使用新的 ComparePage 实现
class ComparePlaceholderPage extends StatelessWidget {
  const ComparePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComparePage(
      onBack: () => Navigator.of(context).pop(),
    );
  }
}

/// 深度探索页 — 对齐 Android DeepDiveScreen
class DeepDivePage extends StatelessWidget {
  final String seedType;
  final String seedId;
  final VoidCallback onBack;

  const DeepDivePage({
    super.key,
    required this.seedType,
    required this.seedId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.discoveryDeepDive),
      ),
      body: PageBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.travel_explore,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                l10n.discoveryDeepDive,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$seedType / $seedId',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
