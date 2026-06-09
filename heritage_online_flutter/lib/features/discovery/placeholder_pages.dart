import 'package:flutter/material.dart';

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

/// 探索主题页占位
class ExploreTopicsPage extends StatelessWidget {
  const ExploreTopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryExploreTopics)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 学习路径页占位
class LearningPathsPage extends StatelessWidget {
  const LearningPathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryLearningPaths)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 精选合集页占位
class FeaturedCollectionsPage extends StatelessWidget {
  const FeaturedCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryFeaturedCollections)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 地区图谱页占位
class RegionAtlasPage extends StatelessWidget {
  const RegionAtlasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryRegionAtlas)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 时间线页占位
class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryTimeline)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 主题库页占位
class TaxonomyPage extends StatelessWidget {
  const TaxonomyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryTaxonomy)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 数据故事页占位
class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryStories)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}

/// 随便看看页占位
class SerendipityPage extends StatelessWidget {
  const SerendipityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoverySerendipity)),
      body: PageBackground(
        child: Center(child: Text(l10n.commonEmpty)),
      ),
    );
  }
}
