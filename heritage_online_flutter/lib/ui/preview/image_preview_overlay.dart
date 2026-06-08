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
    // 防御空列表：空列表时 currentIndex 为 0，不创建非法 initialPage
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
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 64,
                        ),
                      );
                    },
                  ),
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
