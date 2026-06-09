import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';

part 'recommendation_dtos.g.dart';

/// 综合推荐响应
@JsonSerializable()
class BlendedRecommendationResponseDto {
  final List<BlendedRecommendationItemDto> items;
  final BlendedRecommendationQueryDto query;
  final String? generatedAt;

  const BlendedRecommendationResponseDto({
    this.items = const [],
    this.query = const BlendedRecommendationQueryDto(),
    this.generatedAt,
  });

  factory BlendedRecommendationResponseDto.fromJson(
          Map<String, dynamic> json) =>
      _$BlendedRecommendationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$BlendedRecommendationResponseDtoToJson(this);
}

/// 综合推荐条目
@JsonSerializable()
class BlendedRecommendationItemDto {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final double score;
  final List<String> reasons;
  final RecommendationScoreBreakdownDto scoreBreakdown;
  final String? category;
  final String? kind;
  final String? region;
  final MediaAssetDto? coverImage;
  final String sourceUrl;
  final String? sourceId;

  const BlendedRecommendationItemDto({
    this.id = '',
    this.type = '',
    this.title = '',
    this.subtitle,
    this.score = 0.0,
    this.reasons = const [],
    this.scoreBreakdown = const RecommendationScoreBreakdownDto(),
    this.category,
    this.kind,
    this.region,
    this.coverImage,
    this.sourceUrl = '',
    this.sourceId,
  });

  factory BlendedRecommendationItemDto.fromJson(Map<String, dynamic> json) =>
      _$BlendedRecommendationItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BlendedRecommendationItemDtoToJson(this);
}

/// 推荐得分分解
@JsonSerializable()
class RecommendationScoreBreakdownDto {
  final double explicit;
  final double inferred;
  final double embedding;
  final double sameCategory;
  final double sameRegion;

  const RecommendationScoreBreakdownDto({
    this.explicit = 0.0,
    this.inferred = 0.0,
    this.embedding = 0.0,
    this.sameCategory = 0.0,
    this.sameRegion = 0.0,
  });

  factory RecommendationScoreBreakdownDto.fromJson(
          Map<String, dynamic> json) =>
      _$RecommendationScoreBreakdownDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RecommendationScoreBreakdownDtoToJson(this);
}

/// 综合推荐查询参数
@JsonSerializable()
class BlendedRecommendationQueryDto {
  final String type;
  final String id;
  final int limit;
  final double ruleWeight;
  final double semanticWeight;
  final double sameCategoryWeight;
  final double sameRegionWeight;
  final bool diversify;

  const BlendedRecommendationQueryDto({
    this.type = '',
    this.id = '',
    this.limit = 10,
    this.ruleWeight = 1.0,
    this.semanticWeight = 1.0,
    this.sameCategoryWeight = 1.0,
    this.sameRegionWeight = 1.0,
    this.diversify = true,
  });

  factory BlendedRecommendationQueryDto.fromJson(Map<String, dynamic> json) =>
      _$BlendedRecommendationQueryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BlendedRecommendationQueryDtoToJson(this);
}
