import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/taxonomy_dtos.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/utils/content_navigator.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 主题库索引页
class TaxonomyIndexPage extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const TaxonomyIndexPage({super.key, required this.onBack});

  @override
  ConsumerState<TaxonomyIndexPage> createState() => _TaxonomyIndexPageState();
}

class _TaxonomyIndexPageState extends ConsumerState<TaxonomyIndexPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.discoveryTaxonomy),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.taxonomyTabCategories),
            Tab(text: l10n.taxonomyTabRegions),
            Tab(text: l10n.taxonomyTabKinds),
          ],
        ),
      ),
      body: PageBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            _CategoriesTab(onBack: widget.onBack),
            _RegionsTab(onBack: widget.onBack),
            _KindsTab(onBack: widget.onBack),
          ],
        ),
      ),
    );
  }
}

/// 分类标签页
class _CategoriesTab extends ConsumerWidget {
  final VoidCallback onBack;

  const _CategoriesTab({required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.watch(heritageRepositoryProvider);

    return FutureBuilder<TaxonomyIndexDto<TaxonomyTopicDto>>(
      future: repo.taxonomyCategories(),
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
        final items = snapshot.data?.items ?? [];
        if (items.isEmpty) return EmptyState(message: l10n.commonEmpty);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              _TaxonomyTopicCard(topic: items[index], onBack: onBack),
        );
      },
    );
  }
}

/// 地区标签页
class _RegionsTab extends ConsumerWidget {
  final VoidCallback onBack;

  const _RegionsTab({required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.watch(heritageRepositoryProvider);

    return FutureBuilder<TaxonomyIndexDto<TaxonomyTopicDto>>(
      future: repo.taxonomyRegions(),
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
        final items = snapshot.data?.items ?? [];
        if (items.isEmpty) return EmptyState(message: l10n.commonEmpty);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              _TaxonomyTopicCard(topic: items[index], onBack: onBack),
        );
      },
    );
  }
}

/// 种类标签页
class _KindsTab extends ConsumerWidget {
  final VoidCallback onBack;

  const _KindsTab({required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.watch(heritageRepositoryProvider);

    return FutureBuilder<TaxonomyIndexDto<TaxonomyKindDto>>(
      future: repo.taxonomyKinds(),
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
        final items = snapshot.data?.items ?? [];
        if (items.isEmpty) return EmptyState(message: l10n.commonEmpty);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _KindCard(
            kind: items[index],
            onBack: onBack,
          ),
        );
      },
    );
  }
}

/// 主题卡片
class _TaxonomyTopicCard extends StatelessWidget {
  final TaxonomyTopicDto topic;
  final VoidCallback onBack;

