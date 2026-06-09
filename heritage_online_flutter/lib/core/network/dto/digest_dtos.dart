import 'package:json_annotation/json_annotation.dart';

part 'digest_dtos.g.dart';

/// 内容速览
@JsonSerializable()
class ContentDigestDto {
  final String type;
  final String id;
  final String title;
  final String? quickRead;
  final List<String> highlights;
  final List<DigestFactDto> keyFacts;
  final List<String> keywords;
  final int readingTimeMinutes;
  final String sourceUrl;
  final String? generatedAt;

  const ContentDigestDto({
    this.type = '',
    this.id = '',
    this.title = '',
    this.quickRead,
    this.highlights = const [],
    this.keyFacts = const [],
    this.keywords = const [],
    this.readingTimeMinutes = 0,
    this.sourceUrl = '',
    this.generatedAt,
  });

  factory ContentDigestDto.fromJson(Map<String, dynamic> json) =>
      _$ContentDigestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContentDigestDtoToJson(this);
}

/// 速览事实
@JsonSerializable()
class DigestFactDto {
  final String label;
  final String value;

  const DigestFactDto({
    this.label = '',
    this.value = '',
  });

  factory DigestFactDto.fromJson(Map<String, dynamic> json) =>
      _$DigestFactDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DigestFactDtoToJson(this);
}
