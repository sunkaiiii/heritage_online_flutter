import 'package:flutter/material.dart';

import 'content_card.dart';

/// 引用卡片组件
/// 相关内容卡片，用于详情页 related 列表
class ReferenceCard extends StatelessWidget {
  final String title;
  final String? meta;
  final VoidCallback? onTap;

  const ReferenceCard({
    super.key,
    required this.title,
    this.meta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ContentCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (meta != null && meta!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              meta!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
