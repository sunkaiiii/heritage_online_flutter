import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heritage_online_flutter/core/data/repository_provider.dart';
import 'package:heritage_online_flutter/core/network/dto/compare_dtos.dart';
import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 对比类型
enum CompareType { region, category, kind }

/// 对比页
class ComparePage extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const ComparePage({super.key, required this.onBack});

  @override
  ConsumerState<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends ConsumerState<ComparePage> {
  CompareType _selectedType = CompareType.region;
  final _leftController = TextEditingController();
  final _rightController = TextEditingController();
  CompareResultDto? _result;
  bool _isLoading = false;
  String? _error;
  String? _validationError;

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  Future<void> _compare() async {
    final l10n = AppLocalizations.of(context)!;
    final left = _leftController.text.trim();
    final right = _rightController.text.trim();

    // 校验
    if (left.isEmpty || right.isEmpty) {
      setState(() => _validationError = l10n.compareValidationEmpty);
      return;
    }
    if (left == right) {
      setState(() => _validationError = l10n.compareValidationSame);
      return;
    }

    setState(() {
      _validationError = null;
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final repo = ref.read(heritageRepositoryProvider);
      CompareResultDto result;
      switch (_selectedType) {
        case CompareType.region:
          result = await repo.compareRegions(left, right);
          break;
        case CompareType.category:
          result = await repo.compareCategories(left, right);
          break;
        case CompareType.kind:
          result = await repo.compareKinds(left, right);
          break;
      }
      if (mounted) setState(() { _result = result; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.compareTitle),
      ),
      body: PageBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 类型选择
            SegmentedButton<CompareType>(
              segments: [
                ButtonSegment(
                    value: CompareType.region,
                    label: Text(l10n.compareTypeRegion)),
                ButtonSegment(
                    value: CompareType.category,
                    label: Text(l10n.compareTypeCategory)),
                ButtonSegment(
                    value: CompareType.kind,
                    label: Text(l10n.compareTypeKind)),
              ],
              selected: {_selectedType},
              onSelectionChanged: (types) =>
                  setState(() => _selectedType = types.first),
            ),
            const SizedBox(height: 16),

            // 输入区
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _leftController,
                    decoration: InputDecoration(
                      labelText: l10n.compareLeftLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _rightController,
                    decoration: InputDecoration(
                      labelText: l10n.compareRightLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            // 校验错误
            if (_validationError != null) ...[
              const SizedBox(height: 8),
              Text(_validationError!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      )),
            ],

            const SizedBox(height: 16),

            // 对比按钮
            FilledButton.icon(
              onPressed: _isLoading ? null : _compare,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.compare_arrows),
              label: Text(l10n.compareStartButton),
            ),

            // 错误
            if (_error != null) ...[
              const SizedBox(height: 16),
              ErrorRetryRow(
                message: l10n.commonError,
                onRetry: _compare,
              ),
            ],

            // 结果
            if (_result != null) ...[
              const SizedBox(height: 24),
              _CompareResult(result: _result!, l10n: l10n),
            ],
          ],
        ),
      ),
    );
  }
}

/// 对比结果展示
class _CompareResult extends StatelessWidget {
  final CompareResultDto result;
  final AppLocalizations l10n;

  const _CompareResult({required this.result, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左右概览
        Row(
          children: [
            Expanded(child: _SideCard(side: result.left, isLeft: true, l10n: l10n)),
            const SizedBox(width: 12),
            Expanded(child: _SideCard(side: result.right, isLeft: false, l10n: l10n)),
          ],
        ),
        const SizedBox(height: 20),

        // 共同分类
        if (result.sharedCategories.isNotEmpty) ...[
          Text(l10n.compareSharedCategories,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: result.sharedCategories
                .map((c) => MetaChip(text: c))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],

        // 左侧独有
        if (result.leftUniqueCategories.isNotEmpty) ...[
          Text(l10n.compareUniqueLeft,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: result.leftUniqueCategories
                .map((c) => MetaChip(text: c))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],

        // 右侧独有
        if (result.rightUniqueCategories.isNotEmpty) ...[
          Text(l10n.compareUniqueRight,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: result.rightUniqueCategories
                .map((c) => MetaChip(text: c))
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// 对比单侧卡片
class _SideCard extends StatelessWidget {
  final CompareSideDto side;
  final bool isLeft;
  final AppLocalizations l10n;

  const _SideCard({
    required this.side,
    required this.isLeft,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ContentCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(side.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isLeft
                        ? colorScheme.primary
                        : colorScheme.tertiary,
                  )),
          const SizedBox(height: 8),
          _buildStat(context, '${side.total}', l10n.compareStatTotal),
          _buildStat(context, '${side.directoryItemCount}', l10n.taxonomyDirectoryItems),
          _buildStat(context, '${side.inheritorCount}', l10n.taxonomyInheritors),
          _buildStat(context, '${side.articleCount}', l10n.taxonomyArticles),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
        ],
      ),
    );
  }
}
