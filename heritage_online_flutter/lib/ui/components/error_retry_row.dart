import 'package:flutter/material.dart';

/// 错误重试行组件
/// 必须有 retry 回调
class ErrorRetryRow extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryText;

  const ErrorRetryRow({
    super.key,
    this.message = '加载失败',
    required this.onRetry,
    this.retryText = '重试',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(retryText),
          ),
        ],
      ),
    );
  }
}
