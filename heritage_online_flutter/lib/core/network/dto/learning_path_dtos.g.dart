// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_path_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningPathStepDto _$LearningPathStepDtoFromJson(Map<String, dynamic> json) =>
    LearningPathStepDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      topic: json['topic'] == null
          ? null
          : ExploreTopicInfoDto.fromJson(json['topic'] as Map<String, dynamic>),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => ExploreTopicItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$LearningPathStepDtoToJson(
  LearningPathStepDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'topic': instance.topic,
  'items': instance.items,
};

LearningPathDto _$LearningPathDtoFromJson(Map<String, dynamic> json) =>
    LearningPathDto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map(
                (e) => ExploreTopicLinkDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$LearningPathDtoToJson(LearningPathDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'topics': instance.topics,
    };

LearningPathDetailDto _$LearningPathDetailDtoFromJson(
  Map<String, dynamic> json,
) => LearningPathDetailDto(
  id: json['id'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  description: json['description'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => LearningPathStepDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  featuredItems:
      (json['featuredItems'] as List<dynamic>?)
          ?.map((e) => ExploreTopicItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  relatedTopics:
      (json['relatedTopics'] as List<dynamic>?)
          ?.map((e) => ExploreTopicLinkDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  generatedAt: json['generatedAt'] as String?,
);

Map<String, dynamic> _$LearningPathDetailDtoToJson(
  LearningPathDetailDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'description': instance.description,
  'tags': instance.tags,
  'steps': instance.steps,
  'featuredItems': instance.featuredItems,
  'relatedTopics': instance.relatedTopics,
  'generatedAt': instance.generatedAt,
};
