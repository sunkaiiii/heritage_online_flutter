import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_placeholder.dart';

/// 列表图片组件
/// 有 URL 用 CachedNetworkImage crop，无 URL 用 placeholder
class ListImage extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ListImage({
    super.key,
    required this.imageUrl,
    required this.fallbackText,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ImagePlaceholder(
        text: fallbackText,
        width: width,
        height: height,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ImagePlaceholder(
          text: fallbackText,
          width: width,
          height: height,
        ),
        errorWidget: (context, url, error) => ImagePlaceholder(
          text: fallbackText,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
