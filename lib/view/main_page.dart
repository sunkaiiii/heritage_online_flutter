import 'package:flutter/cupertino.dart';
import 'package:heritage_online_flutter/network/repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/news_detail_page.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageListState();
  }
}

class MainPageListState extends State<MainListPage> {
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
          SliverToBoxAdapter(
              child: Container(
            child: Column(
              children: <Widget>[
                Image.asset("assets/imgs/ic_launcher.png",
                    width: 200.0, height: 200.0)
              ],
            ),
          )),
          SliverSafeArea(
            top: false,
            sliver: _newsListBody(context),
          )
        ],
      ),
    );
    //return getListView();
  }

  getProgressDialog() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  getListView(List<NewsListResponse> response) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return getRow(index < response.length ? response[index] : null);
      }, childCount: response.length + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child: getBody());
  }

  toDetailPage(widget) {
    Map<String, String> info = Map();
    info["content"] = widget["content"];
    info["title"] = widget["title"];
    info["link"] = widget["link"];
    Navigator.push(context, CupertinoPageRoute(builder: (_) {
      return NewsDetailPage(info);
    }));
  }

  Widget getRow(final NewsListResponse? response) {
    if (response != null) {
      return Container(
          color: CupertinoColors.lightBackgroundGray,
          padding: EdgeInsets.all(4),
          child: GestureDetector(
              onTap: () => toDetailPage(response),
              child: Container(
                color: CupertinoColors.white,
                child: Column(
                  children: <Widget>[
                    response.compressImg != null
                        ? Image(
                            image: NetworkImage(
                                "https://sunkai.xyz:5001/img/${response.compressImg}"),
                            fit: BoxFit.contain,
                          )
                        : Text('123'),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            response.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            response.date,
                            style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                                fontSize: 14),
                          ),
                          Text(response.content, style: TextStyle(fontSize: 16))
                        ],
                      ),
                    )
                  ],
                ),
              )));
    }
    return CupertinoActivityIndicator();
  }

  FutureBuilder<List<NewsListResponse>> _newsListBody(BuildContext context) {
    Repository repo = Repository.getInstance();
    return FutureBuilder<List<NewsListResponse>>(
        future: repo.getNewsList(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<NewsListResponse> response = snapshot.data ?? [];
            return getListView(response);
          } else {
            return SliverFillRemaining(child: getProgressDialog());
          }
        });
  }
}
