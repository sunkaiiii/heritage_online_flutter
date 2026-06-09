import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';

part 'collection_dtos.g.dart';

/// 精选合集摘要
@JsonSerializable()
class FeaturedCollectionDto {
  final String? id;
  final String? title;
  final String? subtitle;
  final int itemCount;

  const FeaturedCollectionDto({
    this.id,
    this.title,
    this.subtitle,
    this.itemCount = 0,
  });

  factory FeaturedCollectionDto.fromJson(Map<String, dynamic> json) =>
      _$FeaturedCollectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedCollectionDtoToJson(this);
}

/// 合集条目
@JsonSerializable()
class CollectionItemDto {
  final String? id;
  final String? type;
  final String? title;
  final String? summary;
  final String? category;
  final String? region;
  final String? publishedAt;
  final int? publishedYear;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final String? sourceId;
  final String? kind;

  const CollectionItemDto({
    this.id,
    this.type,
    this.title,
    this.summary,
    this.category,
    this.region,
    this.publishedAt,
    this.publishedYear,
    this.coverImage,
    this.sourceUrl,
    this.sourceId,
    this.kind,
  });

  factory CollectionItemDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionItemDtoToJson(this);
}

/// 合集详情
@JsonSerializable()
class CollectionDto {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? type;
  final List<String> tags;
  final String? generatedAt;
  final List<CollectionItemDto> items;

  const CollectionDto({
    this.id,
    this.title,
    this.subtitle,
    this.type,
    this.tags = const [],
    this.generatedAt,
    this.items = const [],
  });

  factory CollectionDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionDtoToJson(this);
}
