// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedResult<T> _$PagedResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PagedResult<T>(
  items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  hasMore: json['hasMore'] as bool? ?? false,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PagedResultToJson<T>(
  PagedResult<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'page': instance.page,
  'pageSize': instance.pageSize,
  'hasMore': instance.hasMore,
  'total': instance.total,
};

MediaAssetDto _$MediaAssetDtoFromJson(Map<String, dynamic> json) =>
    MediaAssetDto(
      sourceUrl: json['sourceUrl'] as String?,
      originalUrl: json['originalUrl'] as String?,
      displayUrl: json['displayUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      altText: json['altText'] as String?,
    );

Map<String, dynamic> _$MediaAssetDtoToJson(MediaAssetDto instance) =>
    <String, dynamic>{
      'sourceUrl': instance.sourceUrl,
      'originalUrl': instance.originalUrl,
      'displayUrl': instance.displayUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'altText': instance.altText,
    };

ProblemDetailsDto _$ProblemDetailsDtoFromJson(Map<String, dynamic> json) =>
    ProblemDetailsDto(
      type: json['type'] as String?,
      title: json['title'] as String?,
      status: (json['status'] as num?)?.toInt(),
      detail: json['detail'] as String?,
      instance: json['instance'] as String?,
    );

Map<String, dynamic> _$ProblemDetailsDtoToJson(ProblemDetailsDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'status': instance.status,
      'detail': instance.detail,
      'instance': instance.instance,
    };

FacetBucketDto _$FacetBucketDtoFromJson(Map<String, dynamic> json) =>
    FacetBucketDto(
      key: json['key'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FacetBucketDtoToJson(FacetBucketDto instance) =>
    <String, dynamic>{'key': instance.key, 'count': instance.count};

ExploreTopicLinkDto _$ExploreTopicLinkDtoFromJson(Map<String, dynamic> json) =>
    ExploreTopicLinkDto(
      type: json['type'] as String?,
      key: json['key'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ExploreTopicLinkDtoToJson(
  ExploreTopicLinkDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'key': instance.key,
  'title': instance.title,
};
