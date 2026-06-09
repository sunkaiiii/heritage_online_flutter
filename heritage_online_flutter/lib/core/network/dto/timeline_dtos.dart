import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';

part 'timeline_dtos.g.dart';

/// 时间线条目 DTO
@JsonSerializable()
class TimelineItemDto {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? category;
  final String? kind;
  final String? region;
  final String? date;
  final int? year;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final String? sourceId;

  const TimelineItemDto({
    this.id,
    this.type,
    this.title,
    this.summary,
    this.category,
    this.kind,
    this.region,
    this.date,
    this.year,
    this.coverImage,
    this.sourceUrl,
    this.sourceId,
  });

  factory TimelineItemDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineItemDtoToJson(this);
}

/// 时间线年份桶 DTO
@JsonSerializable()
class TimelineYearBucketDto {
  final int year;
  final int total;
  final int articleCount;
  final int directoryItemCount;
  final int inheritorCount;

  const TimelineYearBucketDto({
    this.year = 0,
    this.total = 0,
    this.articleCount = 0,
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
  });

  factory TimelineYearBucketDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineYearBucketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineYearBucketDtoToJson(this);
}

/// 时间线 v2 Facets DTO
@JsonSerializable()
class TimelineV2FacetsDto {
  final List<FacetBucketDto> types;
  final List<FacetBucketDto> categories;
  final List<FacetBucketDto> regions;
  final List<FacetBucketDto> kinds;

  const TimelineV2FacetsDto({
    this.types = const [],
    this.categories = const [],
    this.regions = const [],
    this.kinds = const [],
  });

  factory TimelineV2FacetsDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineV2FacetsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineV2FacetsDtoToJson(this);
}

/// 时间线 v2 响应 DTO
@JsonSerializable()
class TimelineV2ResponseDto {
  final List<TimelineItemDto> items;
  final int page;
  final int pageSize;
  final bool hasMore;
  final int total;
  final TimelineV2FacetsDto? facets;

  const TimelineV2ResponseDto({
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.hasMore = false,
    this.total = 0,
    this.facets,
  });

  factory TimelineV2ResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineV2ResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineV2ResponseDtoToJson(this);
}
