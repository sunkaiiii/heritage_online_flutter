import 'package:flutter_test/flutter_test.dart';

import 'package:heritage_online_flutter/core/network/url_encoder.dart';

void main() {
  group('UrlEncoder', () {
    group('encodePathSegment', () {
      test('should encode Chinese characters', () {
        final result = UrlEncoder.encodePathSegment('北京');
        expect(result, isNot('北京'));
        expect(result, contains('%'));
      });

      test('should encode spaces', () {
        final result = UrlEncoder.encodePathSegment('hello world');
        expect(result, isNot('hello world'));
        expect(result, contains('%'));
      });

      test('should encode slashes', () {
        final result = UrlEncoder.encodePathSegment('path/to/resource');
        expect(result, isNot('path/to/resource'));
      });

      test('should encode special symbols', () {
        final result = UrlEncoder.encodePathSegment('test@example.com');
        expect(result, isNot('test@example.com'));
      });

      test('should not encode alphanumeric characters', () {
        final result = UrlEncoder.encodePathSegment('abc123');
        expect(result, 'abc123');
      });

      test('should handle empty string', () {
        final result = UrlEncoder.encodePathSegment('');
        expect(result, '');
      });

      test('should encode Chinese region name', () {
        final result = UrlEncoder.encodePathSegment('北京市');
        expect(result, isNot('北京市'));
        expect(result.contains('北京市'), isFalse);
      });

      test('should encode Chinese category name', () {
        final result = UrlEncoder.encodePathSegment('传统技艺');
        expect(result, isNot('传统技艺'));
      });
    });

    group('encodePath', () {
      test('should encode each segment separately', () {
        final result = UrlEncoder.encodePath('/api/regions/北京/atlas');
        expect(result, startsWith('/api/regions/'));
        expect(result, endsWith('/atlas'));
        expect(result.contains('北京'), isFalse);
      });

      test('should handle empty segments', () {
        final result = UrlEncoder.encodePath('/api/articles');
        expect(result, '/api/articles');
      });

      test('should handle path with Chinese segments', () {
        final result = UrlEncoder.encodePath('/api/explore/topics/分类/传统技艺');
        expect(result, startsWith('/api/explore/topics/'));
        expect(result.contains('分类'), isFalse);
        expect(result.contains('传统技艺'), isFalse);
      });
    });

    group('buildQueryString', () {
      test('should build query string from params', () {
        final result = UrlEncoder.buildQueryString({
          'page': 1,
          'pageSize': 10,
        });
        expect(result, startsWith('?'));
        expect(result.contains('page=1'), isTrue);
        expect(result.contains('pageSize=10'), isTrue);
      });

      test('should filter out null values', () {
        final result = UrlEncoder.buildQueryString({
          'page': 1,
          'keywords': null,
        });
        expect(result, '?page=1');
      });

      test('should filter out empty string values', () {
        final result = UrlEncoder.buildQueryString({
          'page': 1,
          'keywords': '',
        });
        expect(result, '?page=1');
      });

      test('should return empty string for empty params', () {
        final result = UrlEncoder.buildQueryString({});
        expect(result, '');
      });

      test('should return empty string for all null params', () {
        final result = UrlEncoder.buildQueryString({
          'keywords': null,
          'category': null,
        });
        expect(result, '');
      });

      test('should encode Chinese values', () {
        final result = UrlEncoder.buildQueryString({
          'region': '北京',
        });
        expect(result, startsWith('?region='));
        expect(result.contains('北京'), isFalse);
      });
    });

    group('buildEndpoint', () {
      test('should build endpoint with path', () {
        final result = UrlEncoder.buildEndpoint('https://example.com', '/api/articles');
        expect(result, 'https://example.com/api/articles');
      });

      test('should handle trailing slash in base url', () {
        final result = UrlEncoder.buildEndpoint('https://example.com/', '/api/articles');
        expect(result, 'https://example.com/api/articles');
      });

      test('should handle missing leading slash in path', () {
        final result = UrlEncoder.buildEndpoint('https://example.com', 'api/articles');
        expect(result, 'https://example.com/api/articles');
      });

      test('should build endpoint with query params', () {
        final result = UrlEncoder.buildEndpoint(
          'https://example.com',
          '/api/articles',
          {'page': 1, 'pageSize': 10},
        );
        expect(result, startsWith('https://example.com/api/articles?'));
        expect(result.contains('page=1'), isTrue);
        expect(result.contains('pageSize=10'), isTrue);
      });

      test('should not add query string for empty params', () {
        final result = UrlEncoder.buildEndpoint(
          'https://example.com',
          '/api/articles',
          {},
        );
        expect(result, 'https://example.com/api/articles');
        expect(result.contains('?'), isFalse);
      });
    });
  });
}
