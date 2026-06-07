import 'package:json_annotation/json_annotation.dart';

part 'common_dtos.g.dart';

/// 分页结果
@JsonSerializable(genericArgumentFactories: true)
class PagedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final bool hasMore;
  final int total;

  const PagedResult({
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.hasMore = false,
    this.total = 0,
  });

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PagedResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PagedResultToJson(this, toJsonT);
}

/// 媒体资源
@JsonSerializable()
class MediaAssetDto {
  final String? sourceUrl;
  final String? originalUrl;
  final String? displayUrl;
  final String? thumbnailUrl;
  final String? altText;

  const MediaAssetDto({
    this.sourceUrl,
    this.originalUrl,
    this.displayUrl,
    this.thumbnailUrl,
    this.altText,
  });

  factory MediaAssetDto.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MediaAssetDtoToJson(this);

  /// 获取最佳可用 URL
  String? get bestUrl => displayUrl ?? originalUrl ?? sourceUrl ?? thumbnailUrl;

  /// 获取缩略图 URL，如果没有则使用主图
  String? get thumbnailOrMainUrl => thumbnailUrl ?? bestUrl;
}

/// 问题详情（错误响应）
@JsonSerializable()
class ProblemDetailsDto {
  final String? type;
  final String? title;
  final int? status;
  final String? detail;
  final String? instance;

  const ProblemDetailsDto({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
  });

  factory ProblemDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemDetailsDtoToJson(this);
}

/// 分面桶（用于统计）
@JsonSerializable()
class FacetBucketDto {
  final String? key;
  final int count;

  const FacetBucketDto({
    this.key,
    this.count = 0,
  });

  factory FacetBucketDto.fromJson(Map<String, dynamic> json) =>
      _$FacetBucketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FacetBucketDtoToJson(this);
}

/// 探索主题链接
@JsonSerializable()
class ExploreTopicLinkDto {
  final String? type;
  final String? key;
  final String? title;

  const ExploreTopicLinkDto({
    this.type,
    this.key,
    this.title,
  });

  factory ExploreTopicLinkDto.fromJson(Map<String, dynamic> json) =>
      _$ExploreTopicLinkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreTopicLinkDtoToJson(this);
}
