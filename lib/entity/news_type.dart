import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';

enum NewsType { news, forums, specialTopic }

extension NewsTypeExtension on NewsType {
  Function getNewsListRequest(NetworkRepository repo){
    switch (this) {
      case NewsType.news:
        return repo.getNewsList;
      case NewsType.forums:
        return repo.getForumsList;
      case NewsType.specialTopic:
        return repo.getSpecialTopicList;
    }
  }

  Function getDetailRequest(NetworkRepository repo){
    switch (this) {
      case NewsType.news:
        return repo.getNewsDetail;
      case NewsType.forums:
        return repo.getForumsDetail;
      case NewsType.specialTopic:
        return repo.getSpecialTopicDetail;
    }
  }
}
