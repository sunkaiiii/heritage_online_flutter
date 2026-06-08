import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:heritage_online_flutter/app.dart';
import 'package:heritage_online_flutter/core/settings/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 预加载 SharedPreferences，避免首帧闪默认值
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const HeritageApp(),
    ),
  );
}
