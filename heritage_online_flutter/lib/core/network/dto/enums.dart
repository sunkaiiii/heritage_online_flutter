import 'package:json_annotation/json_annotation.dart';

/// 文章分类
enum ArticleCategory {
  @JsonValue('news')
  news,

  @JsonValue('forum')
  forum,

  @JsonValue('specialTopic')
  specialTopic;

  String get wireName {
    switch (this) {
      case ArticleCategory.news:
        return 'news';
      case ArticleCategory.forum:
        return 'forum';
      case ArticleCategory.specialTopic:
        return 'specialTopic';
    }
  }

  static ArticleCategory fromWireName(String? value) {
    switch (value) {
      case 'news':
        return ArticleCategory.news;
      case 'forum':
        return ArticleCategory.forum;
      case 'specialTopic':
        return ArticleCategory.specialTopic;
      default:
        return ArticleCategory.news;
    }
  }
}

/// 文章内容块类型
enum ArticleContentBlockType {
  @JsonValue('text')
  text,

  @JsonValue('image')
  image,

  @JsonValue('heading')
  heading;

  String get wireName {
    switch (this) {
      case ArticleContentBlockType.text:
        return 'text';
      case ArticleContentBlockType.image:
        return 'image';
      case ArticleContentBlockType.heading:
        return 'heading';
    }
  }

  static ArticleContentBlockType fromWireName(String? value) {
    switch (value) {
      case 'text':
        return ArticleContentBlockType.text;
      case 'image':
        return ArticleContentBlockType.image;
      case 'heading':
        return ArticleContentBlockType.heading;
      default:
        return ArticleContentBlockType.text;
    }
  }
}

/// 名录种类
enum DirectoryItemKind {
  @JsonValue('nationalProject')
  nationalProject,

  @JsonValue('culturalEcoZone')
  culturalEcoZone,

  @JsonValue('productiveProtectionBase')
  productiveProtectionBase,

  @JsonValue('unescoEntry')
  unescoEntry,

  @JsonValue('chinaUnescoEntry')
  chinaUnescoEntry,

  @JsonValue('contractingState')
  contractingState;

  String get wireName {
    switch (this) {
      case DirectoryItemKind.nationalProject:
        return 'nationalProject';
      case DirectoryItemKind.culturalEcoZone:
        return 'culturalEcoZone';
      case DirectoryItemKind.productiveProtectionBase:
        return 'productiveProtectionBase';
      case DirectoryItemKind.unescoEntry:
        return 'unescoEntry';
      case DirectoryItemKind.chinaUnescoEntry:
        return 'chinaUnescoEntry';
      case DirectoryItemKind.contractingState:
        return 'contractingState';
    }
  }

  static DirectoryItemKind fromWireName(String? value) {
    switch (value) {
      case 'nationalProject':
        return DirectoryItemKind.nationalProject;
      case 'culturalEcoZone':
        return DirectoryItemKind.culturalEcoZone;
      case 'productiveProtectionBase':
        return DirectoryItemKind.productiveProtectionBase;
      case 'unescoEntry':
        return DirectoryItemKind.unescoEntry;
      case 'chinaUnescoEntry':
        return DirectoryItemKind.chinaUnescoEntry;
      case 'contractingState':
        return DirectoryItemKind.contractingState;
      default:
        return DirectoryItemKind.nationalProject;
    }
  }
}

/// 名录统计维度
enum DirectoryStatisticDimension {
  @JsonValue('publishedYear')
  publishedYear,

  @JsonValue('category')
  category,

  @JsonValue('region')
  region,

  @JsonValue('batch')
  batch,

  @JsonValue('listType')
  listType,

  @JsonValue('nominationType')
  nominationType,

  @JsonValue('protectionUnit')
  protectionUnit;

