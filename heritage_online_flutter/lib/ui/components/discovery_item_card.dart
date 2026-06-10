import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
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

  /// 从动态 JSON Map 构建
  factory DiscoveryItemCard.fromMap(Map<String, dynamic> map, {VoidCallback? onTap}) {
    return DiscoveryItemCard(
      id: map['id']?.toString(),
      type: map['type']?.toString(),
      title: map['title']?.toString() ?? '',
      summary: map['summary']?.toString(),
      category: map['category']?.toString(),
      region: map['region']?.toString(),
      coverImage: map['coverImage'] != null
          ? MediaAssetDto.fromJson(Map<String, dynamic>.from(map['coverImage'] as Map))
          : null,
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
                height: 118,
                width: double.infinity,
                child: imageUrl != null
                    ? ListImage(imageUrl: imageUrl, fallbackText: title.isNotEmpty ? title.substring(0, 1) : '')
                    : ImagePlaceholder(
                        text: title.isNotEmpty ? title.substring(0, 1) : '',
                      ),
              ),
            ),

            // 文本区域
            Padding(
              padding: const EdgeInsets.all(12),
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

  /// 从动态 JSON Map 构建
  factory DiscoveryItemRow.fromMap(Map<String, dynamic> map, {VoidCallback? onTap}) {
    return DiscoveryItemRow(
      id: map['id']?.toString(),
      type: map['type']?.toString(),
      title: map['title']?.toString() ?? '',
      summary: map['summary']?.toString(),
      category: map['category']?.toString(),
      region: map['region']?.toString(),
      coverImage: map['coverImage'] != null
          ? MediaAssetDto.fromJson(Map<String, dynamic>.from(map['coverImage'] as Map))
          : null,
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
