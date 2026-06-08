// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleContentBlockDto _$ArticleContentBlockDtoFromJson(
  Map<String, dynamic> json,
) => ArticleContentBlockDto(
  type: json['type'] == null
      ? ArticleContentBlockType.text
      : ArticleContentBlockType.fromWireName(json['type'] as String?),
  text: json['text'] as String?,
  image: json['image'] == null
      ? null
      : MediaAssetDto.fromJson(json['image'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ArticleContentBlockDtoToJson(
  ArticleContentBlockDto instance,
) => <String, dynamic>{
  'type': _blockTypeToJson(instance.type),
  'text': instance.text,
  'image': instance.image,
};

ArticleReferenceDto _$ArticleReferenceDtoFromJson(Map<String, dynamic> json) =>
    ArticleReferenceDto(
      title: json['title'] as String?,
      detailUrl: json['detailUrl'] as String?,
      sourceId: json['sourceId'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );

Map<String, dynamic> _$ArticleReferenceDtoToJson(
  ArticleReferenceDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'detailUrl': instance.detailUrl,
  'sourceId': instance.sourceId,
  'publishedAt': instance.publishedAt,
};

ArticleSummaryDto _$ArticleSummaryDtoFromJson(Map<String, dynamic> json) =>
    ArticleSummaryDto(
      id: json['id'] as String?,
      category: json['category'] == null
          ? ArticleCategory.news
          : ArticleCategory.fromWireName(json['category'] as String?),
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      publishedAt: json['publishedAt'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceId: json['sourceId'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
    );

Map<String, dynamic> _$ArticleSummaryDtoToJson(ArticleSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _categoryToJson(instance.category),
      'title': instance.title,
      'summary': instance.summary,
      'publishedAt': instance.publishedAt,
      'coverImage': instance.coverImage,
      'sourceId': instance.sourceId,
      'sourceUrl': instance.sourceUrl,
    };

ArticleDetailDto _$ArticleDetailDtoFromJson(Map<String, dynamic> json) =>
    ArticleDetailDto(
      id: json['id'] as String?,
      category: json['category'] == null
          ? ArticleCategory.news
          : ArticleCategory.fromWireName(json['category'] as String?),
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      publishedAt: json['publishedAt'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
      sourceName: json['sourceName'] as String?,
      author: json['author'] as String?,
      editor: json['editor'] as String?,
      contentBlocks:
          (json['contentBlocks'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ArticleContentBlockDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      relatedArticles:
          (json['relatedArticles'] as List<dynamic>?)
              ?.map(
                (e) => ArticleReferenceDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ArticleDetailDtoToJson(ArticleDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _categoryToJson(instance.category),
      'title': instance.title,
      'summary': instance.summary,
      'publishedAt': instance.publishedAt,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'sourceName': instance.sourceName,
      'author': instance.author,
      'editor': instance.editor,
      'contentBlocks': instance.contentBlocks,
      'relatedArticles': instance.relatedArticles,
    };

DirectoryReferenceDto _$DirectoryReferenceDtoFromJson(
  Map<String, dynamic> json,
) => DirectoryReferenceDto(
  title: json['title'] as String?,
  detailUrl: json['detailUrl'] as String?,
  sourceId: json['sourceId'] as String?,
  kind: json['kind'] as String?,
  category: json['category'] as String?,
  region: json['region'] as String?,
  publishedYear: (json['publishedYear'] as num?)?.toInt(),
);

Map<String, dynamic> _$DirectoryReferenceDtoToJson(
  DirectoryReferenceDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'detailUrl': instance.detailUrl,
  'sourceId': instance.sourceId,
  'kind': instance.kind,
  'category': instance.category,
  'region': instance.region,
  'publishedYear': instance.publishedYear,
};

DirectoryItemSummaryDto _$DirectoryItemSummaryDtoFromJson(
  Map<String, dynamic> json,
) => DirectoryItemSummaryDto(
  id: json['id'] as String?,
  kind: json['kind'] == null
      ? DirectoryItemKind.nationalProject
      : DirectoryItemKind.fromWireName(json['kind'] as String?),
  title: json['title'] as String?,
  summary: json['summary'] as String?,
  category: json['category'] as String?,
  region: json['region'] as String?,
  projectCode: json['projectCode'] as String?,
  batch: json['batch'] as String?,
  publishedYear: (json['publishedYear'] as num?)?.toInt(),
  listType: json['listType'] as String?,
  coverImage: json['coverImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
  sourceId: json['sourceId'] as String?,
  sourceUrl: json['sourceUrl'] as String?,
);

Map<String, dynamic> _$DirectoryItemSummaryDtoToJson(
  DirectoryItemSummaryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': _kindToJson(instance.kind),
  'title': instance.title,
  'summary': instance.summary,
  'category': instance.category,
  'region': instance.region,
  'projectCode': instance.projectCode,
  'batch': instance.batch,
  'publishedYear': instance.publishedYear,
  'listType': instance.listType,
  'coverImage': instance.coverImage,
  'sourceId': instance.sourceId,
  'sourceUrl': instance.sourceUrl,
};

DirectoryItemDetailDto _$DirectoryItemDetailDtoFromJson(
  Map<String, dynamic> json,
) => DirectoryItemDetailDto(
  id: json['id'] as String?,
  kind: json['kind'] == null
      ? DirectoryItemKind.nationalProject
      : DirectoryItemKind.fromWireName(json['kind'] as String?),
  title: json['title'] as String?,
  summary: json['summary'] as String?,
  category: json['category'] as String?,
  region: json['region'] as String?,
  projectCode: json['projectCode'] as String?,
  batch: json['batch'] as String?,
  publishedYear: (json['publishedYear'] as num?)?.toInt(),
  listType: json['listType'] as String?,
  coverImage: json['coverImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
  sourceUrl: json['sourceUrl'] as String?,
  nominationType: json['nominationType'] as String?,
  protectionUnit: json['protectionUnit'] as String?,
  gallery:
      (json['gallery'] as List<dynamic>?)
          ?.map((e) => MediaAssetDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  contentBlocks:
      (json['contentBlocks'] as List<dynamic>?)
          ?.map(
            (e) => ArticleContentBlockDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  relatedProjects:
      (json['relatedProjects'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryReferenceDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  relatedInheritors:
      (json['relatedInheritors'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryReferenceDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  relatedDocuments:
      (json['relatedDocuments'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryReferenceDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$DirectoryItemDetailDtoToJson(
  DirectoryItemDetailDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': _kindToJson(instance.kind),
  'title': instance.title,
  'summary': instance.summary,
  'category': instance.category,
  'region': instance.region,
  'projectCode': instance.projectCode,
  'batch': instance.batch,
  'publishedYear': instance.publishedYear,
  'listType': instance.listType,
  'coverImage': instance.coverImage,
  'sourceUrl': instance.sourceUrl,
  'nominationType': instance.nominationType,
  'protectionUnit': instance.protectionUnit,
  'gallery': instance.gallery,
  'contentBlocks': instance.contentBlocks,
  'relatedProjects': instance.relatedProjects,
  'relatedInheritors': instance.relatedInheritors,
  'relatedDocuments': instance.relatedDocuments,
};

DirectoryStatisticsOverviewDto _$DirectoryStatisticsOverviewDtoFromJson(
  Map<String, dynamic> json,
) => DirectoryStatisticsOverviewDto(
  kind: json['kind'] as String?,
  total: (json['total'] as num?)?.toInt() ?? 0,
  generatedAt: json['generatedAt'] as String?,
  dimensions:
      (json['dimensions'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryStatisticDimensionDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$DirectoryStatisticsOverviewDtoToJson(
  DirectoryStatisticsOverviewDto instance,
) => <String, dynamic>{
  'kind': instance.kind,
  'total': instance.total,
  'generatedAt': instance.generatedAt,
  'dimensions': instance.dimensions,
};

DirectoryStatisticDimensionDto _$DirectoryStatisticDimensionDtoFromJson(
  Map<String, dynamic> json,
) => DirectoryStatisticDimensionDto(
  dimension: json['dimension'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) =>
                DirectoryStatisticItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$DirectoryStatisticDimensionDtoToJson(
  DirectoryStatisticDimensionDto instance,
) => <String, dynamic>{
  'dimension': instance.dimension,
  'items': instance.items,
};

DirectoryStatisticItemDto _$DirectoryStatisticItemDtoFromJson(
  Map<String, dynamic> json,
) => DirectoryStatisticItemDto(
  key: json['key'] as String?,
  name: json['name'] as String?,
  value: (json['value'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DirectoryStatisticItemDtoToJson(
  DirectoryStatisticItemDto instance,
) => <String, dynamic>{
  'key': instance.key,
  'name': instance.name,
  'value': instance.value,
};

InheritorSummaryDto _$InheritorSummaryDtoFromJson(Map<String, dynamic> json) =>
    InheritorSummaryDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      birthDateText: json['birthDateText'] as String?,
      ethnicity: json['ethnicity'] as String?,
      category: json['category'] as String?,
      projectCode: json['projectCode'] as String?,
      projectName: json['projectName'] as String?,
      region: json['region'] as String?,
      batch: json['batch'] as String?,
      description: json['description'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceId: json['sourceId'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
    );

Map<String, dynamic> _$InheritorSummaryDtoToJson(
  InheritorSummaryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'gender': instance.gender,
  'birthDateText': instance.birthDateText,
  'ethnicity': instance.ethnicity,
  'category': instance.category,
  'projectCode': instance.projectCode,
  'projectName': instance.projectName,
  'region': instance.region,
  'batch': instance.batch,
  'description': instance.description,
  'coverImage': instance.coverImage,
  'sourceId': instance.sourceId,
  'sourceUrl': instance.sourceUrl,
};

InheritorDetailDto _$InheritorDetailDtoFromJson(Map<String, dynamic> json) =>
    InheritorDetailDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      birthDateText: json['birthDateText'] as String?,
      ethnicity: json['ethnicity'] as String?,
      category: json['category'] as String?,
      projectCode: json['projectCode'] as String?,
      projectName: json['projectName'] as String?,
      region: json['region'] as String?,
      batch: json['batch'] as String?,
      description: json['description'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : MediaAssetDto.fromJson(json['coverImage'] as Map<String, dynamic>),
      sourceUrl: json['sourceUrl'] as String?,
      contentBlocks:
          (json['contentBlocks'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ArticleContentBlockDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      relatedProjects:
          (json['relatedProjects'] as List<dynamic>?)
              ?.map(
                (e) =>
                    DirectoryReferenceDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      relatedInheritors:
          (json['relatedInheritors'] as List<dynamic>?)
              ?.map(
                (e) =>
                    DirectoryReferenceDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InheritorDetailDtoToJson(InheritorDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'birthDateText': instance.birthDateText,
      'ethnicity': instance.ethnicity,
      'category': instance.category,
      'projectCode': instance.projectCode,
      'projectName': instance.projectName,
      'region': instance.region,
      'batch': instance.batch,
      'description': instance.description,
      'coverImage': instance.coverImage,
      'sourceUrl': instance.sourceUrl,
      'contentBlocks': instance.contentBlocks,
      'relatedProjects': instance.relatedProjects,
      'relatedInheritors': instance.relatedInheritors,
    };

HomeBannerDto _$HomeBannerDtoFromJson(
  Map<String, dynamic> json,
) => HomeBannerDto(
  id: json['id'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  targetUrl: json['targetUrl'] as String?,
  displayImage: json['displayImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['displayImage'] as Map<String, dynamic>),
  mobileImage: json['mobileImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['mobileImage'] as Map<String, dynamic>),
  desktopImage: json['desktopImage'] == null
      ? null
      : MediaAssetDto.fromJson(json['desktopImage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HomeBannerDtoToJson(HomeBannerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sortOrder': instance.sortOrder,
      'targetUrl': instance.targetUrl,
      'displayImage': instance.displayImage,
      'mobileImage': instance.mobileImage,
      'desktopImage': instance.desktopImage,
    };

HomeFeedSummaryDto _$HomeFeedSummaryDtoFromJson(Map<String, dynamic> json) =>
    HomeFeedSummaryDto(
      totalArticles: (json['totalArticles'] as num?)?.toInt() ?? 0,
      totalDirectoryItems: (json['totalDirectoryItems'] as num?)?.toInt() ?? 0,
      totalInheritors: (json['totalInheritors'] as num?)?.toInt() ?? 0,
      directoryKindCounts:
          (json['directoryKindCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$HomeFeedSummaryDtoToJson(HomeFeedSummaryDto instance) =>
    <String, dynamic>{
      'totalArticles': instance.totalArticles,
      'totalDirectoryItems': instance.totalDirectoryItems,
      'totalInheritors': instance.totalInheritors,
      'directoryKindCounts': instance.directoryKindCounts,
    };

HomeFeedDto _$HomeFeedDtoFromJson(Map<String, dynamic> json) => HomeFeedDto(
  banners:
      (json['banners'] as List<dynamic>?)
          ?.map((e) => HomeBannerDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  latestNews:
      (json['latestNews'] as List<dynamic>?)
          ?.map((e) => ArticleSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  latestSpecialTopics:
      (json['latestSpecialTopics'] as List<dynamic>?)
          ?.map((e) => ArticleSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  latestForumArticles:
      (json['latestForumArticles'] as List<dynamic>?)
          ?.map((e) => ArticleSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  featuredDirectoryItems:
      (json['featuredDirectoryItems'] as List<dynamic>?)
          ?.map(
            (e) => DirectoryItemSummaryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  featuredInheritors:
      (json['featuredInheritors'] as List<dynamic>?)
          ?.map((e) => InheritorSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  summary: json['summary'] == null
      ? null
      : HomeFeedSummaryDto.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HomeFeedDtoToJson(HomeFeedDto instance) =>
    <String, dynamic>{
      'banners': instance.banners,
      'latestNews': instance.latestNews,
      'latestSpecialTopics': instance.latestSpecialTopics,
      'latestForumArticles': instance.latestForumArticles,
      'featuredDirectoryItems': instance.featuredDirectoryItems,
      'featuredInheritors': instance.featuredInheritors,
      'summary': instance.summary,
    };
