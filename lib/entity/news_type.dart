import 'package:heritage_online_flutter/network/repository.dart';

enum NewsType { news, forums, specialTopic }

extension NewsTypeExtension on NewsType {
  Function get newsListRequest {
    Repository repo = Repository.getInstance();
    switch (this) {
      case NewsType.news:
        return repo.getNewsList;
      case NewsType.forums:
        return repo.getForumsList;
      case NewsType.specialTopic:
        return repo.getSpecialTopicList;
    }
  }

  Function get detailRequest {
    Repository repo = Repository.getInstance();
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
