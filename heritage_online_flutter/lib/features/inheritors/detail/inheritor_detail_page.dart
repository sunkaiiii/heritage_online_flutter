import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/network/dto/content_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/enums.dart';
import 'package:heritage_online_flutter/features/directory/detail/directory_detail_page.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_ui_state.dart';
import 'package:heritage_online_flutter/features/inheritors/detail/inheritor_detail_view_model.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/preview/image_preview_overlay.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';
import 'package:heritage_online_flutter/ui/utils/safe_url_launcher.dart';

/// 传承人详情页
class InheritorDetailPage extends ConsumerWidget {
  final String? inheritorId;
  final String? sourceId;
  final VoidCallback onBack;

  const InheritorDetailPage({
    super.key,
    this.inheritorId,
    this.sourceId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = InheritorDetailParams(
      inheritorId: inheritorId,
      sourceId: sourceId,
    );
    final state = ref.watch(inheritorDetailViewModelProvider(params));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.inheritorDetailTitle),
        actions: [
          // 收藏按钮
          IconButton(
            icon: Icon(
              state.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: state.isFavorite ? Theme.of(context).colorScheme.error : null,
            ),
            tooltip: state.isFavorite ? l10n.actionUnfavorite : l10n.actionFavorite,
            onPressed: () => ref
                .read(inheritorDetailViewModelProvider(params).notifier)
                .toggleFavorite(),
          ),
          // 查看原文按钮
          if (state.item?.sourceUrl != null &&
              state.item!.sourceUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              tooltip: l10n.actionViewSource,
              onPressed: () => SafeUrlLauncher.launch(context, state.item!.sourceUrl!),
            ),
        ],
      ),
      body: _buildBody(context, ref, state, params, l10n),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    InheritorDetailUiState state,
    InheritorDetailParams params,
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
              .read(inheritorDetailViewModelProvider(params).notifier)
              .loadItem(),
        ),
      );
    }

    // 传承人内容
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
                  // 名称
                  Text(
                    item.name ?? l10n.unnamedInheritor,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  // FactCard - 元信息
                  _buildFactCard(context, item, l10n),

                  const SizedBox(height: 16),

                  // 描述
                  if (item.description != null && item.description!.isNotEmpty) ...[
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
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
                    SectionHeader(title: l10n.inheritorRelatedProjectsTitle),
                    const SizedBox(height: 12),
                    ...item.relatedProjects.map(
                      (ref) => _buildRelatedProject(context, ref, l10n),
                    ),
                  ],

                  // 相关传承人
                  if (item.relatedInheritors.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionHeader(title: l10n.inheritorRelatedInheritorsTitle),
                    const SizedBox(height: 12),
                    ...item.relatedInheritors.map(
                      (ref) => _buildRelatedInheritor(context, ref, l10n),
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
    InheritorDetailDto item,
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
          fallbackText: item.name ?? '',
        ),
      ),
    );
  }

  Widget _buildFactCard(BuildContext context, InheritorDetailDto item, AppLocalizations l10n) {
    final facts = <HeritageFact>[];
    if (item.gender != null && item.gender!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelGender, value: item.gender!));
    }
    if (item.birthDateText != null && item.birthDateText!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelBirthDate, value: item.birthDateText!));
    }
    if (item.ethnicity != null && item.ethnicity!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelEthnicity, value: item.ethnicity!));
    }
    if (item.category != null && item.category!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelCategory, value: item.category!));
    }
    if (item.projectName != null && item.projectName!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelRepresentativeProject, value: item.projectName!));
    }
    if (item.projectCode != null && item.projectCode!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelProjectCode, value: item.projectCode!));
    }
    if (item.region != null && item.region!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelRegion, value: item.region!));
    }
    if (item.batch != null && item.batch!.isNotEmpty) {
      facts.add(HeritageFact(label: l10n.factLabelBatch, value: item.batch!));
    }

    if (facts.isEmpty) return const SizedBox.shrink();
    return FactCard(facts: facts);
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

  Widget _buildRelatedProject(
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
          // 导航到相关传承人详情
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
}
