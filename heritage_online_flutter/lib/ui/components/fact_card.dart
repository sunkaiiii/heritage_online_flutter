import 'package:flutter/material.dart';

import 'content_card.dart';

/// 事实数据
class HeritageFact {
  final String label;
  final String value;

  const HeritageFact({
    required this.label,
    required this.value,
  });
}

/// 事实卡片组件
/// label/value 两列事实表，用于详情页元信息
class FactCard extends StatelessWidget {
  final List<HeritageFact> facts;

  const FactCard({
    super.key,
    required this.facts,
  });

  @override
  Widget build(BuildContext context) {
    if (facts.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ContentCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(facts.length, (index) {
          final fact = facts[index];
          final isLast = index == facts.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    fact.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fact.value,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
