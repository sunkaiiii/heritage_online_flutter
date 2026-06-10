import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_page.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/collection/collection_detail_page.dart';
import 'package:heritage_online_flutter/features/discovery/explore_topic/explore_topic_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart';

/// 统一内容导航 mapper
/// 解决详情跳转时同时传 id 和 sourceId/sourceUrl 导致误走 internal id endpoint 的问题
///
/// 规则（spec 5.2）：
/// - article：如果有 sourceId 或 sourceUrl，传 articleId: null
/// - directory：如果有 sourceId，传 itemId: null
/// - inheritor：如果有 sourceId，传 inheritorId: null
/// - 只有完全没有外部 lookup key 时，才传 internal id
class ContentNavigator {
  ContentNavigator._();

  /// 导航到文章详情
  /// 自动处理 id/sourceId/sourceUrl 优先级
  static void toArticle(
    BuildContext context, {
    String? id,
    String? sourceId,
    String? sourceUrl,
    String? category,
  }) {
    final hasExternalKey =
        (sourceId != null && sourceId.isNotEmpty) ||
        (sourceUrl != null && sourceUrl.isNotEmpty);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ArticleDetailPage(
        articleId: hasExternalKey ? null : _nonNull(id),
        sourceId: _nonNull(sourceId),
        sourceUrl: _nonNull(sourceUrl),
        category: category?.isNotEmpty == true
            ? ArticleCategory.fromWireName(category!)
            : ArticleCategory.news,
        onBack: () => Navigator.of(context).pop(),
      ),
    ));
  }

  /// 导航到名录详情
  /// 自动处理 id/sourceId 优先级
  static void toDirectory(
    BuildContext context, {
    String? id,
    String? sourceId,
    String? kind,
  }) {
    final hasExternalKey = sourceId != null && sourceId.isNotEmpty;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DirectoryDetailPage(
        itemId: hasExternalKey ? null : _nonNull(id),
        sourceId: _nonNull(sourceId),
        kind: kind?.isNotEmpty == true
            ? DirectoryItemKind.fromWireName(kind!)
            : DirectoryItemKind.nationalProject,
        onBack: () => Navigator.of(context).pop(),
      ),
    ));
  }

  /// 导航到传承人详情
  /// 自动处理 id/sourceId 优先级
  static void toInheritor(
    BuildContext context, {
    String? id,
    String? sourceId,
  }) {
    final hasExternalKey = sourceId != null && sourceId.isNotEmpty;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => InheritorDetailPage(
        inheritorId: hasExternalKey ? null : _nonNull(id),
        sourceId: _nonNull(sourceId),
        onBack: () => Navigator.of(context).pop(),
      ),
    ));
  }

  /// 按类型自动导航到对应详情
  /// 用于混合内容列表（搜索结果、推荐、context 等）
  static void toDetail(
    BuildContext context, {
    required String type,
    String? id,
    String? sourceId,
    String? sourceUrl,
    String? category,
    String? kind,
  }) {
    switch (type) {
      case 'article':
        toArticle(
          context,
          id: id,
          sourceId: sourceId,
          sourceUrl: sourceUrl,
          category: category,
        );
        break;
      case 'directoryItem':
        toDirectory(
          context,
          id: id,
          sourceId: sourceId,
          kind: kind,
        );
        break;
      case 'inheritor':
        toInheritor(
          context,
          id: id,
          sourceId: sourceId,
        );
        break;
    }
  }

  /// 导航到合集详情
  static void toCollection(
    BuildContext context, {
    String? collectionId,
    String? type,
    String? topicKey,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CollectionDetailPage(
        collectionId: collectionId,
        onBack: () => Navigator.of(context).pop(),
      ),
    ));
  }

  /// 导航到探索主题详情
  static void toExploreTopic(
    BuildContext context, {
    required String type,
    required String topicKey,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ExploreTopicDetailPage(
        type: type,
        topicKey: topicKey,
        onBack: () => Navigator.of(context).pop(),
      ),
    ));
  }

  /// 空字符串视为 null
  static String? _nonNull(String? value) =>
      value?.isNotEmpty == true ? value : null;
}
