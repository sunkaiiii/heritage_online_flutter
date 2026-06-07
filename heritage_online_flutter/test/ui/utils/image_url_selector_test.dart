import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/dto/common_dtos.dart';
import 'package:heritage_online_flutter/ui/utils/image_url_selector.dart';

void main() {
  group('ImageUrlSelector', () {
    group('getListUrl', () {
      test('should return displayUrl first', () {
        const image = MediaAssetDto(
          displayUrl: 'https://example.com/display.jpg',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          originalUrl: 'https://example.com/original.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getListUrl(image), 'https://example.com/display.jpg');
      });

      test('should fallback to thumbnailUrl', () {
        const image = MediaAssetDto(
          thumbnailUrl: 'https://example.com/thumb.jpg',
          originalUrl: 'https://example.com/original.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getListUrl(image), 'https://example.com/thumb.jpg');
      });

      test('should fallback to originalUrl', () {
        const image = MediaAssetDto(
          originalUrl: 'https://example.com/original.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getListUrl(image), 'https://example.com/original.jpg');
      });

      test('should fallback to sourceUrl', () {
        const image = MediaAssetDto(
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getListUrl(image), 'https://example.com/source.jpg');
      });

      test('should return null for null image', () {
        expect(ImageUrlSelector.getListUrl(null), isNull);
      });

      test('should return null when all URLs are null', () {
        const image = MediaAssetDto();
        expect(ImageUrlSelector.getListUrl(image), isNull);
      });

      test('should skip empty URLs', () {
        const image = MediaAssetDto(
          displayUrl: '',
          thumbnailUrl: 'https://example.com/thumb.jpg',
        );

        expect(ImageUrlSelector.getListUrl(image), 'https://example.com/thumb.jpg');
      });
    });

    group('getPreviewUrl', () {
      test('should return originalUrl first', () {
        const image = MediaAssetDto(
          displayUrl: 'https://example.com/display.jpg',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          originalUrl: 'https://example.com/original.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getPreviewUrl(image), 'https://example.com/original.jpg');
      });

      test('should fallback to displayUrl', () {
        const image = MediaAssetDto(
          displayUrl: 'https://example.com/display.jpg',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getPreviewUrl(image), 'https://example.com/display.jpg');
      });

      test('should fallback to sourceUrl', () {
        const image = MediaAssetDto(
          thumbnailUrl: 'https://example.com/thumb.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getPreviewUrl(image), 'https://example.com/source.jpg');
      });

      test('should fallback to thumbnailUrl', () {
        const image = MediaAssetDto(
          thumbnailUrl: 'https://example.com/thumb.jpg',
        );

        expect(ImageUrlSelector.getPreviewUrl(image), 'https://example.com/thumb.jpg');
      });

      test('should return null for null image', () {
        expect(ImageUrlSelector.getPreviewUrl(null), isNull);
      });
    });

    group('getThumbnailUrl', () {
      test('should return thumbnailUrl first', () {
        const image = MediaAssetDto(
          displayUrl: 'https://example.com/display.jpg',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          originalUrl: 'https://example.com/original.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getThumbnailUrl(image), 'https://example.com/thumb.jpg');
      });

      test('should fallback to displayUrl', () {
        const image = MediaAssetDto(
          displayUrl: 'https://example.com/display.jpg',
          originalUrl: 'https://example.com/original.jpg',
          sourceUrl: 'https://example.com/source.jpg',
        );

        expect(ImageUrlSelector.getThumbnailUrl(image), 'https://example.com/display.jpg');
      });

      test('should return null for null image', () {
        expect(ImageUrlSelector.getThumbnailUrl(null), isNull);
      });
    });

    group('getListUrls', () {
      test('should return list of valid URLs', () {
        const images = [
          MediaAssetDto(displayUrl: 'https://example.com/1.jpg'),
          MediaAssetDto(displayUrl: 'https://example.com/2.jpg'),
          MediaAssetDto(displayUrl: 'https://example.com/3.jpg'),
        ];

        final urls = ImageUrlSelector.getListUrls(images);
        expect(urls.length, 3);
        expect(urls[0], 'https://example.com/1.jpg');
        expect(urls[1], 'https://example.com/2.jpg');
        expect(urls[2], 'https://example.com/3.jpg');
      });

      test('should skip images with no URLs', () {
        const images = [
          MediaAssetDto(displayUrl: 'https://example.com/1.jpg'),
          MediaAssetDto(), // No URL
          MediaAssetDto(displayUrl: 'https://example.com/3.jpg'),
        ];

        final urls = ImageUrlSelector.getListUrls(images);
        expect(urls.length, 2);
      });

      test('should return empty list for empty input', () {
        final urls = ImageUrlSelector.getListUrls([]);
        expect(urls, isEmpty);
      });
    });

    group('getPreviewUrls', () {
      test('should return preview URLs in correct priority', () {
        const images = [
          MediaAssetDto(
            originalUrl: 'https://example.com/original1.jpg',
            displayUrl: 'https://example.com/display1.jpg',
          ),
          MediaAssetDto(
            originalUrl: 'https://example.com/original2.jpg',
            displayUrl: 'https://example.com/display2.jpg',
          ),
        ];

        final urls = ImageUrlSelector.getPreviewUrls(images);
        expect(urls.length, 2);
        expect(urls[0], 'https://example.com/original1.jpg');
        expect(urls[1], 'https://example.com/original2.jpg');
      });

      test('should return empty list for empty input', () {
        final urls = ImageUrlSelector.getPreviewUrls([]);
        expect(urls, isEmpty);
      });
    });
  });
}
