import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';

part 'explore_dtos.g.dart';

/// 探索主题信息
@JsonSerializable()
class ExploreTopicInfoDto {
  final String? type;
  final String? key;
  final String? title;
  final String? subtitle;

  const ExploreTopicInfoDto({
    this.type,
    this.key,
    this.title,
    this.subtitle,
  });

  factory ExploreTopicInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreTopicInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreTopicInfoDtoToJson(this);
}

/// 探索主题项
@JsonSerializable()
class ExploreTopicItemDto {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? category;
  final String? region;
  final String? kind;
  final int? year;
  final int? count;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;

  const ExploreTopicItemDto({
    this.id,
    this.type,
    this.title,
    this.summary,
    this.category,
    this.region,
    this.kind,
    this.year,
    this.count,
    this.coverImage,
    this.sourceUrl,
  });

  factory ExploreTopicItemDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreTopicItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreTopicItemDtoToJson(this);
}

/// 探索主题区块
@JsonSerializable()
class ExploreTopicSectionDto {
  final String? id;
  final String? title;
  final String? subtitle;
  final List<ExploreTopicItemDto> items;

  const ExploreTopicSectionDto({
    this.id,
    this.title,
    this.subtitle,
    this.items = const [],
  });

  factory ExploreTopicSectionDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreTopicSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreTopicSectionDtoToJson(this);
}

/// 探索主题统计
@JsonSerializable()
class ExploreTopicStatDto {
  final String? name;
  final int value;

  const ExploreTopicStatDto({
    this.name,
    this.value = 0,
  });

  factory ExploreTopicStatDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreTopicStatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreTopicStatDtoToJson(this);
}

/// 探索主题详情
@JsonSerializable()
class ExploreTopicV2Dto {
  final ExploreTopicInfoDto? topic;
  final List<ExploreTopicStatDto> stats;
  final List<ExploreTopicSectionDto> sections;
  final List<ExploreTopicLinkDto> relatedTopics;
  final List<ExploreTopicItemDto> timeline;
  final String? generatedAt;

  const ExploreTopicV2Dto({
    this.topic,
    this.stats = const [],
    this.sections = const [],
    this.relatedTopics = const [],
    this.timeline = const [],
    this.generatedAt,
  });

  factory ExploreTopicV2Dto.fromJson(Map<String, dynamic> json) =>
      _$ExploreTopicV2DtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreTopicV2DtoToJson(this);
}

/// 探索索引
@JsonSerializable()
class ExploreIndexDto {
  final List<ExploreTopicInfoDto> regions;
  final List<ExploreTopicInfoDto> categories;
  final List<ExploreTopicInfoDto> years;

  const ExploreIndexDto({
    this.regions = const [],
    this.categories = const [],
    this.years = const [],
  });

  factory ExploreIndexDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreIndexDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreIndexDtoToJson(this);
}
