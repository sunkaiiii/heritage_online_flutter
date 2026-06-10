import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 安全的 URL 打开工具
/// 处理非法 URL、缺少 scheme、平台异常等情况
/// 所有用户可见文案通过 AppLocalizations 本地化
class SafeUrlLauncher {
  SafeUrlLauncher._();

  /// 安全打开 URL
  /// 返回 true 表示成功打开，false 表示失败
  static Future<bool> launch(
    BuildContext context,
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final l10n = AppLocalizations.of(context);

    try {
      final trimmed = url.trim();
      if (trimmed.isEmpty) {
        if (context.mounted) {
          _showError(context, l10n?.urlLaunchEmpty ?? 'URL is empty');
        }
        return false;
      }

      // 尝试解析 URL
      var uri = Uri.tryParse(trimmed);
      if (uri == null) {
        if (context.mounted) {
          _showError(context, l10n?.urlLaunchInvalid ?? 'Invalid URL format');
        }
        return false;
      }

      // 校验 scheme
      if (uri.scheme.isEmpty) {
        // 尝试补 https://
        uri = Uri.tryParse('https://$trimmed');
        if (uri == null) {
          if (context.mounted) {
            _showError(context, l10n?.urlLaunchInvalid ?? 'Invalid URL format');
          }
          return false;
        }
      }

      // 只允许 http/https
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        if (context.mounted) {
          _showError(context, l10n?.urlLaunchUnsupportedScheme ?? 'Unsupported URL scheme');
        }
        return false;
      }

      // 检查是否可以打开
      final canLaunchResult = await canLaunchUrl(uri);
      if (!canLaunchResult) {
        if (context.mounted) {
          _showError(context, l10n?.urlLaunchCannotOpen ?? 'Cannot open URL');
        }
        return false;
      }

      // 打开链接
      await launchUrl(uri, mode: mode);
      return true;
    } catch (e) {
      if (context.mounted) {
        _showError(context, l10n?.urlLaunchFailed ?? 'Failed to open URL');
      }
      return false;
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
