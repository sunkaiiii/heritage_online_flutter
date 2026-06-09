// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxonomy_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaxonomyTopicDto _$TaxonomyTopicDtoFromJson(Map<String, dynamic> json) =>
    TaxonomyTopicDto(
      type: json['type'] as String? ?? '',
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
      inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
      articleCount: (json['articleCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      topRegions:
          (json['topRegions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TaxonomyRegionCountDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      topCategories:
          (json['topCategories'] as List<dynamic>?)
              ?.map(
                (e) => TaxonomyCategoryCountDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaxonomyTopicDtoToJson(TaxonomyTopicDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'key': instance.key,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'directoryItemCount': instance.directoryItemCount,
      'inheritorCount': instance.inheritorCount,
      'articleCount': instance.articleCount,
      'total': instance.total,
      'topRegions': instance.topRegions,
      'topCategories': instance.topCategories,
      'coverImage': instance.coverImage,
    };

TaxonomyRegionCountDto _$TaxonomyRegionCountDtoFromJson(
  Map<String, dynamic> json,
) => TaxonomyRegionCountDto(
  region: json['region'] as String? ?? '',
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaxonomyRegionCountDtoToJson(
  TaxonomyRegionCountDto instance,
) => <String, dynamic>{'region': instance.region, 'count': instance.count};

TaxonomyCategoryCountDto _$TaxonomyCategoryCountDtoFromJson(
  Map<String, dynamic> json,
) => TaxonomyCategoryCountDto(
  category: json['category'] as String? ?? '',
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaxonomyCategoryCountDtoToJson(
  TaxonomyCategoryCountDto instance,
) => <String, dynamic>{'category': instance.category, 'count': instance.count};

TaxonomyKindDto _$TaxonomyKindDtoFromJson(Map<String, dynamic> json) =>
    TaxonomyKindDto(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
      inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TaxonomyKindDtoToJson(TaxonomyKindDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'directoryItemCount': instance.directoryItemCount,
      'inheritorCount': instance.inheritorCount,
      'total': instance.total,
    };

TaxonomyIndexDto<T> _$TaxonomyIndexDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => TaxonomyIndexDto<T>(
  items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$TaxonomyIndexDtoToJson<T>(
  TaxonomyIndexDto<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'generatedAt': instance.generatedAt,
};

TaxonomyStatDto _$TaxonomyStatDtoFromJson(Map<String, dynamic> json) =>
    TaxonomyStatDto(
      directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
      inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
      articleCount: (json['articleCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TaxonomyStatDtoToJson(TaxonomyStatDto instance) =>
    <String, dynamic>{
      'directoryItemCount': instance.directoryItemCount,
      'inheritorCount': instance.inheritorCount,
      'articleCount': instance.articleCount,
      'total': instance.total,
    };

TaxonomyCategoryDetailDto _$TaxonomyCategoryDetailDtoFromJson(
  Map<String, dynamic> json,
) => TaxonomyCategoryDetailDto(
  topic: json['topic'] == null
      ? const TaxonomyTopicDto()
      : TaxonomyTopicDto.fromJson(json['topic'] as Map<String, dynamic>),
  stats: json['stats'] == null
      ? const TaxonomyStatDto()
      : TaxonomyStatDto.fromJson(json['stats'] as Map<String, dynamic>),
  topRegions:
      (json['topRegions'] as List<dynamic>?)
          ?.map(
            (e) => TaxonomyRegionCountDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  articles:
      (json['articles'] as List<dynamic>?)
          ?.map((e) => ArticleSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  directoryItems:
      (json['directoryItems'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryItemSummaryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  inheritors:
      (json['inheritors'] as List<dynamic>?)
          ?.map((e) => InheritorSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  relatedCategories:
      (json['relatedCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  recommendedCollections:
      (json['recommendedCollections'] as List<dynamic>?)
          ?.map((e) => CollectionItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$TaxonomyCategoryDetailDtoToJson(
  TaxonomyCategoryDetailDto instance,
) => <String, dynamic>{
  'topic': instance.topic,
  'stats': instance.stats,
  'topRegions': instance.topRegions,
  'articles': instance.articles,
  'directoryItems': instance.directoryItems,
  'inheritors': instance.inheritors,
  'relatedCategories': instance.relatedCategories,
  'recommendedCollections': instance.recommendedCollections,
  'generatedAt': instance.generatedAt,
};

TaxonomyRegionDetailDto _$TaxonomyRegionDetailDtoFromJson(
  Map<String, dynamic> json,
) => TaxonomyRegionDetailDto(
  topic: json['topic'] == null
      ? const TaxonomyTopicDto()
      : TaxonomyTopicDto.fromJson(json['topic'] as Map<String, dynamic>),
  stats: json['stats'] == null
      ? const TaxonomyStatDto()
      : TaxonomyStatDto.fromJson(json['stats'] as Map<String, dynamic>),
  topCategories:
      (json['topCategories'] as List<dynamic>?)
          ?.map(
            (e) => TaxonomyCategoryCountDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  articles:
      (json['articles'] as List<dynamic>?)
          ?.map((e) => ArticleSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  directoryItems:
      (json['directoryItems'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryItemSummaryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  inheritors:
      (json['inheritors'] as List<dynamic>?)
          ?.map((e) => InheritorSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  relatedRegions:
      (json['relatedRegions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  recommendedCollections:
      (json['recommendedCollections'] as List<dynamic>?)
          ?.map((e) => CollectionItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$TaxonomyRegionDetailDtoToJson(
  TaxonomyRegionDetailDto instance,
) => <String, dynamic>{
  'topic': instance.topic,
  'stats': instance.stats,
  'topCategories': instance.topCategories,
  'articles': instance.articles,
  'directoryItems': instance.directoryItems,
  'inheritors': instance.inheritors,
  'relatedRegions': instance.relatedRegions,
  'recommendedCollections': instance.recommendedCollections,
  'generatedAt': instance.generatedAt,
};
