import 'package:json_annotation/json_annotation.dart';

import 'collection_dtos.dart';
import 'common_dtos.dart';
import 'content_dtos.dart';

part 'taxonomy_dtos.g.dart';

/// 主题库主题
@JsonSerializable()
class TaxonomyTopicDto {
  final String type;
  final String key;
  final String title;
  final String? subtitle;
  final int directoryItemCount;
  final int inheritorCount;
  final int articleCount;
  final int total;
  final List<TaxonomyRegionCountDto> topRegions;
  final List<TaxonomyCategoryCountDto> topCategories;
  final MediaAssetDto? coverImage;

  const TaxonomyTopicDto({
    this.type = '',
    this.key = '',
    this.title = '',
    this.subtitle,
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.articleCount = 0,
    this.total = 0,
    this.topRegions = const [],
    this.topCategories = const [],
    this.coverImage,
  });

  factory TaxonomyTopicDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyTopicDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyTopicDtoToJson(this);
}

/// 地区计数
@JsonSerializable()
class TaxonomyRegionCountDto {
  final String region;
  final int count;

  const TaxonomyRegionCountDto({
    this.region = '',
    this.count = 0,
  });

  factory TaxonomyRegionCountDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyRegionCountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyRegionCountDtoToJson(this);
}

/// 分类计数
@JsonSerializable()
class TaxonomyCategoryCountDto {
  final String category;
  final int count;

  const TaxonomyCategoryCountDto({
    this.category = '',
    this.count = 0,
  });

  factory TaxonomyCategoryCountDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyCategoryCountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyCategoryCountDtoToJson(this);
}

/// 主题库 kind
@JsonSerializable()
class TaxonomyKindDto {
  final String key;
  final String title;
  final int directoryItemCount;
  final int inheritorCount;
  final int total;

  const TaxonomyKindDto({
    this.key = '',
    this.title = '',
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.total = 0,
  });

  factory TaxonomyKindDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyKindDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyKindDtoToJson(this);
}

/// 主题库索引
@JsonSerializable(genericArgumentFactories: true)
class TaxonomyIndexDto<T> {
  final List<T> items;
  final String? generatedAt;

  const TaxonomyIndexDto({
    this.items = const [],
    this.generatedAt,
  });

  factory TaxonomyIndexDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$TaxonomyIndexDtoFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$TaxonomyIndexDtoToJson(this, toJsonT);
}

/// 主题库统计
@JsonSerializable()
class TaxonomyStatDto {
  final int directoryItemCount;
  final int inheritorCount;
  final int articleCount;
  final int total;

  const TaxonomyStatDto({
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.articleCount = 0,
    this.total = 0,
  });

  factory TaxonomyStatDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyStatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyStatDtoToJson(this);
}

/// 分类详情
@JsonSerializable()
class TaxonomyCategoryDetailDto {
  final TaxonomyTopicDto topic;
  final TaxonomyStatDto stats;
  final List<TaxonomyRegionCountDto> topRegions;
  final List<ArticleSummaryDto> articles;
  final List<DirectoryItemSummaryDto> directoryItems;
  final List<InheritorSummaryDto> inheritors;
  final List<String> relatedCategories;
  final List<CollectionItemDto> recommendedCollections;
  final String? generatedAt;

  const TaxonomyCategoryDetailDto({
    this.topic = const TaxonomyTopicDto(),
    this.stats = const TaxonomyStatDto(),
    this.topRegions = const [],
    this.articles = const [],
    this.directoryItems = const [],
    this.inheritors = const [],
    this.relatedCategories = const [],
    this.recommendedCollections = const [],
    this.generatedAt,
  });

  factory TaxonomyCategoryDetailDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyCategoryDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyCategoryDetailDtoToJson(this);
}

/// 地区详情
@JsonSerializable()
class TaxonomyRegionDetailDto {
  final TaxonomyTopicDto topic;
  final TaxonomyStatDto stats;
  final List<TaxonomyCategoryCountDto> topCategories;
  final List<ArticleSummaryDto> articles;
  final List<DirectoryItemSummaryDto> directoryItems;
  final List<InheritorSummaryDto> inheritors;
  final List<String> relatedRegions;
  final List<CollectionItemDto> recommendedCollections;
  final String? generatedAt;

  const TaxonomyRegionDetailDto({
    this.topic = const TaxonomyTopicDto(),
    this.stats = const TaxonomyStatDto(),
    this.topCategories = const [],
    this.articles = const [],
    this.directoryItems = const [],
    this.inheritors = const [],
    this.relatedRegions = const [],
    this.recommendedCollections = const [],
    this.generatedAt,
  });

  factory TaxonomyRegionDetailDto.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyRegionDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaxonomyRegionDetailDtoToJson(this);
}
