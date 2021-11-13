import 'dart:async';

import 'package:heritage_online_flutter/network/response/news_list_response.dart';

class DataRepository{
  final List<NewsListResponse> newsList = <NewsListResponse>[];
  final List<NewsListResponse> forumList = <NewsListResponse>[];
  final List<NewsListResponse> specialTopicList = <NewsListResponse>[];

  Stream<List<NewsListResponse>>? _newsListStream;

  final StreamController newsListController = StreamController<List<NewsListResponse>>();
  final StreamController forumListController = StreamController<List<NewsListResponse>>();
  final StreamController specialTopicListController = StreamController<List<NewsListResponse>>();

  Stream<List<NewsListResponse>> watchNewsList(){
    if(_newsListStream!=null){
      _newsListStream = newsListController.stream as Stream<List<NewsListResponse>>;
    }
    return _newsListStream!;
  }


}