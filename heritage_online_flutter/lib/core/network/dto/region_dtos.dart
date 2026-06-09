import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';
import 'content_dtos.dart';
import 'explore_dtos.dart';

part 'region_dtos.g.dart';

/// 地区图谱全局统计
@JsonSerializable()
class RegionAtlasTotalsDto {
  final int directoryItemCount;
  final int inheritorCount;
  final int regionCount;

  const RegionAtlasTotalsDto({
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.regionCount = 0,
  });

  factory RegionAtlasTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$RegionAtlasTotalsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionAtlasTotalsDtoToJson(this);
}

/// 地区图谱单个地区卡片
@JsonSerializable()
class RegionAtlasItemDto {
  final String? region;
  final String? displayName;
  final int directoryItemCount;
  final int inheritorCount;
  final int total;
  final List<FacetBucketDto> topCategories;
  final List<FacetBucketDto> topKinds;
  final MediaAssetDto? coverImage;

  const RegionAtlasItemDto({
    this.region,
    this.displayName,
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.total = 0,
    this.topCategories = const [],
    this.topKinds = const [],
    this.coverImage,
  });

  factory RegionAtlasItemDto.fromJson(Map<String, dynamic> json) =>
      _$RegionAtlasItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionAtlasItemDtoToJson(this);
}

/// 地区图谱响应
@JsonSerializable()
class RegionAtlasDto {
  final List<RegionAtlasItemDto> regions;
  final RegionAtlasTotalsDto? totals;
  final String? generatedAt;

  const RegionAtlasDto({
    this.regions = const [],
    this.totals,
    this.generatedAt,
  });

  factory RegionAtlasDto.fromJson(Map<String, dynamic> json) =>
      _$RegionAtlasDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionAtlasDtoToJson(this);
}

/// 地区详情统计
@JsonSerializable()
class RegionAtlasDetailStatsDto {
  final int directoryItemCount;
  final int inheritorCount;
  final int total;

  const RegionAtlasDetailStatsDto({
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.total = 0,
  });

  factory RegionAtlasDetailStatsDto.fromJson(Map<String, dynamic> json) =>
      _$RegionAtlasDetailStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionAtlasDetailStatsDtoToJson(this);
}

/// 地区图谱详情响应
@JsonSerializable()
class RegionAtlasDetailDto {
  final String? region;
  final String? displayName;
  final RegionAtlasDetailStatsDto? stats;
  final List<FacetBucketDto> categoryBreakdown;
  final List<FacetBucketDto> kindBreakdown;
  final List<DirectoryItemSummaryDto> featuredDirectoryItems;
  final List<InheritorSummaryDto> featuredInheritors;
  final List<ArticleSummaryDto> relatedArticles;
  final List<ExploreTopicItemDto> timeline;
  final List<ExploreTopicLinkDto> relatedRegions;
  final String? generatedAt;

  const RegionAtlasDetailDto({
    this.region,
    this.displayName,
    this.stats,
    this.categoryBreakdown = const [],
    this.kindBreakdown = const [],
    this.featuredDirectoryItems = const [],
    this.featuredInheritors = const [],
    this.relatedArticles = const [],
    this.timeline = const [],
    this.relatedRegions = const [],
    this.generatedAt,
  });

  factory RegionAtlasDetailDto.fromJson(Map<String, dynamic> json) =>
      _$RegionAtlasDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegionAtlasDetailDtoToJson(this);
}
