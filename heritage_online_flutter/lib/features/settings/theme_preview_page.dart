import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/theme/theme.dart';

/// Theme Preview 页面
/// 用于验证主题配置是否正确
/// 验收标准：展示背景、普通卡片、chip、section header、primary button、error text
class ThemePreviewPage extends ConsumerWidget {
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Preview'),
        actions: [
          // 主题切换按钮
          PopupMenuButton<AppThemeMode>(
            icon: const Icon(Icons.palette),
            onSelected: (mode) {
              ref.read(themeProvider.notifier).setThemeMode(mode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppThemeMode.system,
                child: Text('跟随系统'),
              ),
              const PopupMenuItem(
                value: AppThemeMode.light,
                child: Text('浅色模式'),
              ),
              const PopupMenuItem(
                value: AppThemeMode.dark,
                child: Text('暗色模式'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 当前主题模式
          _buildSectionHeader(context, '当前主题模式'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '当前: ${themeState.themeMode.name}',
                style: textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 背景展示
          _buildSectionHeader(context, '背景 (Background / Surface)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColorRow(context, 'surface', colorScheme.surface),
                  _buildColorRow(context, 'surfaceContainerLow', colorScheme.surfaceContainerLow),
                  _buildColorRow(context, 'surfaceContainer', colorScheme.surfaceContainer),
                  _buildColorRow(context, 'surfaceContainerHigh', colorScheme.surfaceContainerHigh),
                  _buildColorRow(context, 'surfaceContainerHighest', colorScheme.surfaceContainerHighest),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 普通卡片展示
          _buildSectionHeader(context, '普通卡片 (ContentCard)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('这是一个普通卡片', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    '卡片使用 surfaceContainerLow 背景色，圆角 8dp，0 elevation。',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Chip 展示
          _buildSectionHeader(context, 'Chip 展示'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: const Text('新闻'),
                onDeleted: () {},
              ),
              Chip(
                label: const Text('论坛'),
              ),
              FilterChip(
                label: const Text('专题 (选中)'),
                selected: true,
                onSelected: (value) {},
              ),
              FilterChip(
                label: const Text('名录'),
                selected: false,
                onSelected: (value) {},
              ),
              ActionChip(
                label: const Text('操作'),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Section Header 展示
          _buildSectionHeader(context, 'Section Header 展示'),
          _buildSectionHeader(context, '最新文章'),
          Card(
            child: ListTile(
              title: const Text('文章标题示例'),
              subtitle: const Text('摘要文本示例'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),

          // Primary Button 展示
          _buildSectionHeader(context, 'Primary Button 展示'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Filled Button'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined Button'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Text Button'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Error Text 展示
          _buildSectionHeader(context, 'Error Text 展示'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '这是一条错误消息',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '错误文本使用 error color，确保在浅色和暗色模式下都可读。',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error),
                      const SizedBox(width: 8),
                      Text(
                        '错误图标',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Typography 展示
          _buildSectionHeader(context, 'Typography 展示'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Small', style: textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Text('Headline Large', style: textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text('Headline Medium', style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Headline Small', style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Title Large', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Title Medium', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Body Large - 详情正文', style: textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Body Medium - 摘要、meta', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Label Large', style: textTheme.labelLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Color Scheme 展示
          _buildSectionHeader(context, 'Color Scheme 展示'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColorRow(context, 'primary', colorScheme.primary),
                  _buildColorRow(context, 'onPrimary', colorScheme.onPrimary),
                  _buildColorRow(context, 'primaryContainer', colorScheme.primaryContainer),
                  _buildColorRow(context, 'onPrimaryContainer', colorScheme.onPrimaryContainer),
                  _buildColorRow(context, 'secondary', colorScheme.secondary),
                  _buildColorRow(context, 'secondaryContainer', colorScheme.secondaryContainer),
                  _buildColorRow(context, 'tertiary', colorScheme.tertiary),
                  _buildColorRow(context, 'tertiaryContainer', colorScheme.tertiaryContainer),
                  _buildColorRow(context, 'onSurface', colorScheme.onSurface),
                  _buildColorRow(context, 'onSurfaceVariant', colorScheme.onSurfaceVariant),
                  _buildColorRow(context, 'outline', colorScheme.outline),
                  _buildColorRow(context, 'outlineVariant', colorScheme.outlineVariant),
                  _buildColorRow(context, 'error', colorScheme.error),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Divider 展示
          _buildSectionHeader(context, 'Divider 展示'),
          const Divider(),
          const SizedBox(height: 8),
          const Divider(height: 4, thickness: 2),
          const SizedBox(height: 24),

          // 底部留白
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// 构建 Section Header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Divider(
            color: Theme.of(context).colorScheme.outlineVariant,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  /// 构建颜色行
  Widget _buildColorRow(BuildContext context, String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
        ],
      ),
    );
  }
}
