// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedCollectionDto _$FeaturedCollectionDtoFromJson(
  Map<String, dynamic> json,
) => FeaturedCollectionDto(
  id: json['id'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FeaturedCollectionDtoToJson(
  FeaturedCollectionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'itemCount': instance.itemCount,
};

CollectionItemDto _$CollectionItemDtoFromJson(Map<String, dynamic> json) =>
    CollectionItemDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      category: json['category'] as String?,
      region: json['region'] as String?,
      publishedAt: json['publishedAt'] as String?,
      publishedYear: (json['publishedYear'] as num?)?.toInt(),
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
      sourceId: json['sourceId'] as String?,
      kind: json['kind'] as String?,
    );

Map<String, dynamic> _$CollectionItemDtoToJson(CollectionItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'summary': instance.summary,
      'category': instance.category,
      'region': instance.region,
      'publishedAt': instance.publishedAt,
      'publishedYear': instance.publishedYear,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
      'kind': instance.kind,
    };

CollectionDto _$CollectionDtoFromJson(Map<String, dynamic> json) =>
    CollectionDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      type: json['type'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      generatedAt: json['generatedAt'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => CollectionItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CollectionDtoToJson(CollectionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'type': instance.type,
      'tags': instance.tags,
      'generatedAt': instance.generatedAt,
      'items': instance.items,
    };
