import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/theme/theme.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 组件预览页面
/// 展示所有共享 UI 组件，用于验证组件样式
class ComponentPreviewPage extends ConsumerWidget {
  const ComponentPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件预览'),
        actions: [
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
      body: PageBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // PageHeader
            _buildSectionTitle(context, 'PageHeader'),
            const PageHeader(
              title: 'E迹',
              subtitle: '非遗新闻、论坛与专题',
              actions: [
                Icon(Icons.settings),
              ],
            ),
            const SizedBox(height: 24),

            // SectionHeader
            _buildSectionTitle(context, 'SectionHeader'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: SectionHeader(title: '最新文章'),
            ),
            const SizedBox(height: 24),

            // ContentCard
            _buildSectionTitle(context, 'ContentCard'),
            ContentCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '这是一个普通卡片',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ContentCard 使用 surfaceContainerLow 背景色，圆角 8dp，0 elevation。',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // MetaChip
            _buildSectionTitle(context, 'MetaChip'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                MetaChip(text: '新闻'),
                MetaChip(text: '论坛'),
                MetaChip(text: '专题'),
                MetaChip(text: '国家级项目'),
                MetaChip(text: '文化生态保护区'),
                MetaChip(text: '这是一个很长的标签文本用于测试省略效果'),
              ],
            ),
            const SizedBox(height: 24),

            // ImagePlaceholder
            _buildSectionTitle(context, 'ImagePlaceholder'),
            const SizedBox(
              height: 120,
              child: ImagePlaceholder(text: 'E迹'),
            ),
            const SizedBox(height: 24),

            // ListImage
            _buildSectionTitle(context, 'ListImage'),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 100,
                    child: ListImage(
                      imageUrl: null,
                      fallbackText: '无图',
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: ListImage(
                      imageUrl: 'https://example.com/image.jpg',
                      fallbackText: '加载失败',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ListCard
            _buildSectionTitle(context, 'ListCard (横向)'),
            ListCard(
              onTap: () {},
              image: const SizedBox(
                width: 80,
                height: 80,
                child: ImagePlaceholder(text: '图'),
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MetaChip(text: '新闻'),
                  const SizedBox(height: 6),
                  Text(
                    '文章标题示例',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '摘要文本示例，最多显示两到三行内容。',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle(context, 'ListCard (纵向)'),
            ListCard(
              onTap: () {},
              prominent: true,
              image: const SizedBox(
                height: 120,
                child: ImagePlaceholder(text: '大图'),
              ),
              text: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '这是一个纵向卡片示例',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '摘要文本示例',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FactCard
            _buildSectionTitle(context, 'FactCard'),
            const FactCard(
              facts: [
                HeritageFact(label: '分类', value: '传统技艺'),
                HeritageFact(label: '地区', value: '北京市'),
                HeritageFact(label: '批次', value: '第一批'),
                HeritageFact(label: '级别', value: '国家级'),
              ],
            ),
            const SizedBox(height: 24),

            // ReferenceCard
            _buildSectionTitle(context, 'ReferenceCard'),
            ReferenceCard(
              title: '相关文章标题',
              meta: '2024-01-15 · 新闻',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // SearchField
            _buildSectionTitle(context, 'SearchField'),
            const _SearchFieldDemo(),
            const SizedBox(height: 24),

            // FilterButton
            _buildSectionTitle(context, 'FilterButton'),
            Row(
              children: [
                FilterButton(
                  activeFilterCount: 0,
                  onPressed: () {},
                  tooltip: '筛选',
                ),
                const SizedBox(width: 16),
                FilterButton(
                  activeFilterCount: 3,
                  onPressed: () {},
                  tooltip: '筛选',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ErrorRetryRow
            _buildSectionTitle(context, 'ErrorRetryRow'),
            ErrorRetryRow(
              message: '网络请求失败',
              onRetry: () {},
            ),
            const SizedBox(height: 24),

            // LoadingPlaceholder
            _buildSectionTitle(context, 'LoadingPlaceholder'),
            const LoadingPlaceholder(message: '加载中...'),
            const SizedBox(height: 24),

            // EmptyState
            _buildSectionTitle(context, 'EmptyState'),
            const EmptyState(
              message: '暂无数据',
              icon: Icons.inbox_outlined,
            ),
            const SizedBox(height: 16),
            EmptyState(
              message: '加载失败，请重试',
              icon: Icons.error_outline,
              onRetry: () {},
              retryText: '点击重试',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// SearchField 演示
class _SearchFieldDemo extends StatefulWidget {
  const _SearchFieldDemo();

  @override
  State<_SearchFieldDemo> createState() => _SearchFieldDemoState();
}

class _SearchFieldDemoState extends State<_SearchFieldDemo> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return SearchField(
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
      label: '搜索文章',
      placeholder: '标题或关键词',
      onSearch: (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('搜索: $value')),
        );
      },
    );
  }
}
