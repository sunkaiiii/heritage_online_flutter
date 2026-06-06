import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 名录列表页 - 占位（Step 0）
class DirectoryPage extends StatelessWidget {
  const DirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Text(l10n.tabDirectory),
      ),
    );
  }
}
