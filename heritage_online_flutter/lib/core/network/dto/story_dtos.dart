import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';
import 'explore_dtos.dart';

part 'story_dtos.g.dart';

/// 数据故事
@JsonSerializable()
class DataStoryDto {
  final String id;
  final String title;
  final String? subtitle;
  final MediaAssetDto? heroImage;
  final List<DataStorySectionDto> sections;
  final List<ExploreTopicInfoDto> relatedTopics;
  final String? generatedAt;

  const DataStoryDto({
    this.id = '',
    this.title = '',
    this.subtitle,
    this.heroImage,
    this.sections = const [],
    this.relatedTopics = const [],
    this.generatedAt,
  });

  factory DataStoryDto.fromJson(Map<String, dynamic> json) =>
      _$DataStoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataStoryDtoToJson(this);
}

/// 数据故事区块
@JsonSerializable()
class DataStorySectionDto {
  final String id;
  final String title;
  final String type;
  final String? body;
  final List<DataStoryItemDto> items;

  const DataStorySectionDto({
    this.id = '',
    this.title = '',
    this.type = '',
    this.body,
    this.items = const [],
  });

  factory DataStorySectionDto.fromJson(Map<String, dynamic> json) =>
      _$DataStorySectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataStorySectionDtoToJson(this);
}

/// 数据故事条目
@JsonSerializable()
class DataStoryItemDto {
  final String type;
  final String? id;
  final String title;
  final String? summary;
  final MediaAssetDto? coverImage;
  final String sourceUrl;
  final String? sourceId;

  const DataStoryItemDto({
    this.type = '',
    this.id,
    this.title = '',
    this.summary,
    this.coverImage,
    this.sourceUrl = '',
    this.sourceId,
  });

  factory DataStoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$DataStoryItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataStoryItemDtoToJson(this);
}
