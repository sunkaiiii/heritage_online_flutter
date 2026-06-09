// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataStoryDto _$DataStoryDtoFromJson(Map<String, dynamic> json) => DataStoryDto(
  id: json['id'] as String? ?? '',
  title: json['title'] as String? ?? '',
  subtitle: json['subtitle'] as String?,
  heroImage: json['heroImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['heroImage'] as Map<String, dynamic>),
  sections:
      (json['sections'] as List<dynamic>?)
          ?.map((e) => DataStorySectionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  relatedTopics:
      (json['relatedTopics'] as List<dynamic>?)
          ?.map((e) => ExploreTopicInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$DataStoryDtoToJson(DataStoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'heroImage': instance.heroImage,
      'sections': instance.sections,
      'relatedTopics': instance.relatedTopics,
      'generatedAt': instance.generatedAt,
    };

DataStorySectionDto _$DataStorySectionDtoFromJson(Map<String, dynamic> json) =>
    DataStorySectionDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      body: json['body'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => DataStoryItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DataStorySectionDtoToJson(
  DataStorySectionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'body': instance.body,
  'items': instance.items,
};

DataStoryItemDto _$DataStoryItemDtoFromJson(Map<String, dynamic> json) =>
    DataStoryItemDto(
      type: json['type'] as String? ?? '',
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String? ?? '',
      sourceId: json['sourceId'] as String?,
    );

Map<String, dynamic> _$DataStoryItemDtoToJson(DataStoryItemDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'sourceId': instance.sourceId,
    };
