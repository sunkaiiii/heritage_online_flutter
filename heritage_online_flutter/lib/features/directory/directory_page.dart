import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 名录列表页 - 占位
class DirectoryPage extends StatelessWidget {
  final ValueChanged<bool>? onDetailChanged;

  const DirectoryPage({
    super.key,
    this.onDetailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.directoryTitle),
      ),
      body: Center(
        child: Text(l10n.tabDirectory),
      ),
    );
  }
}
