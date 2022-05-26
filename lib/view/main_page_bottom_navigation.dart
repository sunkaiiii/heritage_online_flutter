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
  Color textColor = const Color(0x00c47f7f);
  Color iconColor = const Color(0xFFC47F7F);
  final bottomNavigationItems = [
    const MainListPage(),
    const HeritageProjectPage()
  ];
  final bottomNavigationItem = [
    BottomNavigationItem(0,
        'assets/imgs/nav_1_sel.png', 'assets/imgs/nav_1_no_sel.png', '资讯'),
    BottomNavigationItem(1,
        'assets/imgs/nav2_sel.png', 'assets/imgs/nav2_no_sel.png', '非遗项目')
  ];

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItems = bottomNavigationItem.map((e) => BottomNavigationBarItem(icon:getTabIcon(e.index, e),label: e.itemText)).toList();
    return Scaffold(
      body: Center(child: bottomNavigationItems[_tabIndex],),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _tabIndex,
        onTap: (i)=>{setState((){
          _tabIndex=i;
        })},
      ),
    );
  }

  getTabIcon(int itemIndex,BottomNavigationItem item) {
    return itemIndex == _tabIndex ? item.selectedImg : item.unSelectedImg;
  }
}
