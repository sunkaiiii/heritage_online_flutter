import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 传承人列表页 - 占位
class InheritorsPage extends StatelessWidget {
  final ValueChanged<bool>? onDetailChanged;

  const InheritorsPage({
    super.key,
    this.onDetailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inheritorsTitle),
      ),
      body: Center(
        child: Text(l10n.tabInheritors),
      ),
    );
  }
}
