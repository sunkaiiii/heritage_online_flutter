/// 保存内容类型
enum SavedContentType {
  article('article'),
  directoryItem('directoryItem'),
  inheritor('inheritor');

  final String wireName;
  const SavedContentType(this.wireName);

  static SavedContentType fromWireName(String? value) {
    switch (value) {
      case 'article':
        return SavedContentType.article;
      case 'directoryItem':
        return SavedContentType.directoryItem;
      case 'inheritor':
        return SavedContentType.inheritor;
      default:
        return SavedContentType.article;
    }
  }
}

/// 保存内容目标标识
class SavedContentTarget {
  final String? id;
  final String? sourceId;
  final String? sourceUrl;
  final String? category;
  final String? kind;

  const SavedContentTarget({
    this.id,
    this.sourceId,
    this.sourceUrl,
    this.category,
    this.kind,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedContentTarget &&
        other.id == id &&
        other.sourceId == sourceId &&
        other.sourceUrl == sourceUrl &&
        other.category == category &&
        other.kind == kind;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sourceId.hashCode ^
        sourceUrl.hashCode ^
        category.hashCode ^
        kind.hashCode;
  }
}

/// 保存内容快照
class SavedContentSnapshot {
  final SavedContentType contentType;
  final String? id;
  final String? title;
  final String? summary;
  final String? coverImageJson;
  final String? category;
  final String? region;
  final int? year;
  final String? sourceUrl;
  final SavedContentTarget target;

  const SavedContentSnapshot({
    required this.contentType,
    this.id,
    this.title,
    this.summary,
    this.coverImageJson,
    this.category,
    this.region,
    this.year,
    this.sourceUrl,
    this.target = const SavedContentTarget(),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedContentSnapshot &&
        other.contentType == contentType &&
        other.id == id &&
        other.title == title &&
        other.summary == summary &&
        other.coverImageJson == coverImageJson &&
        other.category == category &&
        other.region == region &&
        other.year == year &&
        other.sourceUrl == sourceUrl &&
        other.target == target;
  }

  @override
  int get hashCode {
    return contentType.hashCode ^
        id.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        coverImageJson.hashCode ^
        category.hashCode ^
        region.hashCode ^
        year.hashCode ^
        sourceUrl.hashCode ^
        target.hashCode;
  }
}

/// 保存内容实体（用于本地存储）
class SavedContentEntity {
  final String contentKey;
  final String contentType;
  final String? title;
  final String? summary;
  final String? coverImageJson;
  final String? category;
  final String? region;
  final int? year;
  final String? sourceUrl;
  final String? targetId;
  final String? targetSourceId;
  final String? targetSourceUrl;
  final String? targetCategory;
  final String? targetKind;
  final bool isFavorite;
  final int? favoritedAt;
  final int lastViewedAt;

  const SavedContentEntity({
    required this.contentKey,
    required this.contentType,
    this.title,
    this.summary,
    this.coverImageJson,
    this.category,
    this.region,
    this.year,
    this.sourceUrl,
    this.targetId,
    this.targetSourceId,
    this.targetSourceUrl,
    this.targetCategory,
    this.targetKind,
    this.isFavorite = false,
    this.favoritedAt,
    this.lastViewedAt = 0,
  });

  SavedContentEntity copyWith({
    String? contentKey,
    String? contentType,
    String? title,
    String? summary,
    String? coverImageJson,
    String? category,
    String? region,
    int? year,
    String? sourceUrl,
    String? targetId,
    String? targetSourceId,
    String? targetSourceUrl,
    String? targetCategory,
    String? targetKind,
    bool? isFavorite,
    int? favoritedAt,
    int? lastViewedAt,
  }) {
    return SavedContentEntity(
      contentKey: contentKey ?? this.contentKey,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      coverImageJson: coverImageJson ?? this.coverImageJson,
      category: category ?? this.category,
      region: region ?? this.region,
      year: year ?? this.year,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      targetId: targetId ?? this.targetId,
      targetSourceId: targetSourceId ?? this.targetSourceId,
      targetSourceUrl: targetSourceUrl ?? this.targetSourceUrl,
      targetCategory: targetCategory ?? this.targetCategory,
      targetKind: targetKind ?? this.targetKind,
      isFavorite: isFavorite ?? this.isFavorite,
      favoritedAt: favoritedAt ?? this.favoritedAt,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    );
  }

  /// 从快照创建实体
  /// 如果没有有效 lookup key（id/sourceId/sourceUrl 都为空），返回 null
  static SavedContentEntity? tryFromSnapshot(SavedContentSnapshot snapshot) {
    final key = computeKey(snapshot);
    if (key == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    return SavedContentEntity(
      contentKey: key,
      contentType: snapshot.contentType.wireName,
      title: snapshot.title,
      summary: snapshot.summary,
      coverImageJson: snapshot.coverImageJson,
      category: snapshot.category,
      region: snapshot.region,
      year: snapshot.year,
      sourceUrl: snapshot.sourceUrl,
      targetId: snapshot.target.id,
      targetSourceId: snapshot.target.sourceId,
      targetSourceUrl: snapshot.target.sourceUrl,
      targetCategory: snapshot.target.category,
      targetKind: snapshot.target.kind,
      isFavorite: false,
      lastViewedAt: now,
    );
  }

  /// 计算内容唯一 key
  /// 格式：{contentType}|{category_or_kind}|{lookup_key_type}:{lookup_key_value}
  /// 包含 contentType 和 category/kind 避免跨类型冲突
  /// 如果没有有效 lookup key，返回 null
  static String? computeKey(SavedContentSnapshot snapshot) {
    final lookupKey = _buildLookupKey(snapshot.target);
    if (lookupKey == null) return null;

    final type = snapshot.contentType.wireName;
    final qualifier = _buildQualifier(snapshot.contentType, snapshot.target);
    return '$type|$qualifier|$lookupKey';
  }

  /// 计算目标唯一 key
  /// 需要 contentType 来构建完整 key
  static String? computeKeyFromTargetWithType(
    SavedContentType contentType,
    SavedContentTarget target,
  ) {
    final lookupKey = _buildLookupKey(target);
    if (lookupKey == null) return null;

    final type = contentType.wireName;
    final qualifier = _buildQualifier(contentType, target);
    return '$type|$qualifier|$lookupKey';
  }

  /// 计算目标唯一 key（兼容旧接口，缺少 contentType 时仅用 lookup key）
  /// 优先级：target.id > target.sourceUrl > target.sourceId > null
  static String? computeKeyFromTarget(SavedContentTarget target) {
    return target.id ??
        target.sourceUrl ??
        target.sourceId;
  }

  /// 构建 lookup key 部分
  static String? _buildLookupKey(SavedContentTarget target) {
    if (target.id != null && target.id!.isNotEmpty) {
      return 'id:${target.id}';
    }
    if (target.sourceUrl != null && target.sourceUrl!.isNotEmpty) {
      return 'sourceUrl:${target.sourceUrl}';
    }
    if (target.sourceId != null && target.sourceId!.isNotEmpty) {
      return 'sourceId:${target.sourceId}';
    }
    return null;
  }

  /// 构建 qualifier 部分（category 或 kind）
  static String _buildQualifier(
    SavedContentType contentType,
    SavedContentTarget target,
  ) {
    switch (contentType) {
      case SavedContentType.article:
        return target.category?.isNotEmpty == true
            ? target.category!
            : 'unknown';
      case SavedContentType.directoryItem:
        return target.kind?.isNotEmpty == true ? target.kind! : 'unknown';
      case SavedContentType.inheritor:
        return 'default';
    }
  }
}
