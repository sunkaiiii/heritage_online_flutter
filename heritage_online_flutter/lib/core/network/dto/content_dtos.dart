import 'package:json_annotation/json_annotation.dart';

import 'common_dtos.dart';
import 'enums.dart';

part 'content_dtos.g.dart';

/// 文章内容块
@JsonSerializable()
class ArticleContentBlockDto {
  @JsonKey(fromJson: ArticleContentBlockType.fromWireName, toJson: _blockTypeToJson)
  final ArticleContentBlockType type;
  final String? text;
  final MediaAssetDto? image;

  const ArticleContentBlockDto({
    this.type = ArticleContentBlockType.text,
    this.text,
    this.image,
  });

  factory ArticleContentBlockDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleContentBlockDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleContentBlockDtoToJson(this);
}

/// 文章引用
@JsonSerializable()
class ArticleReferenceDto {
  final String? title;
  final String? detailUrl;
  final String? sourceId;
  final String? publishedAt;

  const ArticleReferenceDto({
    this.title,
    this.detailUrl,
    this.sourceId,
    this.publishedAt,
  });

  factory ArticleReferenceDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleReferenceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleReferenceDtoToJson(this);
}

/// 文章摘要
@JsonSerializable()
class ArticleSummaryDto {
  final String? id;
  @JsonKey(fromJson: ArticleCategory.fromWireName, toJson: _categoryToJson)
  final ArticleCategory category;
  final String? title;
  final String? summary;
  final String? publishedAt;
  final MediaAssetDto? coverImage;
  final String? sourceId;
  final String? sourceUrl;

  const ArticleSummaryDto({
    this.id,
    this.category = ArticleCategory.news,
    this.title,
    this.summary,
    this.publishedAt,
    this.coverImage,
    this.sourceId,
    this.sourceUrl,
  });

  factory ArticleSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleSummaryDtoToJson(this);
}

/// 文章详情
@JsonSerializable()
class ArticleDetailDto {
  final String? id;
  @JsonKey(fromJson: ArticleCategory.fromWireName, toJson: _categoryToJson)
  final ArticleCategory category;
  final String? title;
  final String? summary;
  final String? publishedAt;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final String? sourceName;
  final String? author;
  final String? editor;
  final List<ArticleContentBlockDto> contentBlocks;
  final List<ArticleReferenceDto> relatedArticles;

  const ArticleDetailDto({
    this.id,
    this.category = ArticleCategory.news,
    this.title,
    this.summary,
    this.publishedAt,
    this.coverImage,
    this.sourceUrl,
    this.sourceName,
    this.author,
    this.editor,
    this.contentBlocks = const [],
    this.relatedArticles = const [],
  });

  factory ArticleDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDetailDtoToJson(this);
}

/// 名录引用
@JsonSerializable()
class DirectoryReferenceDto {
  final String? title;
  final String? detailUrl;
  final String? sourceId;
  final String? kind;
  final String? category;
  final String? region;
  final int? publishedYear;

  const DirectoryReferenceDto({
    this.title,
    this.detailUrl,
    this.sourceId,
    this.kind,
    this.category,
    this.region,
    this.publishedYear,
  });

  factory DirectoryReferenceDto.fromJson(Map<String, dynamic> json) =>
      _$DirectoryReferenceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryReferenceDtoToJson(this);
}

/// 名录摘要
@JsonSerializable()
class DirectoryItemSummaryDto {
  final String? id;
  @JsonKey(fromJson: DirectoryItemKind.fromWireName, toJson: _kindToJson)
  final DirectoryItemKind kind;
  final String? title;
  final String? summary;
  final String? category;
  final String? region;
  final String? projectCode;
  final String? batch;
  final int? publishedYear;
  final String? listType;
  final MediaAssetDto? coverImage;
  final String? sourceId;
  final String? sourceUrl;

  const DirectoryItemSummaryDto({
    this.id,
    this.kind = DirectoryItemKind.nationalProject,
    this.title,
    this.summary,
    this.category,
    this.region,
    this.projectCode,
    this.batch,
    this.publishedYear,
    this.listType,
    this.coverImage,
    this.sourceId,
    this.sourceUrl,
  });

  factory DirectoryItemSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DirectoryItemSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryItemSummaryDtoToJson(this);
}

/// 名录详情
@JsonSerializable()
class DirectoryItemDetailDto {
  final String? id;
  @JsonKey(fromJson: DirectoryItemKind.fromWireName, toJson: _kindToJson)
  final DirectoryItemKind kind;
  final String? title;
  final String? summary;
  final String? category;
  final String? region;
  final String? projectCode;
  final String? batch;
  final int? publishedYear;
  final String? listType;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final String? nominationType;
  final String? protectionUnit;
  final List<MediaAssetDto> gallery;
  final List<ArticleContentBlockDto> contentBlocks;
  final List<DirectoryReferenceDto> relatedProjects;
  final List<DirectoryReferenceDto> relatedInheritors;
  final List<DirectoryReferenceDto> relatedDocuments;

  const DirectoryItemDetailDto({
    this.id,
    this.kind = DirectoryItemKind.nationalProject,
    this.title,
    this.summary,
    this.category,
    this.region,
    this.projectCode,
    this.batch,
    this.publishedYear,
    this.listType,
    this.coverImage,
    this.sourceUrl,
    this.nominationType,
    this.protectionUnit,
    this.gallery = const [],
    this.contentBlocks = const [],
    this.relatedProjects = const [],
    this.relatedInheritors = const [],
    this.relatedDocuments = const [],
  });

  factory DirectoryItemDetailDto.fromJson(Map<String, dynamic> json) =>
      _$DirectoryItemDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryItemDetailDtoToJson(this);
}

