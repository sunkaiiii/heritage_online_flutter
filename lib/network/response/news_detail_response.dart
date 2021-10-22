import 'dart:convert';

NewsDetailResponse newsDetailResponseFromJson(String str) =>
    NewsDetailResponse.fromJson(json.decode(str));

String newsDetailResponseToJson(NewsDetailResponse data) =>
    json.encode(data.toJson());

class NewsDetailResponse {
  NewsDetailResponse({
    required this.id,
    required this.link,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.author,
    this.relativeNews,
    required this.originalText,
    this.img,
    this.compressImg,
    required this.subContent,
    required this.date,
  });

  String id;
  String link;
  String title;
  List<String> subtitle;
  List<Content> content;
  String author;
  List<RelativeNews>? relativeNews;
  String originalText;
  String? img;
  String? compressImg;
  String subContent;
  String date;

  factory NewsDetailResponse.fromJson(Map<String, dynamic> json) =>
      NewsDetailResponse(
        id: json["id"],
        link: json["link"],
        title: json["title"],
        subtitle: List<String>.from(json["subtitle"].map((x) => x)),
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        author: json["author"],
        relativeNews: List<RelativeNews>.from(
            json["relativeNews"].map((x) => RelativeNews.fromJson(x))),
        originalText: json["originalText"],
        img: json["img"],
        compressImg: json["compressImg"],
        subContent: json["subContent"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "title": title,
        "subtitle": List<dynamic>.from(subtitle.map((x) => x)),
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "author": author,
        "relativeNews": relativeNews == null
            ? null
            : List<dynamic>.from(relativeNews!.map((x) => x.toJson())),
        "originalText": originalText,
        "img": img,
        "compressImg": compressImg,
        "subContent": subContent,
        "date": date,
      };
}

class Content {
  Content({
    required this.type,
    this.content,
    this.compressImg,
  });

  String type;
  String? content;
  String? compressImg;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        type: json["type"],
        content: json["content"],
        compressImg: json["compressImg"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "content": content,
        "compressImg": compressImg,
      };
}

class RelativeNews {
  RelativeNews({
    required this.link,
    required this.date,
    required this.title,
  });

  String link;
  DateTime date;
  String title;

  factory RelativeNews.fromJson(Map<String, dynamic> json) => RelativeNews(
        link: json["link"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "title": title,
      };
}
