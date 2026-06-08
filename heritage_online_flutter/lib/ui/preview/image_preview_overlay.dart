import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/resources/l10n/app_localizations.dart';

/// 图片预览 Overlay
/// 支持多图切换、缩放、关闭、页码显示
class ImagePreviewOverlay extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final VoidCallback onDismiss;

  const ImagePreviewOverlay({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    required this.onDismiss,
  });

  @override
  State<ImagePreviewOverlay> createState() => _ImagePreviewOverlayState();
}

class _ImagePreviewOverlayState extends State<ImagePreviewOverlay> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrls.isEmpty) {
      _currentIndex = 0;
    } else {
      _currentIndex = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    }
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.96),
      body: Stack(
        children: [
          // 图片页面
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: _PreviewImage(url: widget.imageUrls[index]),
                ),
              );
            },
          ),

          // 顶部工具栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: widget.onDismiss,
                    tooltip: l10n.previewClose,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.previewPageIndicator(_currentIndex + 1, widget.imageUrls.length),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 支持自签名证书的预览图片组件
class _PreviewImage extends StatefulWidget {
  final String url;

  const _PreviewImage({required this.url});

  @override
  State<_PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<_PreviewImage> {
  ImageProvider? _imageProvider;
  bool _hasError = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(_PreviewImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });

    try {
      final client = io.HttpClient();
      if (kDebugMode) {
        client.badCertificateCallback = (cert, host, port) {
          return host == 'localhost' || host == '10.0.2.2';
        };
      }

      final request = await client.getUrl(Uri.parse(widget.url));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);

      if (mounted) {
        setState(() {
          _imageProvider = MemoryImage(bytes);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Preview image load error: ${widget.url} - $e');
      }
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_hasError) {
      return const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.white54,
          size: 64,
        ),
      );
    }

    if (_imageProvider == null) {
      return const SizedBox.shrink();
    }

    return Image(
      image: _imageProvider!,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.broken_image,
            color: Colors.white54,
            size: 64,
          ),
        );
      },
    );
  }
}

/// 显示图片预览
void showImagePreview({
  required BuildContext context,
  required List<String> imageUrls,
  int initialIndex = 0,
}) {
  if (imageUrls.isEmpty) return;

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ImagePreviewOverlay(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}
