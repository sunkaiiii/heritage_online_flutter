// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlendedRecommendationResponseDto _$BlendedRecommendationResponseDtoFromJson(
  Map<String, dynamic> json,
) => BlendedRecommendationResponseDto(
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => BlendedRecommendationItemDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  query: json['query'] == null
      ? const BlendedRecommendationQueryDto()
      : BlendedRecommendationQueryDto.fromJson(
          json['query'] as Map<String, dynamic>,
        ),
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$BlendedRecommendationResponseDtoToJson(
  BlendedRecommendationResponseDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'query': instance.query,
  'generatedAt': instance.generatedAt,
};

BlendedRecommendationItemDto _$BlendedRecommendationItemDtoFromJson(
  Map<String, dynamic> json,
) => BlendedRecommendationItemDto(
  id: json['id'] as String? ?? '',
  type: json['type'] as String? ?? '',
  title: json['title'] as String? ?? '',
  subtitle: json['subtitle'] as String?,
  score: (json['score'] as num?)?.toDouble() ?? 0.0,
  reasons:
      (json['reasons'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  scoreBreakdown: json['scoreBreakdown'] == null
      ? const RecommendationScoreBreakdownDto()
      : RecommendationScoreBreakdownDto.fromJson(
          json['scoreBreakdown'] as Map<String, dynamic>,
        ),
  category: json['category'] as String?,
  kind: json['kind'] as String?,
  region: json['region'] as String?,
  coverImage: json['coverImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
  sourceUrl: json['sourceUrl'] as String? ?? '',
  sourceId: json['sourceId'] as String?,
);

Map<String, dynamic> _$BlendedRecommendationItemDtoToJson(
  BlendedRecommendationItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'score': instance.score,
  'reasons': instance.reasons,
  'scoreBreakdown': instance.scoreBreakdown,
  'category': instance.category,
  'kind': instance.kind,
  'region': instance.region,
  'coverImage': instance.coverImage,
  'sourceUrl': instance.sourceUrl,
  'sourceId': instance.sourceId,
};

RecommendationScoreBreakdownDto _$RecommendationScoreBreakdownDtoFromJson(
  Map<String, dynamic> json,
) => RecommendationScoreBreakdownDto(
  explicit: (json['explicit'] as num?)?.toDouble() ?? 0.0,
  inferred: (json['inferred'] as num?)?.toDouble() ?? 0.0,
  embedding: (json['embedding'] as num?)?.toDouble() ?? 0.0,
  sameCategory: (json['sameCategory'] as num?)?.toDouble() ?? 0.0,
  sameRegion: (json['sameRegion'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$RecommendationScoreBreakdownDtoToJson(
  RecommendationScoreBreakdownDto instance,
) => <String, dynamic>{
  'explicit': instance.explicit,
  'inferred': instance.inferred,
  'embedding': instance.embedding,
  'sameCategory': instance.sameCategory,
  'sameRegion': instance.sameRegion,
};

BlendedRecommendationQueryDto _$BlendedRecommendationQueryDtoFromJson(
  Map<String, dynamic> json,
) => BlendedRecommendationQueryDto(
  type: json['type'] as String? ?? '',
  id: json['id'] as String? ?? '',
  limit: (json['limit'] as num?)?.toInt() ?? 10,
  ruleWeight: (json['ruleWeight'] as num?)?.toDouble() ?? 1.0,
  semanticWeight: (json['semanticWeight'] as num?)?.toDouble() ?? 1.0,
  sameCategoryWeight: (json['sameCategoryWeight'] as num?)?.toDouble() ?? 1.0,
  sameRegionWeight: (json['sameRegionWeight'] as num?)?.toDouble() ?? 1.0,
  diversify: json['diversify'] as bool? ?? true,
);

Map<String, dynamic> _$BlendedRecommendationQueryDtoToJson(
  BlendedRecommendationQueryDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'limit': instance.limit,
  'ruleWeight': instance.ruleWeight,
  'semanticWeight': instance.semanticWeight,
  'sameCategoryWeight': instance.sameCategoryWeight,
  'sameRegionWeight': instance.sameRegionWeight,
  'diversify': instance.diversify,
};
