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
  factory SavedContentEntity.fromSnapshot(SavedContentSnapshot snapshot) {
    final key = computeKey(snapshot);
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
  /// 优先级：target.id > target.sourceUrl > target.sourceId > 'unknown'
  static String computeKey(SavedContentSnapshot snapshot) {
    return snapshot.target.id ??
        snapshot.target.sourceUrl ??
        snapshot.target.sourceId ??
        'unknown';
  }

  /// 计算目标唯一 key
  /// 优先级：target.id > target.sourceUrl > target.sourceId > 'unknown'
  static String computeKeyFromTarget(SavedContentTarget target) {
    return target.id ??
        target.sourceUrl ??
        target.sourceId ??
        'unknown';
  }
}
