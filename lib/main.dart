import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heritage_online_flutter/heritage_project_page.dart';
import 'package:heritage_online_flutter/news_detail_page.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _tabIndex = 0;

  var appBarTitles = ['资讯', '非遗项目'];
  var tabImages = [
    [
      getTabImage('assets/imgs/nav_1_no_sel.png'),
      getTabImage('assets/imgs/nav_1_sel.png')
    ],
    [
      getTabImage('assets/imgs/nav2_no_sel.png'),
      getTabImage('assets/imgs/nav2_sel.png')
    ],
  ];

  var widgets = [MainListPage(), HeritageProjectPage()];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'E-heritage',
      home: CupertinoTabScaffold(
        tabBuilder: (context, position) {
          return CupertinoTabView(
            builder: (context) {
              return widgets[position];
            },
          );
        },
        tabBar: new CupertinoTabBar(
          items: getBottomNavigation(),
          activeColor: Color(0xFF795548),
          currentIndex: _tabIndex,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      ),
    );
  }

  getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  getBottomNavigation() {
    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < 2; i++) {
      list.add(new BottomNavigationBarItem(
          icon: getTabIcon(i), title: getTabTitle(i)));
    }
    return list;
  }

// 根据索引值返回页面顶部标题
  getTabTitle(int curIndex) {
    return new Text(
      appBarTitles[curIndex],
      //style: getTabTextStyle(curIndex)
    );
  }
}

getTabImage(path) {
  return new Image.asset(path, width: 20.0, height: 20.0);
}

//getTabTextStyle(int curIndex) {
//  if (curIndex == _tabIndex) {
//    return tabTextStyleSelected;
//  }
//  return tabTextStyleNormal;
//}

class MainListPage extends StatefulWidget {
  MainListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageListState();
  }
}

class MainPageListState extends State<MainListPage> {
  List widgets = [];
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    loadData(page);
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
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
            CupertinoSliverNavigationBar(
              largeTitle: const Text('资讯'),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: refreshData,
            ),
            SliverToBoxAdapter(
                child: Container(
              child: Column(
                children: <Widget>[
                  Text("321312321321"),
                  Image.asset("assets/imgs/ic_launcher.png",
                      width: 200.0, height: 200.0)
                ],
              ),
            )),
            SliverSafeArea(
              top: false,
              sliver: getListView(),
            )
          ],
        ),
      );
      //return getListView();
    }
  }

  getProgressDialog() {
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }

  getListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (widgets.length - index < 10 && !isLoading) {
          loadData(++page);
        }
        return getRow(index);
      }, childCount: widgets.length + 1),
    );
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
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

  Widget getRow(int i) {
    if (i < widgets.length) {
      return Container(
          color: CupertinoColors.lightBackgroundGray,
          padding: EdgeInsets.all(4),
          child: GestureDetector(
              onTap: () => toDetailPage(widgets[i]),
              child: Container(
                color: CupertinoColors.white,
                child: Column(
                  children: <Widget>[
                    Image(
                      image: NetworkImage(
                          "https://sunkai.xyz:5001/img/${widgets[i]["img"]}"),
                      fit: BoxFit.contain,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widgets[i]["title"]}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widgets[i]["date"]}",
                            style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                                fontSize: 14),
                          ),
                          Text("${widgets[i]["content"]}",
                              style: TextStyle(fontSize: 16))
                        ],
                      ),
                    )
                  ],
                ),
              )));
    }
    return CupertinoActivityIndicator();
  }

  Future<void> refreshData() {
    widgets = [];
    page = 1;
    return loadData(page);
  }

  Future<void> loadData(int page) async {
    isLoading = true;
    String url = "https://sunkai.xyz:5001/api/NewsList/" + page.toString();
    Fluttertoast.showToast(
        msg: url,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    print("request url: " + url);
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      widgets.addAll(json.decode(response.body));
      isLoading = false;
    });
  }
}
