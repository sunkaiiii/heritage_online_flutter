import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_ui_state.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_view_model.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_page.dart' show InheritorDetailPage;
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/preview/image_preview_overlay.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 名录详情页
class DirectoryDetailPage extends ConsumerWidget {
  final String? itemId;
  final String? sourceId;
  final DirectoryItemKind kind;
  final VoidCallback onBack;

  const DirectoryDetailPage({
    super.key,
    this.itemId,
    this.sourceId,
    this.kind = DirectoryItemKind.nationalProject,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = DirectoryDetailParams(
      itemId: itemId,
      sourceId: sourceId,
      kind: kind,
    );
    final state = ref.watch(directoryDetailViewModelProvider(params));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.directoryDetailTitle),
        actions: [
          // 收藏按钮
          IconButton(
            icon: Icon(
              state.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: state.isFavorite ? Theme.of(context).colorScheme.error : null,
            ),
            tooltip: state.isFavorite ? l10n.actionUnfavorite : l10n.actionFavorite,
            onPressed: () => ref
                .read(directoryDetailViewModelProvider(params).notifier)
                .toggleFavorite(),
          ),
          // 查看原文按钮
          if (state.item?.sourceUrl != null &&
              state.item!.sourceUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              tooltip: l10n.actionViewSource,
              onPressed: () => _launchUrl(context, state.item!.sourceUrl!),
            ),
        ],
      ),
      body: _buildBody(context, ref, state, params, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DirectoryDetailUiState state,
    DirectoryDetailParams params,
    AppLocalizations l10n,
  ) {
    // Loading 状态
    if (state.isLoading && state.item == null) {
      return const PageBackground(
        child: LoadingPlaceholder(),
      );
    }

    // 错误状态
    if (state.error != null && state.item == null) {
      return PageBackground(
        child: ErrorRetryRow(
          message: state.error!,
          onRetry: () => ref
              .read(directoryDetailViewModelProvider(params).notifier)
              .loadItem(),
        ),
      );
    }

    // 名录内容
    final item = state.item!;
    return PageBackground(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero 图片
            _buildHeroImage(context, item, l10n),

            // 内容区域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kind 标签
                  MetaChip(
                    text: localizedDirectoryKind(context, item.kind.wireName) ?? item.kind.wireName,
                  ),

                  const SizedBox(height: 12),

                  // 标题
                  Text(
                    item.title ?? l10n.commonEmpty,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  // 摘要
                  if (item.summary != null && item.summary!.isNotEmpty)
                    Text(
                      item.summary!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),

                  const SizedBox(height: 16),

                  // FactCard - 元信息
                  _buildFactCard(context, item, l10n),

                  const SizedBox(height: 16),

                  // 图库
                  if (item.gallery.isNotEmpty) ...[
                    SectionHeader(title: l10n.directoryDetailGallery),
                    const SizedBox(height: 12),
                    _buildGallery(context, item.gallery, l10n),
                    const SizedBox(height: 16),
                  ],

                  // 正文内容块
                  if (item.contentBlocks.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    ...item.contentBlocks.map(
                      (block) => _buildContentBlock(context, block, l10n),
                    ),
                  ],

                  // 相关项目
                  if (item.relatedProjects.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionHeader(title: l10n.directoryDetailRelatedProjects),
                    const SizedBox(height: 12),
                    ...item.relatedProjects.map(
                      (ref) => _buildRelatedDirectory(context, ref, l10n),
                    ),
                  ],

                  // 相关传承人
                  if (item.relatedInheritors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionHeader(title: l10n.directoryDetailRelatedInheritors),
                    const SizedBox(height: 12),
                    ...item.relatedInheritors.map(
                      (ref) => _buildRelatedInheritor(context, ref, l10n),
                    ),
                  ],

                  // 相关文献
                  if (item.relatedDocuments.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionHeader(title: l10n.directoryDetailRelatedDocuments),
                    const SizedBox(height: 12),
                    ...item.relatedDocuments.map(
                      (ref) => _buildRelatedDocument(context, ref, l10n),
                    ),
                  ],
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
    DirectoryItemDetailDto item,
    AppLocalizations l10n,
  ) {
    final imageUrl = ImageUrlSelector.getListUrl(item.coverImage);
    if (imageUrl == null || imageUrl.isEmpty) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: ImagePlaceholder(text: l10n.brandFallback),
      );
    }

    return GestureDetector(
      onTap: () {
        final previewUrl = ImageUrlSelector.getPreviewUrl(item.coverImage);
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
          fallbackText: item.title ?? '',
        ),
      ),
    );
  }

  Widget _buildFactCard(BuildContext context, DirectoryItemDetailDto item, AppLocalizations l10n) {
    final facts = <HeritageFact>[];
    if (item.category != null && item.category!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelCategory, value: item.category!));
    }
    if (item.region != null && item.region!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelRegion, value: item.region!));
    }
    if (item.projectCode != null && item.projectCode!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelProjectCode, value: item.projectCode!));
    }
    if (item.batch != null && item.batch!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelBatch, value: item.batch!));
    }
    if (item.publishedYear != null) {
      facts.add(HeritageFact(label: l10n.factLabelYear, value: '${item.publishedYear}'));
    }
    if (item.listType != null && item.listType!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelListType, value: item.listType!));
    }
    if (item.nominationType != null && item.nominationType!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelNominationType, value: item.nominationType!));
    }
    if (item.protectionUnit != null && item.protectionUnit!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelProtectionUnit, value: item.protectionUnit!));
    }

    if (facts.isEmpty) return const SizedBox.shrink();
    return FactCard(facts: facts);
  }

  Widget _buildGallery(
    BuildContext context,
    List<MediaAssetDto> gallery,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gallery.length,
        itemBuilder: (context, index) {
          final image = gallery[index];
          final imageUrl = ImageUrlSelector.getListUrl(image);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                final previewUrls = ImageUrlSelector.getPreviewUrls(gallery);
                if (previewUrls.isNotEmpty) {
                  showImagePreview(
                    context: context,
                    imageUrls: previewUrls,
                    initialIndex: index,
                  );
                }
              },
              child: SizedBox(
                width: 120,
                child: imageUrl != null
                    ? ListImage(
                        imageUrl: imageUrl,
                        fallbackText: '${index + 1}',
                      )
                    : ImagePlaceholder(text: '${index + 1}'),
              ),
            ),
          );
        },
      ),
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

  Widget _buildRelatedDirectory(
    BuildContext context,
    DirectoryReferenceDto ref,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReferenceCard(
        title: ref.title ?? '',
        meta: [ref.category, ref.region].where((s) => s != null && s.isNotEmpty).join(' · '),
        onTap: () {
          if (ref.sourceId != null && ref.sourceId!.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DirectoryDetailPage(
                  sourceId: ref.sourceId,
                  kind: DirectoryItemKind.values.firstWhere(
                    (k) => k.wireName == (ref.kind ?? 'nationalProject'),
                    orElse: () => DirectoryItemKind.nationalProject,
                  ),
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildRelatedInheritor(
    BuildContext context,
    DirectoryReferenceDto ref,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReferenceCard(
        title: ref.title ?? '',
        meta: ref.region,
        onTap: () {
          // 导航到传承人详情占位页
          if (ref.sourceId != null && ref.sourceId!.isNotEmpty) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InheritorDetailPage(
                  sourceId: ref.sourceId,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildRelatedDocument(
    BuildContext context,
    DirectoryReferenceDto ref,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ReferenceCard(
        title: ref.title ?? '',
        meta: ref.publishedYear != null ? '${ref.publishedYear}' : null,
        onTap: () {
          if (ref.detailUrl != null && ref.detailUrl!.isNotEmpty) {
            _launchUrl(context, ref.detailUrl!);
          }
        },
      ),
    );
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
}
