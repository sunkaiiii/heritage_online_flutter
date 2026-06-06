import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 本地化预览页面
/// 展示所有本地化文案，用于验证本地化配置
class LocalizationPreviewPage extends StatelessWidget {
  const LocalizationPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('本地化预览'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 内容类型
          _buildSectionHeader(context, '内容类型 (localizedContentType)'),
          _buildLabelRow(context, 'article', localizedContentType(context, 'article') ?? '-'),
          _buildLabelRow(context, 'directoryItem', localizedContentType(context, 'directoryItem') ?? '-'),
          _buildLabelRow(context, 'inheritor', localizedContentType(context, 'inheritor') ?? '-'),
          _buildLabelRow(context, 'collection', localizedContentType(context, 'collection') ?? '-'),
          _buildLabelRow(context, 'topic', localizedContentType(context, 'topic') ?? '-'),
          _buildLabelRow(context, 'unknown', localizedContentType(context, 'unknown') ?? '-'),
          const SizedBox(height: 24),

          // 文章分类
          _buildSectionHeader(context, '文章分类 (localizedArticleCategory)'),
          _buildLabelRow(context, 'news', localizedArticleCategory(context, 'news') ?? '-'),
          _buildLabelRow(context, 'forum', localizedArticleCategory(context, 'forum') ?? '-'),
          _buildLabelRow(context, 'specialTopic', localizedArticleCategory(context, 'specialTopic') ?? '-'),
          _buildLabelRow(context, 'unknown', localizedArticleCategory(context, 'unknown') ?? '-'),
          const SizedBox(height: 24),

          // 名录种类
          _buildSectionHeader(context, '名录种类 (localizedDirectoryKind)'),
          _buildLabelRow(context, 'nationalProject', localizedDirectoryKind(context, 'nationalProject') ?? '-'),
          _buildLabelRow(context, 'culturalEcoZone', localizedDirectoryKind(context, 'culturalEcoZone') ?? '-'),
          _buildLabelRow(context, 'productiveProtectionBase', localizedDirectoryKind(context, 'productiveProtectionBase') ?? '-'),
          _buildLabelRow(context, 'unescoEntry', localizedDirectoryKind(context, 'unescoEntry') ?? '-'),
          _buildLabelRow(context, 'chinaUnescoEntry', localizedDirectoryKind(context, 'chinaUnescoEntry') ?? '-'),
          _buildLabelRow(context, 'contractingState', localizedDirectoryKind(context, 'contractingState') ?? '-'),
          _buildLabelRow(context, 'unknown', localizedDirectoryKind(context, 'unknown') ?? '-'),
          const SizedBox(height: 24),

          // 阅读路径来源
          _buildSectionHeader(context, '阅读路径来源 (localizedReadingPathSource)'),
          _buildLabelRow(context, 'blendedRecommendation', localizedReadingPathSource(context, 'blendedRecommendation')),
          _buildLabelRow(context, 'related', localizedReadingPathSource(context, 'related')),
          _buildLabelRow(context, 'recommendation', localizedReadingPathSource(context, 'recommendation')),
          _buildLabelRow(context, 'semanticRecommendation', localizedReadingPathSource(context, 'semanticRecommendation')),
          _buildLabelRow(context, 'collection', localizedReadingPathSource(context, 'collection')),
          _buildLabelRow(context, 'graph', localizedReadingPathSource(context, 'graph')),
          _buildLabelRow(context, 'exploreTopic', localizedReadingPathSource(context, 'exploreTopic')),
          _buildLabelRow(context, 'list', localizedReadingPathSource(context, 'list')),
          _buildLabelRow(context, 'unknown', localizedReadingPathSource(context, 'unknown')),
          const SizedBox(height: 24),

          // 通用文案
          _buildSectionHeader(context, '通用文案'),
          _buildLabelRow(context, 'appTitle', l10n.appTitle),
          _buildLabelRow(context, 'commonRetry', l10n.commonRetry),
          _buildLabelRow(context, 'commonLoading', l10n.commonLoading),
          _buildLabelRow(context, 'commonError', l10n.commonError),
          _buildLabelRow(context, 'commonEmpty', l10n.commonEmpty),
          _buildLabelRow(context, 'commonSeeAll', l10n.commonSeeAll),
          _buildLabelRow(context, 'commonConfirm', l10n.commonConfirm),
          _buildLabelRow(context, 'commonCancel', l10n.commonCancel),
          const SizedBox(height: 24),

          // Tab 文案
          _buildSectionHeader(context, 'Tab 文案'),
          _buildLabelRow(context, 'tabArticles', l10n.tabArticles),
          _buildLabelRow(context, 'tabDirectory', l10n.tabDirectory),
          _buildLabelRow(context, 'tabInheritors', l10n.tabInheritors),
          _buildLabelRow(context, 'tabDiscovery', l10n.tabDiscovery),
          const SizedBox(height: 24),

          // 设置文案
          _buildSectionHeader(context, '设置文案'),
          _buildLabelRow(context, 'settingsTitle', l10n.settingsTitle),
          _buildLabelRow(context, 'settingsLanguage', l10n.settingsLanguage),
          _buildLabelRow(context, 'settingsTheme', l10n.settingsTheme),
          _buildLabelRow(context, 'settingsThemeLight', l10n.settingsThemeLight),
          _buildLabelRow(context, 'settingsThemeDark', l10n.settingsThemeDark),
          _buildLabelRow(context, 'settingsThemeSystem', l10n.settingsThemeSystem),
          const SizedBox(height: 24),

          // 文章页文案
          _buildSectionHeader(context, '文章页文案'),
          _buildLabelRow(context, 'articlesHeaderTitle', l10n.articlesHeaderTitle),
          _buildLabelRow(context, 'articlesHeaderSubtitle', l10n.articlesHeaderSubtitle),
          _buildLabelRow(context, 'articlesLatestTitle', l10n.articlesLatestTitle),
          _buildLabelRow(context, 'articlesSearchLabel', l10n.articlesSearchLabel),
          _buildLabelRow(context, 'articlesSearchPlaceholder', l10n.articlesSearchPlaceholder),
          const SizedBox(height: 24),

          // 名录页文案
          _buildSectionHeader(context, '名录页文案'),
          _buildLabelRow(context, 'directoryTitle', l10n.directoryTitle),
          _buildLabelRow(context, 'directorySubtitle', l10n.directorySubtitle),
          _buildLabelRow(context, 'directorySearchLabel', l10n.directorySearchLabel),
          _buildLabelRow(context, 'directorySearchPlaceholder', l10n.directorySearchPlaceholder),
          const SizedBox(height: 24),

          // 传承人页文案
          _buildSectionHeader(context, '传承人页文案'),
          _buildLabelRow(context, 'inheritorsTitle', l10n.inheritorsTitle),
          _buildLabelRow(context, 'inheritorsSubtitle', l10n.inheritorsSubtitle),
          _buildLabelRow(context, 'inheritorsSearchLabel', l10n.inheritorsSearchLabel),
          _buildLabelRow(context, 'inheritorsSearchPlaceholder', l10n.inheritorsSearchPlaceholder),
          const SizedBox(height: 24),

          // 发现页文案
          _buildSectionHeader(context, '发现页文案'),
          _buildLabelRow(context, 'discoveryTitle', l10n.discoveryTitle),
          _buildLabelRow(context, 'discoverySubtitle', l10n.discoverySubtitle),
          _buildLabelRow(context, 'discoverySearchPlaceholder', l10n.discoverySearchPlaceholder),
          _buildLabelRow(context, 'discoveryExploreTopics', l10n.discoveryExploreTopics),
          _buildLabelRow(context, 'discoveryLearningPaths', l10n.discoveryLearningPaths),
          _buildLabelRow(context, 'discoveryFeaturedCollections', l10n.discoveryFeaturedCollections),
          _buildLabelRow(context, 'discoveryRegionAtlas', l10n.discoveryRegionAtlas),
          _buildLabelRow(context, 'discoveryTimeline', l10n.discoveryTimeline),
          _buildLabelRow(context, 'discoveryTimelineSubtitle', l10n.discoveryTimelineSubtitle),
          const SizedBox(height: 24),

          // 筛选文案
          _buildSectionHeader(context, '筛选文案'),
          _buildLabelRow(context, 'filterButton', l10n.filterButton),
          _buildLabelRow(context, 'filterClear', l10n.filterClear),
          _buildLabelRow(context, 'filterApply', l10n.filterApply),
          _buildLabelRow(context, 'filterInvalidYear', l10n.filterInvalidYear),
          const SizedBox(height: 24),

          // 我的页文案
          _buildSectionHeader(context, '我的页文案'),
          _buildLabelRow(context, 'myTitle', l10n.myTitle),
          _buildLabelRow(context, 'favoritesTab', l10n.favoritesTab),
          _buildLabelRow(context, 'recentTab', l10n.recentTab),
          _buildLabelRow(context, 'readingPathTab', l10n.readingPathTab),
          _buildLabelRow(context, 'actionFavorite', l10n.actionFavorite),
          _buildLabelRow(context, 'actionUnfavorite', l10n.actionUnfavorite),
          const SizedBox(height: 24),

          // 操作文案
          _buildSectionHeader(context, '操作文案'),
          _buildLabelRow(context, 'actionViewSource', l10n.actionViewSource),
          _buildLabelRow(context, 'actionBack', l10n.actionBack),
          _buildLabelRow(context, 'actionRefresh', l10n.actionRefresh),
          const SizedBox(height: 24),

          // 错误文案
          _buildSectionHeader(context, '错误文案'),
          _buildLabelRow(context, 'errorNetworkUnavailable', l10n.errorNetworkUnavailable),
          _buildLabelRow(context, 'errorTimeout', l10n.errorTimeout),
          _buildLabelRow(context, 'errorServerUnavailable', l10n.errorServerUnavailable),
          _buildLabelRow(context, 'contentMayBeStale', l10n.contentMayBeStale),
          const SizedBox(height: 24),

          // 品牌文案
          _buildSectionHeader(context, '品牌文案'),
          _buildLabelRow(context, 'brandFallback', l10n.brandFallback),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildLabelRow(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              key,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
