import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'image_placeholder.dart';

/// 列表图片组件
/// 有 URL 用自定义加载，无 URL 用 placeholder
/// 支持自签名证书（仅 debug 模式）
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
      child: _NetworkImageWithCert(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        fallbackText: fallbackText,
      ),
    );
  }
}

/// 支持自签名证书的网络图片组件
class _NetworkImageWithCert extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackText;

  const _NetworkImageWithCert({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    required this.fallbackText,
  });

  @override
  State<_NetworkImageWithCert> createState() => _NetworkImageWithCertState();
}

class _NetworkImageWithCertState extends State<_NetworkImageWithCert> {
  ImageProvider? _imageProvider;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(_NetworkImageWithCert oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _hasError = false;
    });

    try {
      final client = io.HttpClient();
      if (kDebugMode) {
        client.badCertificateCallback = (cert, host, port) {
          return host == 'localhost' || host == '10.0.2.2';
        };
      }

      final request = await client.getUrl(Uri.parse(widget.imageUrl));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);

      if (mounted) {
        setState(() {
          _imageProvider = MemoryImage(bytes);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Image load error: ${widget.imageUrl} - $e');
      }
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return ImagePlaceholder(
        text: widget.fallbackText,
        width: widget.width,
        height: widget.height,
      );
    }

    if (_imageProvider == null) {
      return ImagePlaceholder(
        text: widget.fallbackText,
        width: widget.width,
        height: widget.height,
      );
    }

    return Image(
      image: _imageProvider!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        return ImagePlaceholder(
          text: widget.fallbackText,
          width: widget.width,
          height: widget.height,
        );
      },
    );
  }
}