  String get wireName {
    switch (this) {
      case DirectoryStatisticDimension.publishedYear:
        return 'publishedYear';
      case DirectoryStatisticDimension.category:
        return 'category';
      case DirectoryStatisticDimension.region:
        return 'region';
      case DirectoryStatisticDimension.batch:
        return 'batch';
      case DirectoryStatisticDimension.listType:
        return 'listType';
      case DirectoryStatisticDimension.nominationType:
        return 'nominationType';
      case DirectoryStatisticDimension.protectionUnit:
        return 'protectionUnit';
    }
  }

  static DirectoryStatisticDimension fromWireName(String? value) {
    switch (value) {
      case 'publishedYear':
        return DirectoryStatisticDimension.publishedYear;
      case 'category':
        return DirectoryStatisticDimension.category;
      case 'region':
        return DirectoryStatisticDimension.region;
      case 'batch':
        return DirectoryStatisticDimension.batch;
      case 'listType':
        return DirectoryStatisticDimension.listType;
      case 'nominationType':
        return DirectoryStatisticDimension.nominationType;
      case 'protectionUnit':
        return DirectoryStatisticDimension.protectionUnit;
      default:
        return DirectoryStatisticDimension.publishedYear;
    }
  }
}

/// 搜索结果类型
enum SearchResultType {
  @JsonValue('article')
  article,

  @JsonValue('directoryItem')
  directoryItem,

  @JsonValue('inheritor')
  inheritor,

  @JsonValue('collection')
  collection,

  @JsonValue('topic')
  topic;

  String get wireName {
    switch (this) {
      case SearchResultType.article:
        return 'article';
      case SearchResultType.directoryItem:
        return 'directoryItem';
      case SearchResultType.inheritor:
        return 'inheritor';
      case SearchResultType.collection:
        return 'collection';
      case SearchResultType.topic:
        return 'topic';
    }
  }

  static SearchResultType fromWireName(String? value) {
    switch (value) {
      case 'article':
        return SearchResultType.article;
      case 'directoryItem':
        return SearchResultType.directoryItem;
      case 'inheritor':
        return SearchResultType.inheritor;
      case 'collection':
        return SearchResultType.collection;
      case 'topic':
        return SearchResultType.topic;
      default:
        return SearchResultType.article;
    }
  }
}

/// 阅读路径来源
enum ReadingPathSource {
  @JsonValue('blendedRecommendation')
  blendedRecommendation,

  @JsonValue('related')
  related,

  @JsonValue('recommendation')
  recommendation,

  @JsonValue('semanticRecommendation')
  semanticRecommendation,

  @JsonValue('collection')
  collection,

  @JsonValue('graph')
  graph,

  @JsonValue('exploreTopic')
  exploreTopic,

  @JsonValue('list')
  list;

  String get wireName {
    switch (this) {
      case ReadingPathSource.blendedRecommendation:
        return 'blendedRecommendation';
      case ReadingPathSource.related:
        return 'related';
      case ReadingPathSource.recommendation:
        return 'recommendation';
      case ReadingPathSource.semanticRecommendation:
        return 'semanticRecommendation';
      case ReadingPathSource.collection:
        return 'collection';
      case ReadingPathSource.graph:
        return 'graph';
      case ReadingPathSource.exploreTopic:
        return 'exploreTopic';
      case ReadingPathSource.list:
        return 'list';
    }
  }

  static ReadingPathSource fromWireName(String? value) {
    switch (value) {
      case 'blendedRecommendation':
        return ReadingPathSource.blendedRecommendation;
      case 'related':
        return ReadingPathSource.related;
      case 'recommendation':
        return ReadingPathSource.recommendation;
      case 'semanticRecommendation':
        return ReadingPathSource.semanticRecommendation;
      case 'collection':
        return ReadingPathSource.collection;
      case 'graph':
        return ReadingPathSource.graph;
      case 'exploreTopic':
        return ReadingPathSource.exploreTopic;
      case 'list':
        return ReadingPathSource.list;
      default:
        return ReadingPathSource.list;
    }
  }
}
