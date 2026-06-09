// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExploreTopicInfoDto _$ExploreTopicInfoDtoFromJson(Map<String, dynamic> json) =>
    ExploreTopicInfoDto(
      type: json['type'] as String?,
      key: json['key'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
    );

Map<String, dynamic> _$ExploreTopicInfoDtoToJson(
  ExploreTopicInfoDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'key': instance.key,
  'title': instance.title,
  'subtitle': instance.subtitle,
};

ExploreTopicItemDto _$ExploreTopicItemDtoFromJson(Map<String, dynamic> json) =>
    ExploreTopicItemDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      category: json['category'] as String?,
      region: json['region'] as String?,
      kind: json['kind'] as String?,
      year: (json['year'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
    );

Map<String, dynamic> _$ExploreTopicItemDtoToJson(
  ExploreTopicItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'summary': instance.summary,
  'category': instance.category,
  'region': instance.region,
  'kind': instance.kind,
  'year': instance.year,
  'count': instance.count,
  'coverImage': instance.coverImage,
  'sourceUrl': instance.sourceUrl,
};

ExploreTopicSectionDto _$ExploreTopicSectionDtoFromJson(
  Map<String, dynamic> json,
) => ExploreTopicSectionDto(
  id: json['id'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ExploreTopicItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExploreTopicSectionDtoToJson(
  ExploreTopicSectionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'items': instance.items,
};

ExploreTopicStatDto _$ExploreTopicStatDtoFromJson(Map<String, dynamic> json) =>
    ExploreTopicStatDto(
      name: json['name'] as String?,
      value: (json['value'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ExploreTopicStatDtoToJson(
  ExploreTopicStatDto instance,
) => <String, dynamic>{'name': instance.name, 'value': instance.value};

ExploreTopicV2Dto _$ExploreTopicV2DtoFromJson(
  Map<String, dynamic> json,
) => ExploreTopicV2Dto(
  topic: json['topic'] == null
      ? null
      : ExploreTopicInfoDto.fromJson(json['topic'] as Map<String, dynamic>),
  stats:
      (json['stats'] as List<dynamic>?)
          ?.map((e) => ExploreTopicStatDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map(
            (e) => ExploreTopicSectionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  relatedTopics:
      (json['relatedTopics'] as List<dynamic>?)
          ?.map((e) => ExploreTopicLinkDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => ExploreTopicItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$ExploreTopicV2DtoToJson(ExploreTopicV2Dto instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'stats': instance.stats,
      'sections': instance.sections,
      'relatedTopics': instance.relatedTopics,
      'timeline': instance.timeline,
      'generatedAt': instance.generatedAt,
    };

ExploreIndexDto _$ExploreIndexDtoFromJson(
  Map<String, dynamic> json,
) => ExploreIndexDto(
  regions:
      (json['regions'] as List<dynamic>?)
          ?.map((e) => ExploreTopicInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => ExploreTopicInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  years:
      (json['years'] as List<dynamic>?)
          ?.map((e) => ExploreTopicInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExploreIndexDtoToJson(ExploreIndexDto instance) =>
    <String, dynamic>{
      'regions': instance.regions,
      'categories': instance.categories,
      'years': instance.years,
    };
