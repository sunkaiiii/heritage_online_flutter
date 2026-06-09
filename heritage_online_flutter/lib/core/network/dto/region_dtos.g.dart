// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionAtlasTotalsDto _$RegionAtlasTotalsDtoFromJson(
  Map<String, dynamic> json,
) => RegionAtlasTotalsDto(
  directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
  inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
  regionCount: (json['regionCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RegionAtlasTotalsDtoToJson(
  RegionAtlasTotalsDto instance,
) => <String, dynamic>{
  'directoryItemCount': instance.directoryItemCount,
  'inheritorCount': instance.inheritorCount,
  'regionCount': instance.regionCount,
};

RegionAtlasItemDto _$RegionAtlasItemDtoFromJson(Map<String, dynamic> json) =>
    RegionAtlasItemDto(
      region: json['region'] as String?,
      displayName: json['displayName'] as String?,
      directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
      inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      topCategories:
          (json['topCategories'] as List<dynamic>?)
              ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topKinds:
          (json['topKinds'] as List<dynamic>?)
              ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegionAtlasItemDtoToJson(RegionAtlasItemDto instance) =>
    <String, dynamic>{
      'region': instance.region,
      'displayName': instance.displayName,
      'directoryItemCount': instance.directoryItemCount,
      'inheritorCount': instance.inheritorCount,
      'total': instance.total,
      'topCategories': instance.topCategories,
      'topKinds': instance.topKinds,
      'coverImage': instance.coverImage,
    };

RegionAtlasDto _$RegionAtlasDtoFromJson(
  Map<String, dynamic> json,
) => RegionAtlasDto(
  regions:
      (json['regions'] as List<dynamic>?)
          ?.map((e) => RegionAtlasItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totals: json['totals'] == null
      ? null
      : RegionAtlasTotalsDto.fromJson(json['totals'] as Map<String, dynamic>),
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$RegionAtlasDtoToJson(RegionAtlasDto instance) =>
    <String, dynamic>{
      'regions': instance.regions,
      'totals': instance.totals,
      'generatedAt': instance.generatedAt,
    };

RegionAtlasDetailStatsDto _$RegionAtlasDetailStatsDtoFromJson(
  Map<String, dynamic> json,
) => RegionAtlasDetailStatsDto(
  directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
  inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RegionAtlasDetailStatsDtoToJson(
  RegionAtlasDetailStatsDto instance,
) => <String, dynamic>{
  'directoryItemCount': instance.directoryItemCount,
  'inheritorCount': instance.inheritorCount,
  'total': instance.total,
};

RegionAtlasDetailDto _$RegionAtlasDetailDtoFromJson(
  Map<String, dynamic> json,
) => RegionAtlasDetailDto(
  region: json['region'] as String?,
  displayName: json['displayName'] as String?,
  stats: json['stats'] == null
      ? null
      : RegionAtlasDetailStatsDto.fromJson(
          json['stats'] as Map<String, dynamic>,
        ),
  categoryBreakdown:
      (json['categoryBreakdown'] as List<dynamic>?)
          ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  kindBreakdown:
      (json['kindBreakdown'] as List<dynamic>?)
          ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  featuredDirectoryItems:
      (json['featuredDirectoryItems'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryItemSummaryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  featuredInheritors:
      (json['featuredInheritors'] as List<dynamic>?)
          ?.map((e) => InheritorSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  relatedArticles:
      (json['relatedArticles'] as List<dynamic>?)
          ?.map((e) => ArticleSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => ExploreTopicItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  relatedRegions:
      (json['relatedRegions'] as List<dynamic>?)
          ?.map((e) => ExploreTopicLinkDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$RegionAtlasDetailDtoToJson(
  RegionAtlasDetailDto instance,
) => <String, dynamic>{
  'region': instance.region,
  'displayName': instance.displayName,
  'stats': instance.stats,
  'categoryBreakdown': instance.categoryBreakdown,
  'kindBreakdown': instance.kindBreakdown,
  'featuredDirectoryItems': instance.featuredDirectoryItems,
  'featuredInheritors': instance.featuredInheritors,
  'relatedArticles': instance.relatedArticles,
  'timeline': instance.timeline,
  'relatedRegions': instance.relatedRegions,
  'generatedAt': instance.generatedAt,
};
