import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';

void main() {
  group('ArticleCategory', () {
    test('wireName should match backend values', () {
      expect(ArticleCategory.news.wireName, 'news');
      expect(ArticleCategory.forum.wireName, 'forum');
      expect(ArticleCategory.specialTopic.wireName, 'specialTopic');
    });

    test('fromWireName should parse correctly', () {
      expect(ArticleCategory.fromWireName('news'), ArticleCategory.news);
      expect(ArticleCategory.fromWireName('forum'), ArticleCategory.forum);
      expect(ArticleCategory.fromWireName('specialTopic'), ArticleCategory.specialTopic);
    });

    test('fromWireName should default to news for unknown', () {
      expect(ArticleCategory.fromWireName('unknown'), ArticleCategory.news);
      expect(ArticleCategory.fromWireName(null), ArticleCategory.news);
    });
  });

  group('DirectoryItemKind', () {
    test('wireName should match backend values', () {
      expect(DirectoryItemKind.nationalProject.wireName, 'nationalProject');
      expect(DirectoryItemKind.culturalEcoZone.wireName, 'culturalEcoZone');
      expect(DirectoryItemKind.productiveProtectionBase.wireName, 'productiveProtectionBase');
      expect(DirectoryItemKind.unescoEntry.wireName, 'unescoEntry');
      expect(DirectoryItemKind.chinaUnescoEntry.wireName, 'chinaUnescoEntry');
      expect(DirectoryItemKind.contractingState.wireName, 'contractingState');
    });

    test('fromWireName should parse correctly', () {
      expect(DirectoryItemKind.fromWireName('nationalProject'), DirectoryItemKind.nationalProject);
      expect(DirectoryItemKind.fromWireName('culturalEcoZone'), DirectoryItemKind.culturalEcoZone);
      expect(DirectoryItemKind.fromWireName('productiveProtectionBase'), DirectoryItemKind.productiveProtectionBase);
      expect(DirectoryItemKind.fromWireName('unescoEntry'), DirectoryItemKind.unescoEntry);
      expect(DirectoryItemKind.fromWireName('chinaUnescoEntry'), DirectoryItemKind.chinaUnescoEntry);
      expect(DirectoryItemKind.fromWireName('contractingState'), DirectoryItemKind.contractingState);
    });

    test('fromWireName should default to nationalProject for unknown', () {
      expect(DirectoryItemKind.fromWireName('unknown'), DirectoryItemKind.nationalProject);
      expect(DirectoryItemKind.fromWireName(null), DirectoryItemKind.nationalProject);
    });
  });

  group('ArticleSummaryDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'article-123',
        'category': 'news',
        'title': '非遗保护新进展',
        'summary': '摘要内容...',
        'publishedAt': '2024-01-15T10:00:00Z',
        'coverImage': {
          'sourceUrl': 'https://example.com/image.jpg',
          'displayUrl': 'https://example.com/display.jpg',
        },
        'sourceUrl': 'https://example.com/article',
      };

      final dto = ArticleSummaryDto.fromJson(json);

      expect(dto.id, 'article-123');
      expect(dto.category, ArticleCategory.news);
      expect(dto.title, '非遗保护新进展');
      expect(dto.summary, '摘要内容...');
      expect(dto.publishedAt, '2024-01-15T10:00:00Z');
      expect(dto.coverImage, isNotNull);
      expect(dto.coverImage!.sourceUrl, 'https://example.com/image.jpg');
      expect(dto.sourceUrl, 'https://example.com/article');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ArticleSummaryDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.category, ArticleCategory.news);
      expect(dto.title, isNull);
      expect(dto.summary, isNull);
      expect(dto.publishedAt, isNull);
      expect(dto.coverImage, isNull);
      expect(dto.sourceUrl, isNull);
    });

    test('should default to news for unknown category', () {
      final json = {
        'id': 'article-123',
        'category': 'unknownCategory',
      };

      // 不应崩溃，应默认回退到 news
      final dto = ArticleSummaryDto.fromJson(json);
      expect(dto.category, ArticleCategory.news);
    });
  });

  group('ArticleDetailDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'article-123',
        'category': 'specialTopic',
        'title': '专题文章',
        'summary': '摘要',
        'publishedAt': '2024-01-15',
        'coverImage': {'sourceUrl': 'https://example.com/img.jpg'},
        'sourceUrl': 'https://example.com',
        'sourceName': '来源',
        'author': '作者',
        'editor': '编辑',
        'contentBlocks': [
          {'type': 'text', 'text': '正文内容'},
          {'type': 'image', 'image': {'sourceUrl': 'https://example.com/img.jpg'}},
        ],
        'relatedArticles': [
          {'title': '相关文章', 'detailUrl': '/api/articles/456'},
        ],
      };

      final dto = ArticleDetailDto.fromJson(json);

      expect(dto.id, 'article-123');
      expect(dto.category, ArticleCategory.specialTopic);
      expect(dto.title, '专题文章');
      expect(dto.author, '作者');
      expect(dto.editor, '编辑');
      expect(dto.contentBlocks.length, 2);
      expect(dto.contentBlocks[0].type, ArticleContentBlockType.text);
      expect(dto.contentBlocks[0].text, '正文内容');
      expect(dto.contentBlocks[1].type, ArticleContentBlockType.image);
      expect(dto.relatedArticles.length, 1);
      expect(dto.relatedArticles[0].title, '相关文章');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = ArticleDetailDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.category, ArticleCategory.news);
      expect(dto.contentBlocks, isEmpty);
      expect(dto.relatedArticles, isEmpty);
    });
  });

  group('DirectoryItemSummaryDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'dir-123',
        'kind': 'nationalProject',
        'title': '昆曲',
        'summary': '摘要',
        'category': '传统戏剧',
        'region': '北京市',
        'projectCode': 'IV-1',
        'batch': '第一批',
        'publishedYear': 2006,
        'listType': 'representative',
        'coverImage': {'sourceUrl': 'https://example.com/img.jpg'},
        'sourceUrl': 'https://example.com',
      };

      final dto = DirectoryItemSummaryDto.fromJson(json);

      expect(dto.id, 'dir-123');
      expect(dto.kind, DirectoryItemKind.nationalProject);
      expect(dto.title, '昆曲');
      expect(dto.category, '传统戏剧');
      expect(dto.region, '北京市');
      expect(dto.projectCode, 'IV-1');
      expect(dto.batch, '第一批');
      expect(dto.publishedYear, 2006);
      expect(dto.listType, 'representative');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = DirectoryItemSummaryDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.kind, DirectoryItemKind.nationalProject);
      expect(dto.title, isNull);
      expect(dto.publishedYear, isNull);
    });
  });

  group('DirectoryItemDetailDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'dir-123',
        'kind': 'culturalEcoZone',
        'title': '文化生态保护实验区',
        'category': '文化生态区',
        'region': '安徽省',
        'nominationType': '国家级',
        'protectionUnit': '保护中心',
        'gallery': [
          {'sourceUrl': 'https://example.com/img1.jpg'},
          {'sourceUrl': 'https://example.com/img2.jpg'},
        ],
        'contentBlocks': [
          {'type': 'text', 'text': '正文'},
        ],
        'relatedProjects': [
          {'title': '相关项目', 'kind': 'nationalProject'},
        ],
        'relatedInheritors': [
          {'title': '相关传承人'},
        ],
        'relatedDocuments': [
          {'title': '相关文献'},
        ],
      };

      final dto = DirectoryItemDetailDto.fromJson(json);

      expect(dto.id, 'dir-123');
      expect(dto.kind, DirectoryItemKind.culturalEcoZone);
      expect(dto.gallery.length, 2);
      expect(dto.contentBlocks.length, 1);
      expect(dto.relatedProjects.length, 1);
      expect(dto.relatedInheritors.length, 1);
      expect(dto.relatedDocuments.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = DirectoryItemDetailDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.gallery, isEmpty);
      expect(dto.contentBlocks, isEmpty);
      expect(dto.relatedProjects, isEmpty);
      expect(dto.relatedInheritors, isEmpty);
      expect(dto.relatedDocuments, isEmpty);
    });
  });

  group('InheritorSummaryDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'inh-123',
        'name': '张三',
        'gender': '男',
        'birthDateText': '1950年',
        'ethnicity': '汉族',
        'category': '传统技艺',
        'projectCode': 'VIII-1',
        'projectName': '景泰蓝制作技艺',
        'region': '北京市',
        'batch': '第一批',
        'description': '传承人简介',
        'coverImage': {'sourceUrl': 'https://example.com/img.jpg'},
        'sourceUrl': 'https://example.com',
      };

      final dto = InheritorSummaryDto.fromJson(json);

      expect(dto.id, 'inh-123');
      expect(dto.name, '张三');
      expect(dto.gender, '男');
      expect(dto.birthDateText, '1950年');
      expect(dto.ethnicity, '汉族');
      expect(dto.category, '传统技艺');
      expect(dto.projectCode, 'VIII-1');
      expect(dto.projectName, '景泰蓝制作技艺');
      expect(dto.region, '北京市');
      expect(dto.batch, '第一批');
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = InheritorSummaryDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.name, isNull);
      expect(dto.gender, isNull);
      expect(dto.coverImage, isNull);
    });
  });

  group('InheritorDetailDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'inh-123',
        'name': '张三',
        'gender': '男',
        'contentBlocks': [
          {'type': 'text', 'text': '详细描述'},
        ],
        'relatedProjects': [
          {'title': '相关项目'},
        ],
        'relatedInheritors': [
          {'title': '相关传承人'},
        ],
      };

      final dto = InheritorDetailDto.fromJson(json);

      expect(dto.id, 'inh-123');
      expect(dto.name, '张三');
      expect(dto.contentBlocks.length, 1);
      expect(dto.relatedProjects.length, 1);
      expect(dto.relatedInheritors.length, 1);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = InheritorDetailDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.contentBlocks, isEmpty);
      expect(dto.relatedProjects, isEmpty);
      expect(dto.relatedInheritors, isEmpty);
    });
  });

  group('HomeBannerDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'id': 'banner-1',
        'sortOrder': 1,
        'targetUrl': 'https://example.com/article',
        'displayImage': {'sourceUrl': 'https://example.com/display.jpg'},
        'mobileImage': {'sourceUrl': 'https://example.com/mobile.jpg'},
        'desktopImage': {'sourceUrl': 'https://example.com/desktop.jpg'},
      };

      final dto = HomeBannerDto.fromJson(json);

      expect(dto.id, 'banner-1');
      expect(dto.sortOrder, 1);
      expect(dto.targetUrl, 'https://example.com/article');
      expect(dto.displayImage, isNotNull);
      expect(dto.mobileImage, isNotNull);
      expect(dto.desktopImage, isNotNull);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = HomeBannerDto.fromJson(json);

      expect(dto.id, isNull);
      expect(dto.sortOrder, 0);
      expect(dto.displayImage, isNull);
      expect(dto.mobileImage, isNull);
      expect(dto.desktopImage, isNull);
    });

    test('bestImage should return mobileImage first', () {
      const dto = HomeBannerDto(
        mobileImage: MediaAssetDto(sourceUrl: 'mobile'),
        displayImage: MediaAssetDto(sourceUrl: 'display'),
        desktopImage: MediaAssetDto(sourceUrl: 'desktop'),
      );

      expect(dto.bestImage?.sourceUrl, 'mobile');
    });

    test('bestImage should fallback to displayImage', () {
      const dto = HomeBannerDto(
        displayImage: MediaAssetDto(sourceUrl: 'display'),
        desktopImage: MediaAssetDto(sourceUrl: 'desktop'),
      );

      expect(dto.bestImage?.sourceUrl, 'display');
    });
  });

  group('HomeFeedDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'banners': [
          {'id': 'banner-1', 'sortOrder': 1},
        ],
        'latestNews': [
          {'id': 'article-1', 'title': '新闻1'},
        ],
        'latestSpecialTopics': [
          {'id': 'article-2', 'title': '专题1', 'category': 'specialTopic'},
        ],
        'latestForumArticles': [
          {'id': 'article-3', 'title': '论坛1', 'category': 'forum'},
        ],
        'featuredDirectoryItems': [
          {'id': 'dir-1', 'title': '名录1'},
        ],
        'featuredInheritors': [
          {'id': 'inh-1', 'name': '传承人1'},
        ],
        'summary': {
          'totalArticles': 100,
          'totalDirectoryItems': 50,
          'totalInheritors': 30,
          'directoryKindCounts': {'nationalProject': 20, 'culturalEcoZone': 10},
        },
      };

      final dto = HomeFeedDto.fromJson(json);

      expect(dto.banners.length, 1);
      expect(dto.latestNews.length, 1);
      expect(dto.latestSpecialTopics.length, 1);
      expect(dto.latestForumArticles.length, 1);
      expect(dto.featuredDirectoryItems.length, 1);
      expect(dto.featuredInheritors.length, 1);
      expect(dto.summary, isNotNull);
      expect(dto.summary!.totalArticles, 100);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = HomeFeedDto.fromJson(json);

      expect(dto.banners, isEmpty);
      expect(dto.latestNews, isEmpty);
      expect(dto.latestSpecialTopics, isEmpty);
      expect(dto.latestForumArticles, isEmpty);
      expect(dto.featuredDirectoryItems, isEmpty);
      expect(dto.featuredInheritors, isEmpty);
      expect(dto.summary, isNull);
    });
  });

  group('DirectoryStatisticsOverviewDto', () {
    test('should parse from JSON with all fields', () {
      final json = {
        'kind': 'nationalProject',
        'total': 1500,
        'generatedAt': '2024-01-15T10:00:00Z',
        'dimensions': [
          {
            'dimension': 'region',
            'items': [
              {'key': '北京市', 'name': '北京市', 'value': 100},
            ],
          },
        ],
      };

      final dto = DirectoryStatisticsOverviewDto.fromJson(json);

      expect(dto.kind, 'nationalProject');
      expect(dto.total, 1500);
      expect(dto.dimensions.length, 1);
      expect(dto.dimensions[0].dimension, 'region');
      expect(dto.dimensions[0].items.length, 1);
      expect(dto.dimensions[0].items[0].key, '北京市');
      expect(dto.dimensions[0].items[0].value, 100);
    });

    test('should use defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = DirectoryStatisticsOverviewDto.fromJson(json);

      expect(dto.kind, isNull);
      expect(dto.total, 0);
      expect(dto.dimensions, isEmpty);
    });
  });

  group('JSON serialization round-trip', () {
    test('ArticleSummaryDto should survive round-trip', () {
      const original = ArticleSummaryDto(
        id: 'article-123',
        category: ArticleCategory.specialTopic,
        title: '测试文章',
        summary: '摘要',
      );

      final json = original.toJson();
      final restored = ArticleSummaryDto.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.category, original.category);
      expect(restored.title, original.title);
      expect(restored.summary, original.summary);
    });

    test('DirectoryItemSummaryDto should survive round-trip', () {
      const original = DirectoryItemSummaryDto(
        id: 'dir-123',
        kind: DirectoryItemKind.unescoEntry,
        title: '名录项目',
      );

      final json = original.toJson();
      final restored = DirectoryItemSummaryDto.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.kind, original.kind);
      expect(restored.title, original.title);
    });

    test('InheritorSummaryDto should survive round-trip', () {
      const original = InheritorSummaryDto(
        id: 'inh-123',
        name: '传承人',
        gender: '男',
      );

      final json = original.toJson();
      final restored = InheritorSummaryDto.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.gender, original.gender);
    });
  });
}
