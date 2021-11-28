import 'dart:async';

import 'package:heritage_online_flutter/network/response/news_list_response.dart';

class DataRepository {
  final List<NewsListResponse> newsList = <NewsListResponse>[];
  final List<NewsListResponse> forumList = <NewsListResponse>[];
  final List<NewsListResponse> specialTopicList = <NewsListResponse>[];

  Stream<List<NewsListResponse>>? _newsListStream;
  Stream<List<NewsListResponse>>? _forumsListStream;
  Stream<List<NewsListResponse>>? _specialTopicListStream;
  final StreamController newsListController =
      StreamController<List<NewsListResponse>>();
  final StreamController forumListController =
      StreamController<List<NewsListResponse>>();
  final StreamController specialTopicListController =
      StreamController<List<NewsListResponse>>();

  Stream<List<NewsListResponse>> watchNewsList() {
    _newsListStream ??=
        newsListController.stream as Stream<List<NewsListResponse>>;
    return _newsListStream!;
  }

  Stream<List<NewsListResponse>> watchForumsList() {
    _forumsListStream ??=
        forumListController.stream as Stream<List<NewsListResponse>>;
    return _forumsListStream!;
  }

  Stream<List<NewsListResponse>> watchSpecialTopoicList() {
    _specialTopicListStream ??=
        specialTopicListController.stream as Stream<List<NewsListResponse>>;
    return _specialTopicListStream!;
  }
}
