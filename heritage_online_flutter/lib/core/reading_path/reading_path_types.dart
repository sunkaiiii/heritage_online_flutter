import 'package:uuid/uuid.dart';

/// 阅读路径来源
enum ReadingPathSource {
  blendedRecommendation('blendedRecommendation'),
  related('related'),
  recommendation('recommendation'),
  semanticRecommendation('semanticRecommendation'),
  graph('graph'),
  list('list');

  final String wireName;
  const ReadingPathSource(this.wireName);

  static ReadingPathSource fromWireName(String? value) {
    switch (value) {
      case 'blendedRecommendation':
        return ReadingPathSource.blendedRecommendation;
      case 'related':
        return ReadingPathSource.related;
      case 'recommendation':
        return ReadingPathSource.recommendation;
      case 'semanticRecommendation':
        return ReadingPathSource.semanticRecommendation;
      case 'graph':
        return ReadingPathSource.graph;
      case 'list':
        return ReadingPathSource.list;
      default:
        return ReadingPathSource.list;
    }
  }
}

/// 阅读路径内容引用
class ReadingPathContentRef {
  final String type;
  final String id;
  final String title;
  final String? category;
  final String? kind;
  final String? sourceId;
  final String? sourceUrl;
  final String? subtitle;
  final String? imageUrl;

  const ReadingPathContentRef({
    required this.type,
    required this.id,
    required this.title,
    this.category,
    this.kind,
    this.sourceId,
    this.sourceUrl,
    this.subtitle,
    this.imageUrl,
  });
}

/// 阅读路径事件
class ReadingPathEvent {
  final String id;
  final String? fromType;
  final String? fromId;
  final String? fromTitle;
  final String toType;
  final String toId;
  final String? toTitle;
  final String source;
  final String? toCategory;
  final String? toKind;
  final String? toSourceId;
  final String? toSourceUrl;
  final String? toSubtitle;
  final String? toImageUrl;
  final int createdAt;

  ReadingPathEvent({
    String? id,
    this.fromType,
    this.fromId,
    this.fromTitle,
    required this.toType,
    required this.toId,
    this.toTitle,
    required this.source,
    this.toCategory,
    this.toKind,
    this.toSourceId,
    this.toSourceUrl,
    this.toSubtitle,
    this.toImageUrl,
    int? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  ReadingPathEvent copyWith({
    String? id,
    String? fromType,
    String? fromId,
    String? fromTitle,
    String? toType,
    String? toId,
    String? toTitle,
    String? source,
    String? toCategory,
    String? toKind,
    String? toSourceId,
    String? toSourceUrl,
    String? toSubtitle,
    String? toImageUrl,
    int? createdAt,
  }) {
    return ReadingPathEvent(
      id: id ?? this.id,
      fromType: fromType ?? this.fromType,
      fromId: fromId ?? this.fromId,
      fromTitle: fromTitle ?? this.fromTitle,
      toType: toType ?? this.toType,
      toId: toId ?? this.toId,
      toTitle: toTitle ?? this.toTitle,
      source: source ?? this.source,
      toCategory: toCategory ?? this.toCategory,
      toKind: toKind ?? this.toKind,
      toSourceId: toSourceId ?? this.toSourceId,
      toSourceUrl: toSourceUrl ?? this.toSourceUrl,
      toSubtitle: toSubtitle ?? this.toSubtitle,
      toImageUrl: toImageUrl ?? this.toImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 从 Map 创建
  factory ReadingPathEvent.fromMap(Map<String, dynamic> map) {
    return ReadingPathEvent(
      id: map['id'],
      fromType: map['fromType'],
      fromId: map['fromId'],
      fromTitle: map['fromTitle'],
      toType: map['toType'] ?? '',
      toId: map['toId'] ?? '',
      toTitle: map['toTitle'],
      source: map['source'] ?? 'list',
      toCategory: map['toCategory'],
      toKind: map['toKind'],
      toSourceId: map['toSourceId'],
      toSourceUrl: map['toSourceUrl'],
      toSubtitle: map['toSubtitle'],
      toImageUrl: map['toImageUrl'],
      createdAt: map['createdAt'],
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromType': fromType,
      'fromId': fromId,
      'fromTitle': fromTitle,
      'toType': toType,
      'toId': toId,
      'toTitle': toTitle,
      'source': source,
      'toCategory': toCategory,
      'toKind': toKind,
      'toSourceId': toSourceId,
      'toSourceUrl': toSourceUrl,
      'toSubtitle': toSubtitle,
      'toImageUrl': toImageUrl,
      'createdAt': createdAt,
    };
  }
}
