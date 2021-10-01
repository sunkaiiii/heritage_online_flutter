import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/heritage_project_page.dart';
import 'package:heritage_online_flutter/view/main_page.dart';

class MainPageTabScaffold extends StatefulWidget {
  const MainPageTabScaffold({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageTabScaffoldState();
  }
}

class MainPageTabScaffoldState extends State<MainPageTabScaffold> {
  int _tabIndex = 0;
  MainPageTabScaffoldState();
  final bottomNavigationItems = [MainListPage(), HeritageProjectPage()];
  final appBarTitles = ['资讯', '非遗项目'];
  final _tabImages = [
    [
      getTabImage('assets/imgs/nav_1_no_sel.png'),
      getTabImage('assets/imgs/nav_1_sel.png')
    ],
    [
      getTabImage('assets/imgs/nav2_no_sel.png'),
      getTabImage('assets/imgs/nav2_sel.png')
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, position) {
        return CupertinoTabView(
          builder: (context) {
            return bottomNavigationItems[position];
          },
        );
      },
      tabBar: CupertinoTabBar(
        items: getBottomNavigation(),
        activeColor: const Color(0xFF795548),
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }

  getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return _tabImages[curIndex][1];
    }
    return _tabImages[curIndex][0];
  }

  getBottomNavigation() {
    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < 2; i++) {
      list.add(
          BottomNavigationBarItem(icon: getTabIcon(i), label: getTabTitle(i)));
    }
    return list;
  }

// 根据索引值返回页面顶部标题
  getTabTitle(int curIndex) {
    appBarTitles[curIndex];
  }

  static getTabImage(path) {
    return Image.asset(path, width: 20.0, height: 20.0);
  }
}
