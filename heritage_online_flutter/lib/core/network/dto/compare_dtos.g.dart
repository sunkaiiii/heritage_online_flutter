// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompareResultDto _$CompareResultDtoFromJson(
  Map<String, dynamic> json,
) => CompareResultDto(
  left: json['left'] == null
      ? const CompareSideDto()
      : CompareSideDto.fromJson(json['left'] as Map<String, dynamic>),
  right: json['right'] == null
      ? const CompareSideDto()
      : CompareSideDto.fromJson(json['right'] as Map<String, dynamic>),
  summary: json['summary'] == null
      ? const CompareSummaryDto()
      : CompareSummaryDto.fromJson(json['summary'] as Map<String, dynamic>),
  sharedCategories:
      (json['sharedCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  leftUniqueCategories:
      (json['leftUniqueCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  rightUniqueCategories:
      (json['rightUniqueCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sharedRegions:
      (json['sharedRegions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  leftUniqueRegions:
      (json['leftUniqueRegions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  rightUniqueRegions:
      (json['rightUniqueRegions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  leftFeaturedItems:
      (json['leftFeaturedItems'] as List<dynamic>?)
          ?.map((e) => CollectionItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  rightFeaturedItems:
      (json['rightFeaturedItems'] as List<dynamic>?)
          ?.map((e) => CollectionItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$CompareResultDtoToJson(CompareResultDto instance) =>
    <String, dynamic>{
      'left': instance.left,
      'right': instance.right,
      'summary': instance.summary,
      'sharedCategories': instance.sharedCategories,
      'leftUniqueCategories': instance.leftUniqueCategories,
      'rightUniqueCategories': instance.rightUniqueCategories,
      'sharedRegions': instance.sharedRegions,
      'leftUniqueRegions': instance.leftUniqueRegions,
      'rightUniqueRegions': instance.rightUniqueRegions,
      'leftFeaturedItems': instance.leftFeaturedItems,
      'rightFeaturedItems': instance.rightFeaturedItems,
      'generatedAt': instance.generatedAt,
    };

CompareSideDto _$CompareSideDtoFromJson(Map<String, dynamic> json) =>
    CompareSideDto(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
      inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
      articleCount: (json['articleCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      topCategories:
          (json['topCategories'] as List<dynamic>?)
              ?.map(
                (e) => TaxonomyCategoryCountDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      topRegions:
          (json['topRegions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TaxonomyRegionCountDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CompareSideDtoToJson(CompareSideDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'directoryItemCount': instance.directoryItemCount,
      'inheritorCount': instance.inheritorCount,
      'articleCount': instance.articleCount,
      'total': instance.total,
      'topCategories': instance.topCategories,
      'topRegions': instance.topRegions,
    };

CompareSummaryDto _$CompareSummaryDtoFromJson(Map<String, dynamic> json) =>
    CompareSummaryDto(
      leftTotal: (json['leftTotal'] as num?)?.toInt() ?? 0,
      rightTotal: (json['rightTotal'] as num?)?.toInt() ?? 0,
      sharedCategoryCount: (json['sharedCategoryCount'] as num?)?.toInt() ?? 0,
      leftUniqueCategoryCount:
          (json['leftUniqueCategoryCount'] as num?)?.toInt() ?? 0,
      rightUniqueCategoryCount:
          (json['rightUniqueCategoryCount'] as num?)?.toInt() ?? 0,
      sharedRegionCount: (json['sharedRegionCount'] as num?)?.toInt() ?? 0,
      leftUniqueRegionCount:
          (json['leftUniqueRegionCount'] as num?)?.toInt() ?? 0,
      rightUniqueRegionCount:
          (json['rightUniqueRegionCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CompareSummaryDtoToJson(CompareSummaryDto instance) =>
    <String, dynamic>{
      'leftTotal': instance.leftTotal,
      'rightTotal': instance.rightTotal,
      'sharedCategoryCount': instance.sharedCategoryCount,
      'leftUniqueCategoryCount': instance.leftUniqueCategoryCount,
      'rightUniqueCategoryCount': instance.rightUniqueCategoryCount,
      'sharedRegionCount': instance.sharedRegionCount,
      'leftUniqueRegionCount': instance.leftUniqueRegionCount,
      'rightUniqueRegionCount': instance.rightUniqueRegionCount,
    };
