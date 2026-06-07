import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';

/// 图片 URL 选择器
/// 统一图片 URL 选择逻辑，避免散落在 UI 中
class ImageUrlSelector {
  ImageUrlSelector._();

  /// 获取第一个非空且非空字符串的 URL
  static String? _firstNonEmpty(String? a, String? b, String? c, String? d) {
    if (a != null && a.isNotEmpty) return a;
    if (b != null && b.isNotEmpty) return b;
    if (c != null && c.isNotEmpty) return c;
    if (d != null && d.isNotEmpty) return d;
    return null;
  }

  /// 获取列表图片 URL
  /// 优先级：displayUrl -> thumbnailUrl -> originalUrl -> sourceUrl
  static String? getListUrl(MediaAssetDto? image) {
    if (image == null) return null;
    return _firstNonEmpty(
      image.displayUrl,
      image.thumbnailUrl,
      image.originalUrl,
      image.sourceUrl,
    );
  }

  /// 获取预览图片 URL
  /// 优先级：originalUrl -> displayUrl -> sourceUrl -> thumbnailUrl
  static String? getPreviewUrl(MediaAssetDto? image) {
    if (image == null) return null;
    return _firstNonEmpty(
      image.originalUrl,
      image.displayUrl,
      image.sourceUrl,
      image.thumbnailUrl,
    );
  }

  /// 获取缩略图 URL
  /// 优先级：thumbnailUrl -> displayUrl -> originalUrl -> sourceUrl
  static String? getThumbnailUrl(MediaAssetDto? image) {
    if (image == null) return null;
    return _firstNonEmpty(
      image.thumbnailUrl,
      image.displayUrl,
      image.originalUrl,
      image.sourceUrl,
    );
  }

  /// 获取列表图片 URL 列表
  static List<String> getListUrls(List<MediaAssetDto> images) {
    return [
      for (final image in images)
        if (getListUrl(image) case final url? when url.isNotEmpty) url,
    ];
  }

  /// 获取预览图片 URL 列表
  static List<String> getPreviewUrls(List<MediaAssetDto> images) {
    return [
      for (final image in images)
        if (getPreviewUrl(image) case final url? when url.isNotEmpty) url,
    ];
  }
}
