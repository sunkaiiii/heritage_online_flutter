import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/network/repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/news_detail_page.dart';
import 'package:heritage_online_flutter/view/main_page_top_pager.dart';
import 'package:heritage_online_flutter/view/news_list.dart';
import 'package:heritage_online_flutter/view/news_list_pager_body.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageListState();
  }
}

class MainPageListState extends State<MainListPage> {
  late Repository repo;
  late List<Function> newsFutureRequests;
  int index = 0;
  MainPageListState() {
    repo = Repository.getInstance();
    newsFutureRequests = [
      repo.getNewsList,
      repo.getForumsList,
      repo.getSpecialTopicList
    ];
  }
  @override
  void initState() {
    super.initState();
  }

  getBody() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).brightness == Brightness.light
            ? CupertinoColors.extraLightBackgroundGray
            : CupertinoColors.darkBackgroundGray,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            largeTitle: Text('资讯'),
          ),
          const CupertinoSliverRefreshControl(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 250, child: MainPageTopPager()),
          ),
          SliverToBoxAdapter(child: NewsListPagerSegment((value) {
            setState(() {
              index = value;
            });
          })),
          _newsListBody()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: getBody());
  }

  toDetailPage(final NewsListResponse response) {
    Map<String, String> info = Map();
    info["content"] = response.content;
    info["title"] = response.title;
    info["link"] = response.link;
    Navigator.push(context, CupertinoPageRoute(builder: (_) {
      return NewsDetailPage(info);
    }));
  }

  FutureBuilder<List<NewsListResponse>> _newsListBody() {
    return FutureBuilder<List<NewsListResponse>>(
        future: newsFutureRequests[index](1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<NewsListResponse> response = snapshot.data ?? [];
            return getListView(response);
          } else {
            return SliverFillRemaining(child: getProgressDialog());
          }
        });
  }

  getListView(List<NewsListResponse> response) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < response.length) {
          return NewsListRow(response[index], toDetailPage);
        }
        return getProgressDialog();
      }, childCount: response.length + 1),
    );
  }

  getProgressDialog() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
