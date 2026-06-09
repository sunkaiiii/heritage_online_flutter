import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/story_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 数据故事索引页
class StoriesIndexPage extends ConsumerWidget {
  final VoidCallback onBack;

  const StoriesIndexPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.discoveryStories),
      ),
      body: PageBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StoryCategorySection(
              title: l10n.storiesByRegion,
              icon: Icons.map,
              items: const ['北京', '上海', '四川', '江苏', '浙江', '广东'],
              onItemSelected: (item) => _navigateToStory(
                context,
                StoryType.region,
                item,
              ),
            ),
            const SizedBox(height: 24),
            _StoryCategorySection(
              title: l10n.storiesByCategory,
              icon: Icons.category,
              items: const ['传统技艺', '传统音乐', '传统戏剧', '传统美术', '民俗', '民间文学'],
              onItemSelected: (item) => _navigateToStory(
                context,
                StoryType.category,
                item,
              ),
            ),
            const SizedBox(height: 24),
            _StoryCategorySection(
              title: l10n.storiesByYear,
              icon: Icons.calendar_today,
              items: const ['2024', '2023', '2022', '2021', '2020'],
              onItemSelected: (item) => _navigateToStory(
                context,
                StoryType.year,
                item,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToStory(BuildContext context, StoryType type, String value) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryDetailPage(
          type: type,
          value: value,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

enum StoryType { region, category, year }

/// 故事分类区块
class _StoryCategorySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String> onItemSelected;

  const _StoryCategorySection({
    required this.title,
    required this.icon,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: items
              .map((item) => ActionChip(
                    label: Text(item),
                    onPressed: () => onItemSelected(item),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

/// 故事详情页
class StoryDetailPage extends ConsumerStatefulWidget {
  final StoryType type;
  final String value;
  final VoidCallback onBack;

  const StoryDetailPage({
    super.key,
    required this.type,
    required this.value,
    required this.onBack,
  });

  @override
  ConsumerState<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends ConsumerState<StoryDetailPage> {
  DataStoryDto? _story;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  Future<void> _loadStory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(heritageRepositoryProvider);
      DataStoryDto story;
      switch (widget.type) {
        case StoryType.region:
          story = await repo.regionStory(widget.value);
          break;
        case StoryType.category:
          story = await repo.categoryStory(widget.value);
          break;
        case StoryType.year:
          story = await repo.yearStory(int.parse(widget.value));
          break;
      }
      if (mounted) {
        setState(() {
          _story = story;
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
          tooltip: l10n.actionBack,
        ),
        title: Text(_story?.title ?? widget.value),
      ),
      body: PageBackground(
        child: _buildBody(context, l10n),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) return const LoadingPlaceholder();
    if (_error != null) {
      return ErrorRetryRow(message: l10n.commonError, onRetry: _loadStory);
    }
    final story = _story;
    if (story == null) return EmptyState(message: l10n.commonEmpty);

    return RefreshIndicator(
      onRefresh: _loadStory,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 标题
          Text(story.title, style: Theme.of(context).textTheme.headlineMedium),
          if (story.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(story.subtitle!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ],
          const SizedBox(height: 20),

          // 区块
          ...story.sections.map((section) => _buildSection(context, section)),

          // 相关主题
          if (story.relatedTopics.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(l10n.exploreTopicRelated,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: story.relatedTopics
                  .map((t) => MetaChip(text: t.title ?? t.key ?? ''))
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, DataStorySectionDto section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ContentCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title,
                style: Theme.of(context).textTheme.titleMedium),
            if (section.body != null) ...[
              const SizedBox(height: 8),
              Text(section.body!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (section.items.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...section.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        MetaChip(
                            text: localizedContentType(context, item.type) ??
                                item.type),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(item.title,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
