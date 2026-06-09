// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationDto _$RecommendationDtoFromJson(Map<String, dynamic> json) =>
    RecommendationDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      source: json['source'] as String?,
      relationType: json['relationType'] as String?,
      reason: json['reason'] as String?,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String?,
      kind: json['kind'] as String?,
      region: json['region'] as String?,
      publishedAt: json['publishedAt'] as String?,
      publishedYear: (json['publishedYear'] as num?)?.toInt(),
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
      sourceId: json['sourceId'] as String?,
    );

Map<String, dynamic> _$RecommendationDtoToJson(RecommendationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'source': instance.source,
      'relationType': instance.relationType,
      'reason': instance.reason,
      'weight': instance.weight,
      'category': instance.category,
      'kind': instance.kind,
      'region': instance.region,
      'publishedAt': instance.publishedAt,
      'publishedYear': instance.publishedYear,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
    };

GraphNodeDto _$GraphNodeDtoFromJson(Map<String, dynamic> json) => GraphNodeDto(
  id: json['id'] as String?,
  type: json['type'] as String?,
  title: json['title'] as String?,
  category: json['category'] as String?,
  region: json['region'] as String?,
  sourceUrl: json['sourceUrl'] as String?,
  subtitle: json['subtitle'] as String?,
  coverImage: json['coverImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GraphNodeDtoToJson(GraphNodeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'category': instance.category,
      'region': instance.region,
      'sourceUrl': instance.sourceUrl,
      'subtitle': instance.subtitle,
      'coverImage': instance.coverImage,
    };

GraphEdgeDto _$GraphEdgeDtoFromJson(Map<String, dynamic> json) => GraphEdgeDto(
  fromId: json['from'] as String?,
  toId: json['to'] as String?,
  label: json['label'] as String?,
  relationType: json['relationType'] as String?,
  reason: json['reason'] as String?,
  source: json['source'] as String?,
  weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$GraphEdgeDtoToJson(GraphEdgeDto instance) =>
    <String, dynamic>{
      'from': instance.fromId,
      'to': instance.toId,
      'label': instance.label,
      'relationType': instance.relationType,
      'reason': instance.reason,
      'source': instance.source,
      'weight': instance.weight,
    };

GraphDto _$GraphDtoFromJson(Map<String, dynamic> json) => GraphDto(
  nodes:
      (json['nodes'] as List<dynamic>?)
          ?.map((e) => GraphNodeDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => GraphEdgeDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GraphDtoToJson(GraphDto instance) => <String, dynamic>{
  'nodes': instance.nodes,
  'edges': instance.edges,
};

RelatedSummaryDto _$RelatedSummaryDtoFromJson(Map<String, dynamic> json) =>
    RelatedSummaryDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      kind: json['kind'] as String?,
      region: json['region'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      sourceId: json['sourceId'] as String?,
    );

Map<String, dynamic> _$RelatedSummaryDtoToJson(RelatedSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'category': instance.category,
      'kind': instance.kind,
      'region': instance.region,
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
    };

ContextCollectionDto _$ContextCollectionDtoFromJson(
  Map<String, dynamic> json,
) => ContextCollectionDto(
  id: json['id'] as String?,
  title: json['title'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CollectionItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ContextCollectionDtoToJson(
  ContextCollectionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'items': instance.items,
};

DetailContextDto _$DetailContextDtoFromJson(
  Map<String, dynamic> json,
) => DetailContextDto(
  related:
      (json['related'] as List<dynamic>?)
          ?.map((e) => RelatedSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  graph: json['graph'] == null
      ? null
      : GraphDto.fromJson(json['graph'] as Map<String, dynamic>),
  collections:
      (json['collections'] as List<dynamic>?)
          ?.map((e) => ContextCollectionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  exploreTopics:
      (json['exploreTopics'] as List<dynamic>?)
          ?.map((e) => ExploreTopicInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => RecommendationDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  semanticRecommendations:
      (json['semanticRecommendations'] as List<dynamic>?)
          ?.map((e) => RecommendationDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DetailContextDtoToJson(DetailContextDto instance) =>
    <String, dynamic>{
      'related': instance.related,
      'graph': instance.graph,
      'collections': instance.collections,
      'exploreTopics': instance.exploreTopics,
      'recommendations': instance.recommendations,
      'semanticRecommendations': instance.semanticRecommendations,
    };
