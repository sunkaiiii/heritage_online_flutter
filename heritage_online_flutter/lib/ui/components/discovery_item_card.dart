import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/core/network/dto/discovery_dtos.dart';
import 'package:heritage_online_flutter/core/utils/content_labels.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

/// 发现页内容卡片（横向 220dp 宽）
/// 用于 Today/Trending/Weekly 等区块的横向滚动列表
class DiscoveryItemCard extends StatelessWidget {
  final String? id;
  final String? type;
  final String title;
  final String? summary;
  final String? category;
  final String? region;
  final MediaAssetDto? coverImage;
  final VoidCallback? onTap;

  const DiscoveryItemCard({
    super.key,
    this.id,
    this.type,
    required this.title,
    this.summary,
    this.category,
    this.region,
    this.coverImage,
    this.onTap,
  });

  /// 从 DiscoveryItemDto 直接构建（推荐，避免序列化开销）
  factory DiscoveryItemCard.fromDto(DiscoveryItemDto item, {VoidCallback? onTap}) {
    return DiscoveryItemCard(
      id: item.id,
      type: item.type,
      title: item.title ?? '',
      summary: item.summary,
      category: item.category,
      region: item.region,
      coverImage: item.coverImage,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(coverImage);

    return SizedBox(
      width: 220,
      child: ContentCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: imageUrl != null
                    ? ListImage(imageUrl: imageUrl, fallbackText: title.isNotEmpty ? title.substring(0, 1) : '')
                    : ImagePlaceholder(
                        text: title.isNotEmpty ? title.substring(0, 1) : '',
                      ),
              ),
            ),

            // 文本区域（使用 Expanded 约束高度）
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (summary != null && summary!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          summary!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        if (type != null && type!.isNotEmpty)
                          MetaChip(
                              text: localizedContentType(context, type!) ?? type!),
                        if (category != null && category!.isNotEmpty)
                          MetaChip(text: category!),
                        if (region != null && region!.isNotEmpty)
                          MetaChip(text: region!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 发现页内容行（横向图文布局）
/// 用于 Today 区块的 featuredDirectoryItem / featuredInheritor
class DiscoveryItemRow extends StatelessWidget {
  final String? id;
  final String? type;
  final String title;
  final String? summary;
  final String? category;
  final String? region;
  final MediaAssetDto? coverImage;
  final VoidCallback? onTap;

  const DiscoveryItemRow({
    super.key,
    this.id,
    this.type,
    required this.title,
    this.summary,
    this.category,
    this.region,
    this.coverImage,
    this.onTap,
  });

  /// 从 DiscoveryItemDto 直接构建（推荐，避免序列化开销）
  factory DiscoveryItemRow.fromDto(DiscoveryItemDto item, {VoidCallback? onTap}) {
    return DiscoveryItemRow(
      id: item.id,
      type: item.type,
      title: item.title ?? '',
      summary: item.summary,
      category: item.category,
      region: item.region,
      coverImage: item.coverImage,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ImageUrlSelector.getListUrl(coverImage);

    return ContentCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 左侧缩略图
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 72,
              height: 72,
              child: imageUrl != null
                  ? ListImage(imageUrl: imageUrl, fallbackText: title.isNotEmpty ? title.substring(0, 1) : '')
                  : ImagePlaceholder(
                      text: title.isNotEmpty ? title.substring(0, 1) : '',
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // 右侧文本
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (summary != null && summary!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    summary!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    if (type != null && type!.isNotEmpty)
                      MetaChip(
                          text: localizedContentType(context, type!) ?? type!),
                    if (category != null && category!.isNotEmpty)
                      MetaChip(text: category!),
                    if (region != null && region!.isNotEmpty)
                      MetaChip(text: region!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
