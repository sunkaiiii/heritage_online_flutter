import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/news_type.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/news_detail_page.dart';
import 'package:heritage_online_flutter/view/general_progress_indicator.dart';
import 'package:heritage_online_flutter/view/main_page_top_pager.dart';
import 'package:heritage_online_flutter/view/news_list_raw.dart';
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
  final barText = ['最新', '论坛', '特别报道'];

  @override
  void initState() {
    super.initState();
  }

  getBody(BuildContext context) {
    repo = Provider.of<NetworkRepository>(context);
    return DefaultTabController(
      length: barText.length,
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: const Color(0xff532677),
                  centerTitle: true,
                  pinned: true,
                  title: const Text("资讯"),
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: barText.map((e) => Tab(text: e)).toList(),
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: barText
                .map((name) => SafeArea(
                      top: false,
                      bottom: false,
                      child: Builder(
                        builder: (context) {
                          return _newsListBody(context, name);
                        },
                      ),
                    ))
                .toList(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getBody(context);
  }

  toDetailPage(final NewsListResponse response) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return NewsDetailPage(response.link, NewsType.values[index]);
    }));
  }

  Widget _newsListBody(BuildContext context, String title) {
    _loadMore();
    if((currentNewsListResponse[index]??[]).isEmpty){
      return const GeneralProgressIndicator();
    }else{
      return CustomScrollView(
        key: PageStorageKey<String>(title),
        slivers: [
          SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
          SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    // This builder is called for each child.
                    // In this example, we just number each list item.
                    final newsList = currentNewsListResponse[this.index] ?? [];
                    return NewsListRow(newsList[index], toDetailPage);
                  },
                  childCount: (currentNewsListResponse[index] ?? []).length,
                ),
              ))
        ],
      );
    }

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
