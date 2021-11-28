import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/news_type.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/news_detail_page.dart';
import 'package:heritage_online_flutter/view/general_progress_indicator.dart';
import 'package:heritage_online_flutter/view/main_page_top_pager.dart';
import 'package:heritage_online_flutter/view/news_list_raw.dart';
import 'package:heritage_online_flutter/view/news_list_pager_body.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageListState();
  }
}

class MainPageListState extends State<MainListPage> {
  int index = 0;
  Map<int, int> indexPage = {};
  Map<int, List<NewsListResponse>> currentNewsListResponse = {};
  NetworkRepository? repo;

  @override
  void initState() {
    super.initState();
  }

  getBody(BuildContext context) {
    repo = Provider.of<NetworkRepository>(context);
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
              if (indexPage[value] == null) {
                indexPage[value] = 1;
              }
              index = value;
            });
          })),
          _newsListBody(context)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: getBody(context));
  }

  toDetailPage(final NewsListResponse response) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) {
      return NewsDetailPage(response.link, NewsType.values[index]);
    }));
  }

  Widget _newsListBody(BuildContext context) {
    _loadMore();
    return NotificationListener(
        child: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final newsList = currentNewsListResponse[this.index] ?? [];
            return NewsListRow(newsList[index], toDetailPage);
          }, childCount: (currentNewsListResponse[index] ?? []).length),
        ),
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 300) {
            _loadMore();
          }
          return true;
        });
  }

  Future<bool> _loadMore() async {
    final page = indexPage[index] ?? 1;
    final newsListResponse =
        await NewsType.values[index].getNewsListRequest(repo!)(page);
    indexPage[index] = page + 1;
    if (currentNewsListResponse[index] == null) {
      currentNewsListResponse[index] = [];
    }
    currentNewsListResponse[index]!.addAll(newsListResponse);
    setState(() {});
    return true;
  }
}
