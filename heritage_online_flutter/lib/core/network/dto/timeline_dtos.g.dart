// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineItemDto _$TimelineItemDtoFromJson(Map<String, dynamic> json) =>
    TimelineItemDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      category: json['category'] as String?,
      kind: json['kind'] as String?,
      region: json['region'] as String?,
      date: json['date'] as String?,
      year: (json['year'] as num?)?.toInt(),
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
      sourceId: json['sourceId'] as String?,
    );

Map<String, dynamic> _$TimelineItemDtoToJson(TimelineItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'summary': instance.summary,
      'category': instance.category,
      'kind': instance.kind,
      'region': instance.region,
      'date': instance.date,
      'year': instance.year,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
    };

TimelineYearBucketDto _$TimelineYearBucketDtoFromJson(
  Map<String, dynamic> json,
) => TimelineYearBucketDto(
  year: (json['year'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  articleCount: (json['articleCount'] as num?)?.toInt() ?? 0,
  directoryItemCount: (json['directoryItemCount'] as num?)?.toInt() ?? 0,
  inheritorCount: (json['inheritorCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TimelineYearBucketDtoToJson(
  TimelineYearBucketDto instance,
) => <String, dynamic>{
  'year': instance.year,
  'total': instance.total,
  'articleCount': instance.articleCount,
  'directoryItemCount': instance.directoryItemCount,
  'inheritorCount': instance.inheritorCount,
};

TimelineV2FacetsDto _$TimelineV2FacetsDtoFromJson(Map<String, dynamic> json) =>
    TimelineV2FacetsDto(
      types:
          (json['types'] as List<dynamic>?)
              ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      regions:
          (json['regions'] as List<dynamic>?)
              ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      kinds:
          (json['kinds'] as List<dynamic>?)
              ?.map((e) => FacetBucketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TimelineV2FacetsDtoToJson(
  TimelineV2FacetsDto instance,
) => <String, dynamic>{
  'types': instance.types,
  'categories': instance.categories,
  'regions': instance.regions,
  'kinds': instance.kinds,
};

TimelineV2ResponseDto _$TimelineV2ResponseDtoFromJson(
  Map<String, dynamic> json,
) => TimelineV2ResponseDto(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => TimelineItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  hasMore: json['hasMore'] as bool? ?? false,
  total: (json['total'] as num?)?.toInt() ?? 0,
  facets: json['facets'] == null
      ? null
      : TimelineV2FacetsDto.fromJson(json['facets'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TimelineV2ResponseDtoToJson(
  TimelineV2ResponseDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'hasMore': instance.hasMore,
  'total': instance.total,
  'facets': instance.facets,
};
