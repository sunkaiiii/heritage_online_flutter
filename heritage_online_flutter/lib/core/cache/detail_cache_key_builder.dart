/// 详情缓存 key 构建器
/// 格式：{type}|{qualifier}|{lookup_type}:{lookup_value}
///
/// article: article|{category}|id:{id} / article|{category}|sourceId:{sourceId}
/// directory: directory|{kind}|id:{id} / directory|{kind}|sourceId:{sourceId}
/// inheritor: inheritor|id:{id} / inheritor|sourceId:{sourceId}
///
/// 当通过 sourceId/sourceUrl 打开详情时，网络成功后会保存多个 alias key，
/// 使得下次通过 internal id 也能命中缓存。
class DetailCacheKeyBuilder {
  DetailCacheKeyBuilder._();

  /// 构建文章缓存 key
  static String? articleKey({
    String? articleId,
    String? sourceId,
    String? sourceUrl,
    String? category,
  }) {
    final qualifier = category?.isNotEmpty == true ? category! : 'unknown';
    if (articleId != null && articleId.isNotEmpty) {
      return 'article|$qualifier|id:$articleId';
    }
    if (sourceId != null && sourceId.isNotEmpty) {
      return 'article|$qualifier|sourceId:$sourceId';
    }
    if (sourceUrl != null && sourceUrl.isNotEmpty) {
      return 'article|$qualifier|sourceUrl:$sourceUrl';
    }
    return null;
  }

  /// 构建名录缓存 key
  static String? directoryKey({
    String? itemId,
    String? sourceId,
    String? kind,
  }) {
    final qualifier = kind?.isNotEmpty == true ? kind! : 'unknown';
    if (itemId != null && itemId.isNotEmpty) {
      return 'directory|$qualifier|id:$itemId';
    }
    if (sourceId != null && sourceId.isNotEmpty) {
      return 'directory|$qualifier|sourceId:$sourceId';
    }
    return null;
  }

  /// 构建传承人缓存 key
  static String? inheritorKey({
    String? inheritorId,
    String? sourceId,
  }) {
    if (inheritorId != null && inheritorId.isNotEmpty) {
      return 'inheritor|id:$inheritorId';
    }
    if (sourceId != null && sourceId.isNotEmpty) {
      return 'inheritor|sourceId:$sourceId';
    }
    return null;
  }

  /// 为文章生成所有可能的 alias keys
  /// 当 DTO 包含 id/sourceId/sourceUrl 时，生成多个 key 以便跨 lookup 方式命中缓存
  static List<String> articleAliases({
    String? id,
    String? sourceId,
    String? sourceUrl,
    String? category,
  }) {
    final qualifier = category?.isNotEmpty == true ? category! : 'unknown';
    final keys = <String>[];
    if (id != null && id.isNotEmpty) keys.add('article|$qualifier|id:$id');
    if (sourceId != null && sourceId.isNotEmpty) keys.add('article|$qualifier|sourceId:$sourceId');
    if (sourceUrl != null && sourceUrl.isNotEmpty) keys.add('article|$qualifier|sourceUrl:$sourceUrl');
    return keys;
  }

  /// 为名录生成所有可能的 alias keys
  static List<String> directoryAliases({
    String? id,
    String? sourceId,
    String? kind,
  }) {
    final qualifier = kind?.isNotEmpty == true ? kind! : 'unknown';
    final keys = <String>[];
    if (id != null && id.isNotEmpty) keys.add('directory|$qualifier|id:$id');
    if (sourceId != null && sourceId.isNotEmpty) keys.add('directory|$qualifier|sourceId:$sourceId');
    return keys;
  }

  /// 为传承人生成所有可能的 alias keys
  static List<String> inheritorAliases({
    String? id,
    String? sourceId,
  }) {
    final keys = <String>[];
    if (id != null && id.isNotEmpty) keys.add('inheritor|id:$id');
    if (sourceId != null && sourceId.isNotEmpty) keys.add('inheritor|id:$sourceId');
    return keys;
  }
}
