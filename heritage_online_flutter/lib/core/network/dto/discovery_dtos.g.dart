// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoveryItemDto _$DiscoveryItemDtoFromJson(Map<String, dynamic> json) =>
    DiscoveryItemDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      category: json['category'] as String?,
      region: json['region'] as String?,
      kind: json['kind'] as String?,
      publishedYear: (json['publishedYear'] as num?)?.toInt(),
      publishedAt: json['publishedAt'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
      sourceId: json['sourceId'] as String?,
    );

Map<String, dynamic> _$DiscoveryItemDtoToJson(DiscoveryItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'summary': instance.summary,
      'category': instance.category,
      'region': instance.region,
      'kind': instance.kind,
      'publishedYear': instance.publishedYear,
      'publishedAt': instance.publishedAt,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
    };

DiscoveryTodayDto _$DiscoveryTodayDtoFromJson(Map<String, dynamic> json) =>
    DiscoveryTodayDto(
      featuredDirectoryItem: json['featuredDirectoryItem'] == null
          ? null
          : DiscoveryItemDto.fromJson(
              json['featuredDirectoryItem'] as Map<String, dynamic>,
            ),
      featuredInheritor: json['featuredInheritor'] == null
          ? null
          : DiscoveryItemDto.fromJson(
              json['featuredInheritor'] as Map<String, dynamic>,
            ),
      articles:
          (json['articles'] as List<dynamic>?)
              ?.map((e) => DiscoveryItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DiscoveryTodayDtoToJson(DiscoveryTodayDto instance) =>
    <String, dynamic>{
      'featuredDirectoryItem': instance.featuredDirectoryItem,
      'featuredInheritor': instance.featuredInheritor,
      'articles': instance.articles,
    };

DiscoveryTrendingDto _$DiscoveryTrendingDtoFromJson(
  Map<String, dynamic> json,
) => DiscoveryTrendingDto(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => DiscoveryItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DiscoveryTrendingDtoToJson(
  DiscoveryTrendingDto instance,
) => <String, dynamic>{'items': instance.items};

DiscoveryWeeklySectionDto _$DiscoveryWeeklySectionDtoFromJson(
  Map<String, dynamic> json,
) => DiscoveryWeeklySectionDto(
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => DiscoveryItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DiscoveryWeeklySectionDtoToJson(
  DiscoveryWeeklySectionDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'subtitle': instance.subtitle,
  'items': instance.items,
};

DiscoveryWeeklyDto _$DiscoveryWeeklyDtoFromJson(Map<String, dynamic> json) =>
    DiscoveryWeeklyDto(
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map(
                (e) => DiscoveryWeeklySectionDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DiscoveryWeeklyDtoToJson(DiscoveryWeeklyDto instance) =>
    <String, dynamic>{'sections': instance.sections};
