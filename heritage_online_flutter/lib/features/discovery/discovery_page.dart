import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/discovery_dtos.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/discovery_ui_state.dart';
import 'package:heritage_online_flutter/features/discovery/discovery_view_model.dart';
import 'package:heritage_online_flutter/features/discovery/explore_topic/explore_topic_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/placeholder_pages.dart';
import 'package:heritage_online_flutter/features/learning/learning_path_page.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 发现页 — 对齐 Android DiscoveryScreen
class DiscoveryPage extends ConsumerWidget {
  final ValueChanged<bool>? onDetailChanged;

  const DiscoveryPage({super.key, this.onDetailChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(discoveryViewModelProvider);

    if (state.isAnyLoading && !state.today.hasData && !state.trending.hasData && !state.weekly.hasData) {
      return Scaffold(
        appBar: _buildAppBar(context, ref, l10n),
        body: const PageBackground(child: LoadingPlaceholder()),
      );
    }

    if (state.isAllFailed) {
      return Scaffold(
        appBar: _buildAppBar(context, ref, l10n),
        body: PageBackground(
          child: ErrorRetryRow(
            message: l10n.commonError,
            onRetry: () => ref.read(discoveryViewModelProvider.notifier).refresh(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, ref, l10n),
      body: PageBackground(
        child: RefreshIndicator(
          onRefresh: () async => ref.read(discoveryViewModelProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              // 搜索框
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _buildSearchEntry(context, l10n),
              ),
              const SizedBox(height: 16),

              // 随便看看
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSerendipityButton(context, ref, state, l10n),
              ),

              // 随便看看结果卡片
              if (state.serendipityItem != null) ...[
                const SizedBox(height: 12),
                _buildSerendipityResultCard(context, state.serendipityItem!, l10n),
              ],

              const SizedBox(height: 16),

              // 今日发现
              _buildTodaySection(context, state, ref, l10n),
              // 正在被看见
              _buildTrendingSection(context, state, ref, l10n),
              // 本周非遗包
              _buildWeeklySection(context, state, ref, l10n),

              // 主题库入口
              _buildEntryCard(context,
                title: l10n.discoveryTaxonomy,
                subtitle: l10n.discoverySubtitle,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                onTap: () => _navigateTo(context, const TaxonomyPage()),
              ),
              const SizedBox(height: 12),

              // 数据故事入口
              _buildEntryCard(context,
                title: l10n.discoveryStories,
                color: Theme.of(context).colorScheme.primaryContainer,
                onTap: () => _navigateTo(context, const StoriesPage()),
              ),
              const SizedBox(height: 16),

              // 探索主题
              _buildExploreTopicsSection(context, state, ref, l10n),
              // 学习路径
              _buildLearningPathsSection(context, state, ref, l10n),
              // 精选合集
              _buildCollectionsSection(context, state, ref, l10n),
              // 地区图谱
              _buildRegionAtlasSection(context, state, ref, l10n),

              // 时间线入口
              _buildEntryCard(context,
                title: l10n.discoveryTimeline,
                subtitle: l10n.discoveryTimelineSubtitle,
                color: Theme.of(context).colorScheme.secondaryContainer,
                onTap: () => _navigateTo(context, const TimelinePage()),
              ),
              const SizedBox(height: 12),

              // 主题对比入口
              _buildEntryCard(context,
                title: l10n.compareTitle,
                icon: Icons.compare_arrows,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                onTap: () => _navigateTo(context, const ComparePlaceholderPage()),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== AppBar ====================

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.discoveryTitle),
          Text(l10n.discoverySubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.actionRefresh,
          onPressed: () => ref.read(discoveryViewModelProvider.notifier).refresh(),
        ),
      ],
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
        child: Row(children: [
          Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(l10n.discoverySearchPlaceholder,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
        ]),
      ),
    );
  }

  // ==================== 随便看看 ====================

  Widget _buildSerendipityButton(BuildContext context, WidgetRef ref, DiscoveryUiState state, AppLocalizations l10n) {
    return FilledButton.tonal(
      onPressed: state.serendipityLoading
          ? null
          : () => ref.read(discoveryViewModelProvider.notifier).serendipity(),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (state.serendipityLoading) ...[
          const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: 8),
        ],
        Text(state.serendipityLoading ? l10n.discoverySerendipityLoading : l10n.discoverySerendipity),
      ]),
    );
  }

  Widget _buildSerendipityResultCard(BuildContext context, DiscoveryItemDto item, AppLocalizations l10n) {
    final title = item.title ?? '';
    if (title.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (item.summary != null && item.summary!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(item.summary!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          if (item.category != null || item.region != null) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: [
              if (item.category != null && item.category!.isNotEmpty) MetaChip(text: item.category!),
              if (item.region != null && item.region!.isNotEmpty) MetaChip(text: item.region!),
            ]),
          ],
          if (item.id != null && item.id!.isNotEmpty && item.type != null && item.type!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: () => _navigateTo(context, DeepDivePage(
                  seedType: item.type!,
                  seedId: item.id!,
                  onBack: () => Navigator.of(context).pop(),
                )),
                icon: const Icon(Icons.travel_explore, size: 18),
                label: Text(l10n.discoveryDeepDive),
              ),
            ),
          ],
        ]),
      ),
    );
  }

  // ==================== 今日发现 ====================

  Widget _buildTodaySection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.today.isLoading && !state.today.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryToday);
    }
    if (state.today.hasError) {
      return _buildSectionError(context, l10n.discoveryToday, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadToday());
    }
    final data = state.today.data;
    if (data == null || !data.hasAnyContent) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SectionHeader(title: l10n.discoveryToday),
      ),
      if (data.featuredDirectoryItem != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildDiscoveryItemRow(context, data.featuredDirectoryItem!),
        ),
      if (data.featuredInheritor != null) ...[
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildDiscoveryItemRow(context, data.featuredInheritor!),
        ),
      ],
      if (data.articles.isNotEmpty) ...[
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.articles.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _buildDiscoveryItemCard(context, data.articles[i]),
          ),
        ),
      ],
    ]);
  }

  // ==================== 正在被看见 ====================

  Widget _buildTrendingSection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.trending.isLoading && !state.trending.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryTrending);
    }
    if (state.trending.hasError) {
      return _buildSectionError(context, l10n.discoveryTrending, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadTrending());
    }
    final data = state.trending.data;
    if (data == null || data.items.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SectionHeader(title: l10n.discoveryTrending),
      ),
      SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: data.items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, i) => _buildDiscoveryItemCard(context, data.items[i]),
        ),
      ),
    ]);
  }

  // ==================== 本周非遗包 ====================

  Widget _buildWeeklySection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.weekly.isLoading && !state.weekly.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryWeekly);
    }
    if (state.weekly.hasError) {
      return _buildSectionError(context, l10n.discoveryWeekly, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadWeekly());
    }
    final data = state.weekly.data;
    if (data == null || data.sections.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SectionHeader(title: l10n.discoveryWeekly),
      ),
      ...data.sections.take(2).map((section) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (section.title != null && section.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(section.title!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ),
          if (section.subtitle != null && section.subtitle!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(section.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ),
          if (section.items.isNotEmpty)
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: section.items.length.clamp(0, 5),
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _buildDiscoveryItemCard(context, section.items[i]),
              ),
            ),
        ]);
      }),
    ]);
  }

  // ==================== 探索主题 ====================

  Widget _buildExploreTopicsSection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.topics.isLoading && !state.topics.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryExploreTopics);
    }
    if (state.topics.hasError) {
      return _buildSectionError(context, l10n.discoveryExploreTopics, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadTopics());
    }
    final topics = state.topics.data;
    if (topics == null || topics.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SectionHeader(title: l10n.discoveryExploreTopics),
      ),
      SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: topics.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final t = topics[i];
            return ActionChip(
              label: Text(t.title ?? ''),
              onPressed: () {
                if (t.type != null && t.key != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ExploreTopicDetailPage(
                      type: t.type!,
                      topicKey: t.key!,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ));
                }
              },
            );
          },
        ),
      ),
    ]);
  }

  // ==================== 学习路径 ====================

  Widget _buildLearningPathsSection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.learningPaths.isLoading && !state.learningPaths.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryLearningPaths);
    }
    if (state.learningPaths.hasError) {
      return _buildSectionError(context, l10n.discoveryLearningPaths, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadLearningPaths());
    }
    final paths = state.learningPaths.data;
    if (paths == null || paths.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SectionHeader(title: l10n.discoveryLearningPaths),
      ),
      SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: paths.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final p = paths[i];
            return SizedBox(
              width: 200,
              child: ContentCard(
                onTap: () {
                  if (p.id != null && p.id!.isNotEmpty) {
                    _navigateTo(context, LearningPathDetailPage(pathId: p.id!));
                  }
                },
                padding: EdgeInsets.zero,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.title ?? '',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (p.subtitle != null && p.subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(p.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                      const SizedBox(height: 8),
                      Expanded(
                        child: p.topics.isNotEmpty
                            ? Wrap(
                                spacing: 4,
                                runSpacing: 2,
                                children: p.topics.take(3).map((t) => MetaChip(text: t.title ?? '')).toList(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // ==================== 精选合集 ====================

  Widget _buildCollectionsSection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.collections.isLoading && !state.collections.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryFeaturedCollections);
    }
    if (state.collections.hasError) {
      return _buildSectionError(context, l10n.discoveryFeaturedCollections, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadFeaturedCollections());
    }
    final collections = state.collections.data;
    if (collections == null || collections.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SectionHeader(title: l10n.discoveryFeaturedCollections),
      ),
      SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: collections.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final c = collections[i];
            return SizedBox(
              width: 180,
              child: ContentCard(
                onTap: () {
                  if (c.id != null && c.id!.isNotEmpty) {
                    _navigateTo(context, CollectionDetailPage(
                      collectionId: c.id!,
                      onBack: () => Navigator.of(context).pop(),
                    ));
                  }
                },
                padding: EdgeInsets.zero,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.title ?? '',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      if (c.subtitle != null && c.subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(c.subtitle!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                      if (c.itemCount > 0)
                        Text('${c.itemCount}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // ==================== 地区图谱 ====================

  Widget _buildRegionAtlasSection(BuildContext context, DiscoveryUiState state, WidgetRef ref, AppLocalizations l10n) {
    if (state.regionAtlas.isLoading && !state.regionAtlas.hasData) {
      return _buildSectionPlaceholder(context, l10n.discoveryRegionAtlas);
    }
    if (state.regionAtlas.hasError) {
      return _buildSectionError(context, l10n.discoveryRegionAtlas, l10n,
          () => ref.read(discoveryViewModelProvider.notifier).loadRegionAtlas());
    }
    final atlas = state.regionAtlas.data;
    if (atlas == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ContentCard(
        onTap: () => _navigateTo(context, const RegionAtlasPage()),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(Icons.map, color: Theme.of(context).colorScheme.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.discoveryRegionAtlas, style: Theme.of(context).textTheme.titleMedium),
              if (atlas.totals != null)
                Text('${atlas.totals!.regionCount} ${l10n.discoveryRegionAtlas}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
            ]),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ]),
      ),
    );
  }

  // ==================== 通用入口卡片 ====================

  Widget _buildEntryCard(BuildContext context,
      {required String title, String? subtitle, IconData? icon, required Color color, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ContentCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          if (icon != null) ...[
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        )),
              ],
            ]),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ]),
      ),
    );
  }

  // ==================== 共享 helper ====================

  Widget _buildDiscoveryItemRow(BuildContext context, DiscoveryItemDto item) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);
    return ListCard(
      onTap: () => _navigateToItemDetail(context, item),
      image: SizedBox(
        width: 48,
        height: 48,
        child: imageUrl != null
            ? ListImage(imageUrl: imageUrl, fallbackText: (item.title ?? '').isNotEmpty ? item.title!.substring(0, 1) : '')
            : ImagePlaceholder(text: (item.title ?? '').isNotEmpty ? item.title!.substring(0, 1) : ''),
      ),
      text: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title ?? '', style: Theme.of(context).textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (item.summary != null && item.summary!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(item.summary!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscoveryItemCard(BuildContext context, DiscoveryItemDto item) {
    return DiscoveryItemCard.fromDto(item, onTap: () => _navigateToItemDetail(context, item));
  }

  void _navigateToItemDetail(BuildContext context, DiscoveryItemDto item) {
    final type = item.type ?? '';
    final id = item.id ?? '';
    final sourceId = item.sourceId;
    if (id.isEmpty && sourceId == null) return;

    switch (type) {
      case 'article':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ArticleDetailPage(
            articleId: id.isNotEmpty ? id : null,
            sourceId: sourceId,
            sourceUrl: item.sourceUrl,
            onBack: () => Navigator.of(context).pop(),
          ),
        ));
        break;
      case 'directoryItem':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DirectoryDetailPage(
            itemId: id.isNotEmpty ? id : null,
            sourceId: sourceId,
            onBack: () => Navigator.of(context).pop(),
          ),
        ));
        break;
      case 'inheritor':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => InheritorDetailPage(
            inheritorId: id.isNotEmpty ? id : null,
            sourceId: sourceId,
            onBack: () => Navigator.of(context).pop(),
          ),
        ));
        break;
    }
  }

  Widget _buildSectionPlaceholder(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(title: title),
          const SizedBox(height: 12),
          const LoadingPlaceholder(),
        ]),
      ),
    );
  }

  Widget _buildSectionError(BuildContext context, String title, AppLocalizations l10n, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(title: title),
          const SizedBox(height: 8),
          ErrorRetryRow(message: l10n.commonError, onRetry: onRetry),
        ]),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