/// 名录统计总览
@JsonSerializable()
class DirectoryStatisticsOverviewDto {
  final String? kind;
  final int total;
  final String? generatedAt;
  final List<DirectoryStatisticDimensionDto> dimensions;

  const DirectoryStatisticsOverviewDto({
    this.kind,
    this.total = 0,
    this.generatedAt,
    this.dimensions = const [],
  });

  factory DirectoryStatisticsOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$DirectoryStatisticsOverviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryStatisticsOverviewDtoToJson(this);
}

/// 名录统计维度
@JsonSerializable()
class DirectoryStatisticDimensionDto {
  final String? dimension;
  final List<DirectoryStatisticItemDto> items;

  const DirectoryStatisticDimensionDto({
    this.dimension,
    this.items = const [],
  });

  factory DirectoryStatisticDimensionDto.fromJson(Map<String, dynamic> json) =>
      _$DirectoryStatisticDimensionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryStatisticDimensionDtoToJson(this);
}

/// 名录统计项
@JsonSerializable()
class DirectoryStatisticItemDto {
  final String? key;
  final String? name;
  final int value;

  const DirectoryStatisticItemDto({
    this.key,
    this.name,
    this.value = 0,
  });

  factory DirectoryStatisticItemDto.fromJson(Map<String, dynamic> json) =>
      _$DirectoryStatisticItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DirectoryStatisticItemDtoToJson(this);
}

/// 传承人摘要
@JsonSerializable()
class InheritorSummaryDto {
  final String? id;
  final String? name;
  final String? gender;
  final String? birthDateText;
  final String? ethnicity;
  final String? category;
  final String? projectCode;
  final String? projectName;
  final String? region;
  final String? batch;
  final String? description;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;

  const InheritorSummaryDto({
    this.id,
    this.name,
    this.gender,
    this.birthDateText,
    this.ethnicity,
    this.category,
    this.projectCode,
    this.projectName,
    this.region,
    this.batch,
    this.description,
    this.coverImage,
    this.sourceUrl,
  });

  factory InheritorSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$InheritorSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InheritorSummaryDtoToJson(this);
}

/// 传承人详情
@JsonSerializable()
class InheritorDetailDto {
  final String? id;
  final String? name;
  final String? gender;
  final String? birthDateText;
  final String? ethnicity;
  final String? category;
  final String? projectCode;
  final String? projectName;
  final String? region;
  final String? batch;
  final String? description;
  final MediaAssetDto? coverImage;
  final String? sourceUrl;
  final List<ArticleContentBlockDto> contentBlocks;
  final List<DirectoryReferenceDto> relatedProjects;
  final List<DirectoryReferenceDto> relatedInheritors;

  const InheritorDetailDto({
    this.id,
    this.name,
    this.gender,
    this.birthDateText,
    this.ethnicity,
    this.category,
    this.projectCode,
    this.projectName,
    this.region,
    this.batch,
    this.description,
    this.coverImage,
    this.sourceUrl,
    this.contentBlocks = const [],
    this.relatedProjects = const [],
    this.relatedInheritors = const [],
  });

  factory InheritorDetailDto.fromJson(Map<String, dynamic> json) =>
      _$InheritorDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InheritorDetailDtoToJson(this);
}

/// 首页 Banner
@JsonSerializable()
class HomeBannerDto {
  final String? id;
  final int sortOrder;
  final String? targetUrl;
  final MediaAssetDto? displayImage;
  final MediaAssetDto? mobileImage;
  final MediaAssetDto? desktopImage;

  const HomeBannerDto({
    this.id,
    this.sortOrder = 0,
    this.targetUrl,
    this.displayImage,
    this.mobileImage,
    this.desktopImage,
  });

  factory HomeBannerDto.fromJson(Map<String, dynamic> json) =>
      _$HomeBannerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBannerDtoToJson(this);

  /// 获取最佳可用图片
  MediaAssetDto? get bestImage => mobileImage ?? displayImage ?? desktopImage;
}

/// 首页 Feed 摘要
@JsonSerializable()
class HomeFeedSummaryDto {
  final int totalArticles;
  final int totalDirectoryItems;
  final int totalInheritors;
  final Map<String, int> directoryKindCounts;

  const HomeFeedSummaryDto({
    this.totalArticles = 0,
    this.totalDirectoryItems = 0,
    this.totalInheritors = 0,
    this.directoryKindCounts = const {},
  });

  factory HomeFeedSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFeedSummaryDtoToJson(this);
}

/// 首页 Feed
@JsonSerializable()
class HomeFeedDto {
  final List<HomeBannerDto> banners;
  final List<ArticleSummaryDto> latestNews;
  final List<ArticleSummaryDto> latestSpecialTopics;
  final List<ArticleSummaryDto> latestForumArticles;
  final List<DirectoryItemSummaryDto> featuredDirectoryItems;
  final List<InheritorSummaryDto> featuredInheritors;
  final HomeFeedSummaryDto? summary;

  const HomeFeedDto({
    this.banners = const [],
    this.latestNews = const [],
    this.latestSpecialTopics = const [],
    this.latestForumArticles = const [],
    this.featuredDirectoryItems = const [],
    this.featuredInheritors = const [],
    this.summary,
  });

  factory HomeFeedDto.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFeedDtoToJson(this);
}

// ==================== JSON 辅助函数 ====================
// 用于 JsonKey 的 toJson 参数，将枚举转换为 wire name

String _categoryToJson(ArticleCategory category) => category.wireName;
String _kindToJson(DirectoryItemKind kind) => kind.wireName;
String _blockTypeToJson(ArticleContentBlockType type) => type.wireName;
