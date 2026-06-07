import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 发现页 - 占位
class DiscoveryPage extends StatelessWidget {
  final ValueChanged<bool>? onDetailChanged;

  const DiscoveryPage({
    super.key,
    this.onDetailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.discoveryTitle),
      ),
      body: Center(
        child: Text(l10n.tabDiscovery),
      ),
    );
  }
}
