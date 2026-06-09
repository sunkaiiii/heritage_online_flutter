import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/reading_path/reading_path.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_ui_state.dart';
import 'package:heritage_online_flutter/features/articles/detail/article_detail_view_model.dart';
import 'package:heritage_online_flutter/features/common/detail_explore_view_model.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/preview/image_preview_overlay.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 文章详情页
class ArticleDetailPage extends ConsumerWidget {
  final String? articleId;
  final String? sourceId;
  final String? sourceUrl;
  final ArticleCategory category;
  final VoidCallback onBack;

  const ArticleDetailPage({
    super.key,
    this.articleId,
    this.sourceId,
    this.sourceUrl,
    this.category = ArticleCategory.news,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = ArticleDetailParams(
      articleId: articleId,
      sourceId: sourceId,
      sourceUrl: sourceUrl,
      category: category,
    );
    final state = ref.watch(articleDetailViewModelProvider(params));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.articleDetailTitle),
        actions: [
          // 收藏按钮
          IconButton(
            icon: Icon(
              state.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: state.isFavorite ? Theme.of(context).colorScheme.error : null,
            ),
            tooltip: state.isFavorite ? l10n.actionUnfavorite : l10n.actionFavorite,
            onPressed: () => ref
                .read(articleDetailViewModelProvider(params).notifier)
                .toggleFavorite(),
          ),
          // 查看原文按钮
          if (state.article?.sourceUrl != null &&
              state.article!.sourceUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              tooltip: l10n.actionViewSource,
              onPressed: () => _launchUrl(context, state.article!.sourceUrl!),
            ),
        ],
      ),
      body: _buildBody(context, ref, state, params, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ArticleDetailUiState state,
    ArticleDetailParams params,
    AppLocalizations l10n,
  ) {
    // Loading 状态
    if (state.isLoading && state.article == null) {
      return const PageBackground(
        child: LoadingPlaceholder(),
      );
    }

    // 错误状态
    if (state.error != null && state.article == null) {
      return PageBackground(
        child: ErrorRetryRow(
          message: state.error!,
          onRetry: () => ref
              .read(articleDetailViewModelProvider(params).notifier)
              .loadArticle(),
        ),
      );
    }

    // 文章内容
    final article = state.article!;
    return PageBackground(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stale 提示
            if (state.isStale)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 16,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.contentMayBeStale,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(articleDetailViewModelProvider(params).notifier)
                          .loadArticle(),
                      child: Text(l10n.actionRefresh),
                    ),
                  ],
                ),
              ),

            // Hero 图片
            _buildHeroImage(context, article, l10n),

            // 内容区域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 分类标签
                  MetaChip(text: _getCategoryLabel(l10n, article.category)),

                  const SizedBox(height: 12),

                  // 标题
                  Text(
                    article.title ?? l10n.commonEmpty,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  // 摘要
                  if (article.summary != null && article.summary!.isNotEmpty)
                    Text(
                      article.summary!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),

                  const SizedBox(height: 16),

                  // 元信息
                  _buildMetaInfo(context, article, l10n),

                  const SizedBox(height: 16),

                  // 正文内容块
                  if (article.contentBlocks.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    ...article.contentBlocks.map(
                      (block) => _buildContentBlock(context, block, l10n),
                    ),
                  ],

                  // 相关文章
                  if (article.relatedArticles.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionHeader(title: l10n.articleRelatedTitle),
                    const SizedBox(height: 12),
                    ...article.relatedArticles.map(
                      (relatedRef) => _buildRelatedArticle(context, ref, relatedRef),
                    ),
                  ],

                  // 底部探索区（digest / context / blended）
                  if (article.id != null && article.id!.isNotEmpty)
                    _buildExploreSection(
                        context, ref, article.id!, 'article'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(
    BuildContext context,
    ArticleDetailDto article,
    AppLocalizations l10n,
  ) {
    final imageUrl = ImageUrlSelector.getListUrl(article.coverImage);
    if (imageUrl == null || imageUrl.isEmpty) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: ImagePlaceholder(text: l10n.brandFallback),
      );
    }

    return GestureDetector(
      onTap: () {
        final previewUrl = ImageUrlSelector.getPreviewUrl(article.coverImage);
        if (previewUrl != null && previewUrl.isNotEmpty) {
          showImagePreview(
            context: context,
            imageUrls: [previewUrl],
            initialIndex: 0,
          );
        }
      },
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: ListImage(
          imageUrl: imageUrl,
          fallbackText: article.title ?? '',
        ),
      ),
    );
  }

  Widget _buildMetaInfo(
    BuildContext context,
    ArticleDetailDto article,
    AppLocalizations l10n,
  ) {
    final items = <String>[];
    if (article.author != null && article.author!.isNotEmpty) {
      items.add('${l10n.detailLabelAuthor}：${article.author}');
    }
    if (article.editor != null && article.editor!.isNotEmpty) {
      items.add('${l10n.detailLabelEditor}：${article.editor}');
    }
    if (article.sourceName != null && article.sourceName!.isNotEmpty) {
      items.add('${l10n.detailLabelSource}：${article.sourceName}');
    }
    if (article.publishedAt != null && article.publishedAt!.isNotEmpty) {
      items.add(
        article.publishedAt!.length >= 10
            ? article.publishedAt!.substring(0, 10)
            : article.publishedAt!,
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: items
          .map((item) => Text(
                item,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ))
          .toList(),
    );
  }

  Widget _buildContentBlock(
    BuildContext context,
    ArticleContentBlockDto block,
    AppLocalizations l10n,
  ) {
    switch (block.type) {
      case ArticleContentBlockType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            block.text ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );

      case ArticleContentBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Text(
            block.text ?? '',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        );

      case ArticleContentBlockType.image:
        final imageUrl = ImageUrlSelector.getListUrl(block.image);
        if (imageUrl == null || imageUrl.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: ImagePlaceholder(text: l10n.brandFallback),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              final previewUrl = ImageUrlSelector.getPreviewUrl(block.image);
              if (previewUrl != null && previewUrl.isNotEmpty) {
                showImagePreview(
                  context: context,
                  imageUrls: [previewUrl],
                  initialIndex: 0,
                );
              }
            },
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: ListImage(
                imageUrl: imageUrl,
                fallbackText: '',
              ),
            ),
          ),
        );
    }
  }

  Widget _buildRelatedArticle(
    BuildContext context,
    WidgetRef ref,
    ArticleReferenceDto relatedRef,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReferenceCard(
        title: relatedRef.title ?? '',
        meta: _safeSubstring(relatedRef.publishedAt, 0, 10),
        onTap: () => _navigateToRelatedArticle(ref, context, relatedRef),
      ),
    );
  }

  /// 导航到相关文章
  /// 优先级：sourceId > detailUrl（作为 sourceUrl）> 外部链接
  void _navigateToRelatedArticle(WidgetRef ref, BuildContext context, ArticleReferenceDto articleRef) {
    final hasSourceId = articleRef.sourceId != null && articleRef.sourceId!.isNotEmpty;
    final hasDetailUrl = articleRef.detailUrl != null && articleRef.detailUrl!.isNotEmpty;

    if (!hasSourceId && !hasDetailUrl) return;

    // 记录阅读路径
    final readingRepo = ref.read(readingPathRepositoryProvider);
    final state = ref.read(articleDetailViewModelProvider(ArticleDetailParams(
      articleId: articleId,
      sourceId: sourceId,
      sourceUrl: sourceUrl,
      category: category,
    )));
    final currentArticle = state.article;
    readingRepo.record(ReadingPathEvent(
      fromType: 'article',
      fromId: currentArticle?.id ?? '',
      fromTitle: currentArticle?.title,
      toType: 'article',
      toId: articleRef.sourceId ?? '',
      toTitle: articleRef.title,
      source: 'related',
      toSourceId: articleRef.sourceId,
    ));

    // 构建详情参数
    final params = ArticleDetailParams(
      sourceId: hasSourceId ? articleRef.sourceId : null,
      sourceUrl: !hasSourceId && hasDetailUrl ? articleRef.detailUrl : null,
      category: ArticleCategory.news,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(
          sourceId: params.sourceId,
          sourceUrl: params.sourceUrl,
          category: params.category,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  String? _safeSubstring(String? text, int start, int end) {
    if (text == null) return null;
    if (text.length <= start) return text;
    if (text.length < end) return text.substring(start);
    return text.substring(start, end);
  }

  String _getCategoryLabel(AppLocalizations l10n, ArticleCategory category) {
    switch (category) {
      case ArticleCategory.news:
        return l10n.categoryNews;
      case ArticleCategory.forum:
        return l10n.categoryForum;
      case ArticleCategory.specialTopic:
        return l10n.categorySpecialTopic;
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorOpenUrl)),
        );
      }
    }
  }

  Widget _buildExploreSection(
    BuildContext context,
    WidgetRef ref,
    String contentId,
    String contentType,
  ) {
    final exploreParams = DetailExploreParams(
      id: contentId,
      contentType: contentType,
    );
    final exploreState =
        ref.watch(detailExploreViewModelProvider(exploreParams));
    final exploreVM =
        ref.read(detailExploreViewModelProvider(exploreParams).notifier);

    return DetailExploreSection(
      state: exploreState,
      contentType: contentType,
      contentId: contentId,
      onDigestRetry: () => exploreVM.retryDigest(),
      onContextRetry: () => exploreVM.retryContext(),
      onBlendedRetry: () => exploreVM.retryBlended(),
    );
  }
}