  const _TaxonomyTopicCard({required this.topic, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ContentCard(
        onTap: () {
          // Navigate to detail based on type
          if (topic.type == 'category') {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TaxonomyCategoryDetailPage(
                category: topic.key,
                onBack: () => Navigator.of(context).pop(),
              ),
            ));
          } else if (topic.type == 'region') {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TaxonomyRegionDetailPage(
                region: topic.key,
                onBack: () => Navigator.of(context).pop(),
              ),
            ));
          }
        },
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.title, style: Theme.of(context).textTheme.titleMedium),
            if (topic.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(topic.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                MetaChip(text: '${topic.total}'),
                if (topic.topRegions.isNotEmpty)
                  MetaChip(
                      text: topic.topRegions
                          .take(2)
                          .map((r) => r.region)
                          .join(' · ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Kind 卡片
class _KindCard extends StatelessWidget {
  final TaxonomyKindDto kind;
  final VoidCallback onBack;

  const _KindCard({required this.kind, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ContentCard(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TaxonomyKindDetailPage(
              kind: kind.key,
              title: kind.title,
              onBack: () => Navigator.of(context).pop(),
            ),
          ));
        },
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kind.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                MetaChip(text: '${kind.total}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 分类详情页
class TaxonomyCategoryDetailPage extends ConsumerStatefulWidget {
  final String category;
  final VoidCallback onBack;

  const TaxonomyCategoryDetailPage({
    super.key,
    required this.category,
    required this.onBack,
  });

  @override
  ConsumerState<TaxonomyCategoryDetailPage> createState() =>
      _TaxonomyCategoryDetailPageState();
}

class _TaxonomyCategoryDetailPageState
    extends ConsumerState<TaxonomyCategoryDetailPage> {
  TaxonomyCategoryDetailDto? _detail;
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
      final detail = await repo.taxonomyCategoryDetail(widget.category);
      if (mounted) setState(() { _detail = detail; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
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
          tooltip: l10n.actionBack,
        ),
        title: Text(_detail?.topic.title ?? widget.category),
      ),
      body: PageBackground(child: _buildBody(context, l10n)),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) return const LoadingPlaceholder();
    if (_error != null) {
      return ErrorRetryRow(message: l10n.commonError, onRetry: _loadData);
    }
    final detail = _detail;
    if (detail == null) return EmptyState(message: l10n.commonEmpty);

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 统计
          _StatsRow(stats: detail.stats, l10n: l10n),
          const SizedBox(height: 16),

          // 地区分布
          if (detail.topRegions.isNotEmpty) ...[
            Text(l10n.directoryStatisticsRegionBreakdown,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.topRegions.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(r.region)),
                      Text('${r.count}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
          ],

          // 文章
          if (detail.articles.isNotEmpty) ...[
            Text(l10n.taxonomyArticles,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.articles.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListCard(
                    onTap: () => ContentNavigator.toArticle(
                      context,
                      id: a.id,
                      sourceId: a.sourceId,
                      sourceUrl: a.sourceUrl,
                      category: a.category.wireName,
                    ),
                    image: SizedBox(
                      width: 48,
                      height: 48,
                      child: ImagePlaceholder(text: a.title?.isNotEmpty == true ? a.title!.substring(0, 1) : ''),
                    ),
                    text: Text(a.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                )),
            const SizedBox(height: 16),
          ],

          // 名录
          if (detail.directoryItems.isNotEmpty) ...[
            Text(l10n.taxonomyDirectoryItems,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.directoryItems.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListCard(
                    onTap: () => ContentNavigator.toDirectory(
                      context,
                      id: d.id,
                      sourceId: d.sourceId,
                      kind: d.kind.wireName,
                    ),
                    image: SizedBox(
                      width: 48,
                      height: 48,
                      child: ImagePlaceholder(text: d.title?.isNotEmpty == true ? d.title!.substring(0, 1) : ''),
                    ),
                    text: Text(d.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                )),
            const SizedBox(height: 16),
          ],

          // 传承人
          if (detail.inheritors.isNotEmpty) ...[
            Text(l10n.taxonomyInheritors,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.inheritors.map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListCard(
                    onTap: () => ContentNavigator.toInheritor(
                      context,
                      id: i.id,
                      sourceId: i.sourceId,
                    ),
                    image: SizedBox(
                      width: 48,
                      height: 48,
                      child: ImagePlaceholder(text: i.name?.isNotEmpty == true ? i.name!.substring(0, 1) : ''),
                    ),
                    text: Text(i.name ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                )),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// 地区详情页
class TaxonomyRegionDetailPage extends ConsumerStatefulWidget {
  final String region;
  final VoidCallback onBack;

  const TaxonomyRegionDetailPage({
    super.key,
    required this.region,
    required this.onBack,
  });

  @override
  ConsumerState<TaxonomyRegionDetailPage> createState() =>
      _TaxonomyRegionDetailPageState();
}

class _TaxonomyRegionDetailPageState
    extends ConsumerState<TaxonomyRegionDetailPage> {
  TaxonomyRegionDetailDto? _detail;
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
      final detail = await repo.taxonomyRegionDetail(widget.region);
      if (mounted) setState(() { _detail = detail; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
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
          tooltip: l10n.actionBack,
        ),
        title: Text(_detail?.topic.title ?? widget.region),
      ),
      body: PageBackground(child: _buildBody(context, l10n)),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) return const LoadingPlaceholder();
    if (_error != null) {
      return ErrorRetryRow(message: l10n.commonError, onRetry: _loadData);
    }
    final detail = _detail;
    if (detail == null) return EmptyState(message: l10n.commonEmpty);

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatsRow(stats: detail.stats, l10n: l10n),
          const SizedBox(height: 16),

          if (detail.topCategories.isNotEmpty) ...[
            Text(l10n.directoryStatisticsCategoryBreakdown,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.topCategories.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(child: Text(c.category)),
                      Text('${c.count}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
          ],

          if (detail.articles.isNotEmpty) ...[
            Text(l10n.taxonomyArticles,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.articles.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListCard(
                    onTap: () => ContentNavigator.toArticle(
                      context,
                      id: a.id,
                      sourceId: a.sourceId,
                      sourceUrl: a.sourceUrl,
                      category: a.category.wireName,
                    ),
                    image: SizedBox(
                      width: 48,
                      height: 48,
                      child: ImagePlaceholder(text: a.title?.isNotEmpty == true ? a.title!.substring(0, 1) : ''),
                    ),
                    text: Text(a.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                )),
            const SizedBox(height: 16),
          ],

          if (detail.directoryItems.isNotEmpty) ...[
            Text(l10n.taxonomyDirectoryItems,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...detail.directoryItems.map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListCard(
                    onTap: () => ContentNavigator.toDirectory(
                      context,
                      id: d.id,
                      sourceId: d.sourceId,
                      kind: d.kind.wireName,
                    ),
                    image: SizedBox(
                      width: 48,
                      height: 48,
                      child: ImagePlaceholder(text: d.title?.isNotEmpty == true ? d.title!.substring(0, 1) : ''),
                    ),
                    text: Text(d.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                )),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// 统计行
class _StatsRow extends StatelessWidget {
  final TaxonomyStatDto stats;
  final AppLocalizations l10n;

  const _StatsRow({required this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStat(context, '${stats.directoryItemCount}',
            l10n.taxonomyDirectoryItems),
        const SizedBox(width: 8),
        _buildStat(
            context, '${stats.inheritorCount}', l10n.taxonomyInheritors),
        const SizedBox(width: 8),
        _buildStat(context, '${stats.articleCount}', l10n.taxonomyArticles),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 2),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

/// 种类详情页
/// 显示 kind 统计和该 kind 下的名录列表
class TaxonomyKindDetailPage extends ConsumerStatefulWidget {
  final String kind;
  final String title;
  final VoidCallback onBack;

  const TaxonomyKindDetailPage({
    super.key,
    required this.kind,
    required this.title,
    required this.onBack,
  });

  @override
  ConsumerState<TaxonomyKindDetailPage> createState() =>
      _TaxonomyKindDetailPageState();
}

class _TaxonomyKindDetailPageState
    extends ConsumerState<TaxonomyKindDetailPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(widget.title),
      ),
      body: PageBackground(
        child: _KindDirectoryList(kind: widget.kind),
      ),
    );
  }
}

/// Kind 下的名录列表
class _KindDirectoryList extends ConsumerStatefulWidget {
  final String kind;

  const _KindDirectoryList({required this.kind});

  @override
  ConsumerState<_KindDirectoryList> createState() => _KindDirectoryListState();
}

class _KindDirectoryListState extends ConsumerState<_KindDirectoryList> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.watch(heritageRepositoryProvider);

    return FutureBuilder(
      future: repo.directoryItems(kind: widget.kind, pageSize: 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPlaceholder();
        }
        if (snapshot.hasError) {
          return ErrorRetryRow(
            message: l10n.commonError,
            onRetry: () => setState(() {}),
          );
        }
        final items = snapshot.data?.items ?? [];
        if (items.isEmpty) return EmptyState(message: l10n.commonEmpty);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListCard(
                onTap: () => ContentNavigator.toDirectory(
                  context,
                  id: item.id,
                  sourceId: item.sourceId,
                  kind: item.kind.wireName,
                ),
                image: SizedBox(
                  width: 48,
                  height: 48,
                  child: ImagePlaceholder(
                    text: (item.title?.isNotEmpty == true)
                        ? item.title!.substring(0, 1)
                        : '',
                  ),
                ),
                text: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    if (item.category != null) ...[
                      const SizedBox(height: 2),
                      Text(item.category!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
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
