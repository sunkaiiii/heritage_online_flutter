// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentDigestDto _$ContentDigestDtoFromJson(Map<String, dynamic> json) =>
    ContentDigestDto(
      type: json['type'] as String? ?? '',
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      quickRead: json['quickRead'] as String?,
      highlights:
          (json['highlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      keyFacts:
          (json['keyFacts'] as List<dynamic>?)
              ?.map((e) => DigestFactDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      readingTimeMinutes: (json['readingTimeMinutes'] as num?)?.toInt() ?? 0,
      sourceUrl: json['sourceUrl'] as String? ?? '',
      generatedAt: json['generatedAt'] as String?,
    );

Map<String, dynamic> _$ContentDigestDtoToJson(ContentDigestDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'title': instance.title,
      'quickRead': instance.quickRead,
      'highlights': instance.highlights,
      'keyFacts': instance.keyFacts,
      'keywords': instance.keywords,
      'readingTimeMinutes': instance.readingTimeMinutes,
      'sourceUrl': instance.sourceUrl,
      'generatedAt': instance.generatedAt,
    };

DigestFactDto _$DigestFactDtoFromJson(Map<String, dynamic> json) =>
    DigestFactDto(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$DigestFactDtoToJson(DigestFactDto instance) =>
    <String, dynamic>{'label': instance.label, 'value': instance.value};
