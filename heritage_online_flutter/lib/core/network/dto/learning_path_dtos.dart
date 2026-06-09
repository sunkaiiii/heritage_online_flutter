import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';
import 'explore_dtos.dart';

part 'learning_path_dtos.g.dart';

/// 学习路径步骤
@JsonSerializable()
class LearningPathStepDto {
  final String? id;
  final String? title;
  final String? subtitle;
  final ExploreTopicInfoDto? topic;
  final List<ExploreTopicItemDto> items;

  const LearningPathStepDto({
    this.id,
    this.title,
    this.subtitle,
    this.topic,
    this.items = const [],
  });

  factory LearningPathStepDto.fromJson(Map<String, dynamic> json) =>
      _$LearningPathStepDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LearningPathStepDtoToJson(this);
}

/// 学习路径摘要
@JsonSerializable()
class LearningPathDto {
  final String? id;
  final String? title;
  final String? subtitle;
  final List<ExploreTopicLinkDto> topics;

  const LearningPathDto({
    this.id,
    this.title,
    this.subtitle,
    this.topics = const [],
  });

  factory LearningPathDto.fromJson(Map<String, dynamic> json) =>
      _$LearningPathDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LearningPathDtoToJson(this);
}

/// 学习路径详情
@JsonSerializable()
class LearningPathDetailDto {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? description;
  final List<String> tags;
  final List<LearningPathStepDto> steps;
  final List<ExploreTopicItemDto> featuredItems;
  final List<ExploreTopicLinkDto> relatedTopics;
  final String? generatedAt;

  const LearningPathDetailDto({
    this.id,
    this.title,
    this.subtitle,
    this.description,
    this.tags = const [],
    this.steps = const [],
    this.featuredItems = const [],
    this.relatedTopics = const [],
    this.generatedAt,
  });

  factory LearningPathDetailDto.fromJson(Map<String, dynamic> json) =>
      _$LearningPathDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LearningPathDetailDtoToJson(this);
}
