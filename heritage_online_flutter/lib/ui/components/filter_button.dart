import 'package:flutter/material.dart';

/// 筛选按钮组件
/// 图标按钮 + badge，用于筛选入口
class FilterButton extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onPressed;
  final String tooltip;

  const FilterButton({
    super.key,
    this.activeFilterCount = 0,
    required this.onPressed,
    this.tooltip = 'Filter',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Badge(
      isLabelVisible: activeFilterCount > 0,
      label: Text(activeFilterCount.toString()),
      backgroundColor: colorScheme.primary,
      textColor: colorScheme.onPrimary,
      child: IconButton(
        icon: const Icon(Icons.filter_list),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
