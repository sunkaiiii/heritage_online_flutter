import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/news_type.dart';
import 'package:heritage_online_flutter/network/repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/news_detail_page.dart';
import 'package:heritage_online_flutter/view/general_progress_indicator.dart';
import 'package:heritage_online_flutter/view/main_page_top_pager.dart';
import 'package:heritage_online_flutter/view/news_list_raw.dart';
import 'package:heritage_online_flutter/view/news_list_pager_body.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageListState();
  }
}

class MainPageListState extends State<MainListPage> {
  int index = 0;

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
    Navigator.push(context, CupertinoPageRoute(builder: (_) {
      return NewsDetailPage(response.link, NewsType.values[index]);
    }));
  }

  FutureBuilder<List<NewsListResponse>> _newsListBody() {
    return FutureBuilder<List<NewsListResponse>>(
        future: NewsType.values[index].newsListRequest(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<NewsListResponse> response = snapshot.data ?? [];
            return getListView(response);
          } else {
            return const SliverFillRemaining(child: GeneralProgressIndicator());
          }
        });
  }

  getListView(List<NewsListResponse> response) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index < response.length) {
          return NewsListRow(response[index], toDetailPage);
        }
        return const GeneralProgressIndicator();
      }, childCount: response.length + 1),
    );
  }
}
