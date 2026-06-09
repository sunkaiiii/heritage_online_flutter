import 'package:json_annotation/json_annotation.dart';

import 'collection_dtos.dart';
import 'common_dtos.dart';
import 'explore_dtos.dart';

part 'context_dtos.g.dart';

/// 推荐项
@JsonSerializable()
class RecommendationDto {
  final String? id;
  final String? type;
  final String? title;
  final String? subtitle;
  final String? source;
  final String? relationType;
  final String? reason;
  final double weight;
  final String? category;
  final String? kind;
  final String? region;
  final String? publishedAt;
  final int? publishedYear;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final String? sourceId;

  const RecommendationDto({
    this.id,
    this.type,
    this.title,
    this.subtitle,
    this.source,
    this.relationType,
    this.reason,
    this.weight = 0.0,
    this.category,
    this.kind,
    this.region,
    this.publishedAt,
    this.publishedYear,
    this.coverImage,
    this.sourceUrl,
    this.sourceId,
  });

  factory RecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$RecommendationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationDtoToJson(this);
}

/// 图节点
@JsonSerializable()
class GraphNodeDto {
  final String? id;
  final String? type;
  final String? title;
  final String? category;
  final String? region;
  final String? sourceUrl;
  final String? subtitle;
  final MediaAssetDto? coverImage;

  const GraphNodeDto({
    this.id,
    this.type,
    this.title,
    this.category,
    this.region,
    this.sourceUrl,
    this.subtitle,
    this.coverImage,
  });

  factory GraphNodeDto.fromJson(Map<String, dynamic> json) =>
      _$GraphNodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GraphNodeDtoToJson(this);
}

/// 图边
@JsonSerializable()
class GraphEdgeDto {
  @JsonKey(name: 'from')
  final String? fromId;
  @JsonKey(name: 'to')
  final String? toId;
  final String? label;
  final String? relationType;
  final String? reason;
  final String? source;
  final double weight;

  const GraphEdgeDto({
    this.fromId,
    this.toId,
    this.label,
    this.relationType,
    this.reason,
    this.source,
    this.weight = 0.0,
  });

  factory GraphEdgeDto.fromJson(Map<String, dynamic> json) =>
      _$GraphEdgeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GraphEdgeDtoToJson(this);
}

/// 图结构
@JsonSerializable()
class GraphDto {
  final List<GraphNodeDto> nodes;
  final List<GraphEdgeDto> edges;

  const GraphDto({
    this.nodes = const [],
    this.edges = const [],
  });

  factory GraphDto.fromJson(Map<String, dynamic> json) =>
      _$GraphDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GraphDtoToJson(this);
}

/// 相关内容摘要
@JsonSerializable()
class RelatedSummaryDto {
  final String? id;
  final String? type;
  final String? title;
  final String? category;
  final String? kind;
  final String? region;
  final String? sourceUrl;
  final String? sourceId;

  const RelatedSummaryDto({
    this.id,
    this.type,
    this.title,
    this.category,
    this.kind,
    this.region,
    this.sourceUrl,
    this.sourceId,
  });

  factory RelatedSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$RelatedSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedSummaryDtoToJson(this);
}

/// Context 中的合集
@JsonSerializable()
class ContextCollectionDto {
  final String? id;
  final String? title;
  final List<CollectionItemDto> items;

  const ContextCollectionDto({
    this.id,
    this.title,
    this.items = const [],
  });

  factory ContextCollectionDto.fromJson(Map<String, dynamic> json) =>
      _$ContextCollectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContextCollectionDtoToJson(this);
}

/// 详情页 Context
@JsonSerializable()
class DetailContextDto {
  final List<RelatedSummaryDto> related;
  final GraphDto? graph;
  final List<ContextCollectionDto> collections;
  final List<ExploreTopicInfoDto> exploreTopics;
  final List<RecommendationDto> recommendations;
  final List<RecommendationDto> semanticRecommendations;

  const DetailContextDto({
    this.related = const [],
    this.graph,
    this.collections = const [],
    this.exploreTopics = const [],
    this.recommendations = const [],
    this.semanticRecommendations = const [],
  });

  factory DetailContextDto.fromJson(Map<String, dynamic> json) =>
      _$DetailContextDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DetailContextDtoToJson(this);
}
