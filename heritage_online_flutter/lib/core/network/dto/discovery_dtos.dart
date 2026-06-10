import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';

part 'discovery_dtos.g.dart';

/// 发现页通用条目 — 用于今日发现、趋势、随便看看等区块的混合内容项
@JsonSerializable()
class DiscoveryItemDto {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? category;
  final String? region;
  final String? kind;
  final int? publishedYear;
  final String? publishedAt;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final String? sourceId;

  const DiscoveryItemDto({
    this.id,
    this.type,
    this.title,
    this.summary,
    this.category,
    this.region,
    this.kind,
    this.publishedYear,
    this.publishedAt,
    this.coverImage,
    this.sourceUrl,
    this.sourceId,
  });

  factory DiscoveryItemDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryItemDtoToJson(this);
}

/// 今日发现
@JsonSerializable()
class DiscoveryTodayDto {
  final DiscoveryItemDto? featuredDirectoryItem;
  final DiscoveryItemDto? featuredInheritor;
  final List<DiscoveryItemDto> articles;

  const DiscoveryTodayDto({
    this.featuredDirectoryItem,
    this.featuredInheritor,
    this.articles = const [],
  });

  factory DiscoveryTodayDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryTodayDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryTodayDtoToJson(this);

  bool get hasAnyContent =>
      featuredDirectoryItem != null ||
      featuredInheritor != null ||
      articles.isNotEmpty;
}

/// 趋势内容
@JsonSerializable()
class DiscoveryTrendingDto {
  final List<DiscoveryItemDto> items;

  const DiscoveryTrendingDto({this.items = const []});

  factory DiscoveryTrendingDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryTrendingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryTrendingDtoToJson(this);
}

/// 本周非遗包区块
@JsonSerializable()
class DiscoveryWeeklySectionDto {
  final String? title;
  final String? subtitle;
  final List<DiscoveryItemDto> items;

  const DiscoveryWeeklySectionDto({
    this.title,
    this.subtitle,
    this.items = const [],
  });

  factory DiscoveryWeeklySectionDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryWeeklySectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryWeeklySectionDtoToJson(this);
}

/// 本周非遗包
@JsonSerializable()
class DiscoveryWeeklyDto {
  final List<DiscoveryWeeklySectionDto> sections;

  const DiscoveryWeeklyDto({this.sections = const []});

  factory DiscoveryWeeklyDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryWeeklyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryWeeklyDtoToJson(this);
}
