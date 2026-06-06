import 'package:flutter/material.dart';

/// 页面背景组件
/// 使用 theme 的 background 色，确保每页背景一致
class PageBackground extends StatelessWidget {
  final Widget child;

  const PageBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }
}
