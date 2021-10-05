import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/botton_navigation_item.dart';
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
  final bottomNavigationItems = [
    const MainListPage(),
    const HeritageProjectPage()
  ];
  final bottomNavigationItem = [
    BottomNavigationItem(
        'assets/imgs/nav_1_sel.png', 'assets/imgs/nav_1_no_sel.png', '资讯'),
    BottomNavigationItem(
        'assets/imgs/nav2_sel.png', 'assets/imgs/nav2_no_sel.png', '非遗项目')
  ];
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

  getTabIcon(int curIndex, BottomNavigationItem item) {
    return curIndex == _tabIndex ? item.selectedImg : item.unSelectedImg;
  }

  getBottomNavigation() {
    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < bottomNavigationItem.length; i++) {
      list.add(BottomNavigationBarItem(
          icon: getTabIcon(i, bottomNavigationItem[i]),
          label: bottomNavigationItem[i].itemText,
          backgroundColor: Color(0x333333)));
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
