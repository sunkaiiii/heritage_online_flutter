import 'dart:convert';

List<NewsListResponse> newsListResponseFromJson(String str) =>
    List<NewsListResponse>.from(
        json.decode(str).map((x) => NewsListResponse.fromJson(x)));

String newsListResponseToJson(List<NewsListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsListResponse {
  NewsListResponse({
    required this.id,
    required this.link,
    required this.title,
    this.img,
    required this.date,
    required this.content,
    this.compressImg,
    required this.originalText,
  });

  final String id;
  final String link;
  final String title;
  final String? img;
  final String date;
  final String content;
  final String? compressImg;
  final String originalText;

  factory NewsListResponse.fromJson(Map<String, dynamic> json) =>
      NewsListResponse(
        id: json["id"],
        link: json["link"],
        title: json["title"],
        img: json["img"],
        date: json["date"],
        content: json["content"],
        compressImg: json["compressImg"],
        originalText: json["originalText"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "title": title,
        "img": img,
        "date": date,
        "content": content,
        "compressImg": compressImg,
        "originalText": originalText,
      };
}
