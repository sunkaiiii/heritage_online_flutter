import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 内容类型本地化
/// 将内容类型 wire value 映射为本地化显示文案
/// 覆盖 article / directoryItem / inheritor / collection / topic
/// 未知值原样返回（非空时），null 或空字符串返回 null
String? localizedContentType(BuildContext context, String? type) {
  if (type == null || type.isEmpty) return null;
  final l10n = AppLocalizations.of(context)!;
  switch (type) {
    case 'article':
      return l10n.contentTypeArticle;
    case 'directoryItem':
      return l10n.contentTypeDirectory;
    case 'inheritor':
      return l10n.contentTypeInheritor;
    case 'collection':
      return l10n.contentTypeCollection;
    case 'topic':
      return l10n.contentTypeTopic;
    default:
      return type;
  }
}

/// 文章分类本地化
/// 将文章分类 wire value 映射为本地化显示文案
/// 覆盖 news / forum / specialTopic
/// 未知值返回原值（如果有）
String? localizedArticleCategory(BuildContext context, String? category) {
  final l10n = AppLocalizations.of(context)!;
  switch (category) {
    case 'news':
      return l10n.categoryNews;
    case 'forum':
      return l10n.categoryForum;
    case 'specialTopic':
      return l10n.categorySpecialTopic;
    default:
      return category?.isNotEmpty == true ? category : null;
  }
}

/// 名录种类本地化
/// 将名录种类 wire value 映射为本地化显示文案
/// 覆盖 nationalProject / culturalEcoZone / productiveProtectionBase / unescoEntry / chinaUnescoEntry / contractingState
/// 未知值返回原值（如果有）
String? localizedDirectoryKind(BuildContext context, String? kind) {
  final l10n = AppLocalizations.of(context)!;
  switch (kind) {
    case 'nationalProject':
      return l10n.directoryKindNationalProject;
    case 'culturalEcoZone':
      return l10n.directoryKindCulturalEcoZone;
    case 'productiveProtectionBase':
      return l10n.directoryKindProductiveProtectionBase;
    case 'unescoEntry':
      return l10n.directoryKindUnescoEntry;
    case 'chinaUnescoEntry':
      return l10n.directoryKindChinaUnescoEntry;
    case 'contractingState':
      return l10n.directoryKindContractingState;
    default:
      return kind?.isNotEmpty == true ? kind : null;
  }
}

/// 阅读路径来源本地化
/// 将阅读路径来源 wire value 映射为本地化显示文案
String localizedReadingPathSource(BuildContext context, String source) {
  final l10n = AppLocalizations.of(context)!;
  switch (source) {
    case 'blendedRecommendation':
      return l10n.readingPathSourceBlendedRecommendation;
    case 'related':
      return l10n.readingPathSourceRelated;
    case 'recommendation':
      return l10n.readingPathSourceRecommendation;
    case 'semanticRecommendation':
      return l10n.readingPathSourceSemanticRecommendation;
    case 'collection':
      return l10n.readingPathSourceCollection;
    case 'graph':
      return l10n.readingPathSourceGraph;
    case 'exploreTopic':
      return l10n.readingPathSourceExploreTopic;
    case 'list':
      return l10n.readingPathSourceList;
    default:
      return source;
  }
}
