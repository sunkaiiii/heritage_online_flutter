import 'package:flutter/material.dart';

/// 图片占位组件
/// 圆角 8dp，占位背景 surfaceContainerHigh，中间粗体 label
class ImagePlaceholder extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;

  const ImagePlaceholder({
    super.key,
    required this.text,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.82),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
