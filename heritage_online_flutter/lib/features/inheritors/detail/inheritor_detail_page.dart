import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';
import 'package:heritage_online_flutter/ui/components/components.dart';

/// 传承人详情页 - 占位
class InheritorDetailPage extends StatelessWidget {
  final String? inheritorId;
  final String? sourceId;
  final VoidCallback onBack;

  const InheritorDetailPage({
    super.key,
    this.inheritorId,
    this.sourceId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          tooltip: l10n.actionBack,
        ),
        title: Text(l10n.inheritorDetailTitle),
      ),
      body: PageBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people, size: 64),
              const SizedBox(height: 16),
              Text(
                l10n.inheritorDetailTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              if (inheritorId != null)
                Text(
                  'ID: $inheritorId',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (sourceId != null)
                Text(
                  'Source: $sourceId',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
