import 'dart:convert';

List<BannerResponse> bannerResponseFromJson(String str) =>
    List<BannerResponse>.from(
        json.decode(str).map((x) => BannerResponse.fromJson(x)));

String bannerResponseToJson(List<BannerResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerResponse {
  BannerResponse({
    required this.id,
    required this.link,
    required this.img,
    required this.compressImg,
    required this.originImage,
    required this.originalText,
  });

  final String id;
  final String link;
  final String img;
  final String compressImg;
  final String originImage;
  final String originalText;

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
        id: json["id"],
        link: json["link"],
        img: json["img"],
        compressImg: json["compressImg"],
        originImage: json["originImage"],
        originalText: json["originalText"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "img": img,
        "compressImg": compressImg,
        "originImage": originImage,
        "originalText": originalText,
      };
}
