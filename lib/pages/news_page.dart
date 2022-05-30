import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/news_type.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/view/custom_tab_view_indicator.dart';
import 'package:heritage_online_flutter/view/news_list.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatelessWidget {
  Map<int, int> indexPage = {};
  Map<int, List<NewsListResponse>> currentNewsListResponse = {};
  NetworkRepository? repo;
  final barText = ['最新', '论坛', '特别报道'];
  List<Tab> tabBarItems=[];
  List<Widget> barViews=[];

  NewsPage({Key? key}) : super(key: key)
  {
    for (int i = 0; i < barText.length; i++){
      tabBarItems.add(Tab(key: PageStorageKey(barText[i]),text: barText[i],));
      barViews.add(SafeArea(
        key: PageStorageKey(barText[i]),
        top: false,
        bottom: false,
        child: Builder(
          builder: (context) {
            return _newsListBody(context, barText[i],NewsType.values[i]);
          },
        ),
      ));
    }
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
                  backgroundColor: Colors.white,
                  titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  title: const Text("资讯"),
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    tabs: tabBarItems,
                    labelPadding: const EdgeInsets.only(left: 20, right: 20),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: CircleTabIndicator(
                        color: Colors.deepPurpleAccent, radius: 4),
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: barViews,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getBody(context);
  }


  Widget _newsListBody(BuildContext context, String title, NewsType newsType) {
    // _loadMore();
    return CustomScrollView(
      key: PageStorageKey<String>(title),
      slivers: [
        SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: NewsSliverList(networkRepo: repo!,newsListRepo: newsType,key: PageStorageKey(title),))
      ],
    );
  }
}