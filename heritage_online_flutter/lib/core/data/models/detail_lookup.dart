import 'package:heritage_online_flutter/core/network/dto/enums.dart';

/// 文章详情查找参数
/// 支持三种查找方式：by id, by sourceId, by sourceUrl
class ArticleDetailLookup {
  final String? articleId;
  final String? sourceId;
  final String? sourceUrl;
  final ArticleCategory category;

  const ArticleDetailLookup({
    this.articleId,
    this.sourceId,
    this.sourceUrl,
    this.category = ArticleCategory.news,
  });

  /// 是否有有效的查找 key
  bool get isValid =>
      articleId != null && articleId!.isNotEmpty ||
      sourceId != null && sourceId!.isNotEmpty ||
      sourceUrl != null && sourceUrl!.isNotEmpty;

  @override
  String toString() {
    return 'ArticleDetailLookup(articleId: $articleId, sourceId: $sourceId, sourceUrl: $sourceUrl, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArticleDetailLookup &&
        other.articleId == articleId &&
        other.sourceId == sourceId &&
        other.sourceUrl == sourceUrl &&
        other.category == category;
  }

  @override
  int get hashCode {
    return articleId.hashCode ^
        sourceId.hashCode ^
        sourceUrl.hashCode ^
        category.hashCode;
  }
}

/// 名录详情查找参数
/// 支持两种查找方式：by id, by sourceId
class DirectoryDetailLookup {
  final String? itemId;
  final String? sourceId;
  final DirectoryItemKind kind;

  const DirectoryDetailLookup({
    this.itemId,
    this.sourceId,
    this.kind = DirectoryItemKind.nationalProject,
  });

  /// 是否有有效的查找 key
  bool get isValid =>
      itemId != null && itemId!.isNotEmpty ||
      sourceId != null && sourceId!.isNotEmpty;

  @override
  String toString() {
    return 'DirectoryDetailLookup(itemId: $itemId, sourceId: $sourceId, kind: $kind)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DirectoryDetailLookup &&
        other.itemId == itemId &&
        other.sourceId == sourceId &&
        other.kind == kind;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^ sourceId.hashCode ^ kind.hashCode;
  }
}

/// 传承人详情查找参数
/// 支持两种查找方式：by id, by sourceId
class InheritorDetailLookup {
  final String? inheritorId;
  final String? sourceId;

  const InheritorDetailLookup({
    this.inheritorId,
    this.sourceId,
  });

  /// 是否有有效的查找 key
  bool get isValid =>
      inheritorId != null && inheritorId!.isNotEmpty ||
      sourceId != null && sourceId!.isNotEmpty;

  @override
  String toString() {
    return 'InheritorDetailLookup(inheritorId: $inheritorId, sourceId: $sourceId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InheritorDetailLookup &&
        other.inheritorId == inheritorId &&
        other.sourceId == sourceId;
  }

  @override
  int get hashCode {
    return inheritorId.hashCode ^ sourceId.hashCode;
  }
}
