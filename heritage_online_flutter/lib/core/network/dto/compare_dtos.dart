import 'package:json_annotation/json_annotation.dart';

import 'collection_dtos.dart';
import 'taxonomy_dtos.dart';

part 'compare_dtos.g.dart';

/// 对比结果
@JsonSerializable()
class CompareResultDto {
  final CompareSideDto left;
  final CompareSideDto right;
  final CompareSummaryDto summary;
  final List<String> sharedCategories;
  final List<String> leftUniqueCategories;
  final List<String> rightUniqueCategories;
  final List<String> sharedRegions;
  final List<String> leftUniqueRegions;
  final List<String> rightUniqueRegions;
  final List<CollectionItemDto> leftFeaturedItems;
  final List<CollectionItemDto> rightFeaturedItems;
  final String? generatedAt;

  const CompareResultDto({
    this.left = const CompareSideDto(),
    this.right = const CompareSideDto(),
    this.summary = const CompareSummaryDto(),
    this.sharedCategories = const [],
    this.leftUniqueCategories = const [],
    this.rightUniqueCategories = const [],
    this.sharedRegions = const [],
    this.leftUniqueRegions = const [],
    this.rightUniqueRegions = const [],
    this.leftFeaturedItems = const [],
    this.rightFeaturedItems = const [],
    this.generatedAt,
  });

  factory CompareResultDto.fromJson(Map<String, dynamic> json) =>
      _$CompareResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CompareResultDtoToJson(this);
}

/// 对比单侧
@JsonSerializable()
class CompareSideDto {
  final String key;
  final String title;
  final int directoryItemCount;
  final int inheritorCount;
  final int articleCount;
  final int total;
  final List<TaxonomyCategoryCountDto> topCategories;
  final List<TaxonomyRegionCountDto> topRegions;

  const CompareSideDto({
    this.key = '',
    this.title = '',
    this.directoryItemCount = 0,
    this.inheritorCount = 0,
    this.articleCount = 0,
    this.total = 0,
    this.topCategories = const [],
    this.topRegions = const [],
  });

  factory CompareSideDto.fromJson(Map<String, dynamic> json) =>
      _$CompareSideDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CompareSideDtoToJson(this);
}

/// 对比摘要
@JsonSerializable()
class CompareSummaryDto {
  final int leftTotal;
  final int rightTotal;
  final int sharedCategoryCount;
  final int leftUniqueCategoryCount;
  final int rightUniqueCategoryCount;
  final int sharedRegionCount;
  final int leftUniqueRegionCount;
  final int rightUniqueRegionCount;

  const CompareSummaryDto({
    this.leftTotal = 0,
    this.rightTotal = 0,
    this.sharedCategoryCount = 0,
    this.leftUniqueCategoryCount = 0,
    this.rightUniqueCategoryCount = 0,
    this.sharedRegionCount = 0,
    this.leftUniqueRegionCount = 0,
    this.rightUniqueRegionCount = 0,
  });

  factory CompareSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$CompareSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CompareSummaryDtoToJson(this);
}
