/// URL 编码工具
/// 用于安全编码 path segment，特别是中文、空格、斜杠、特殊符号
class UrlEncoder {
  UrlEncoder._();

  /// 编码 path segment
  /// 将中文、空格、斜杠、特殊符号等进行安全编码
  static String encodePathSegment(String value) {
    // 使用 Uri.encodeComponent 进行编码
    // 这会编码所有非字母数字字符，除了 - _ . ! ~ * ' ( )
    return Uri.encodeComponent(value);
  }

  /// 编码完整的 URL path
  /// 对每个 path segment 分别编码
  static String encodePath(String path) {
    final segments = path.split('/');
    final encodedSegments = segments.map((segment) {
      if (segment.isEmpty) return segment;
      return encodePathSegment(segment);
    });
    return encodedSegments.join('/');
  }

  /// 构建查询参数字符串
  /// 过滤掉 null 和空字符串的参数
  static String buildQueryString(Map<String, dynamic> params) {
    final validParams = <String, String>{};

    for (final entry in params.entries) {
      if (entry.value != null) {
        final value = entry.value.toString();
        if (value.isNotEmpty) {
          validParams[entry.key] = value;
        }
      }
    }

    if (validParams.isEmpty) return '';

    final queryString = validParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '?$queryString';
  }

  /// 构建完整的 API endpoint URL
  static String buildEndpoint(String baseUrl, String path, [Map<String, dynamic>? queryParams]) {
    // 移除 base URL 末尾的斜杠
    final base = baseUrl.trimRight().replaceAll(RegExp(r'/+$'), '');
    // 确保 path 以斜杠开头
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final queryString = queryParams != null ? buildQueryString(queryParams) : '';

    return '$base$normalizedPath$queryString';
  }
}
