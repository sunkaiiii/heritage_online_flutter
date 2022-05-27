import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/pages/people_page.dart';
import 'package:heritage_online_flutter/entity/botton_navigation_item.dart';
import 'package:heritage_online_flutter/pages/heritage_project_page.dart';
import 'package:heritage_online_flutter/pages/news_page.dart';

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
    const NewsPage(),
    const PeoplePage(),
    const HeritageProjectPage()
  ];

  void onTap(int index){
     setState((){
       _tabIndex=index;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomNavigationItems[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple[700],
        selectedFontSize: 0,
        unselectedFontSize: 0,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper),label: "资讯"),
          BottomNavigationBarItem(icon: Icon(Icons.people),label:"人物"),
          BottomNavigationBarItem(icon: Icon(Icons.list),label: "清单")
        ],
        currentIndex: _tabIndex,
        onTap:onTap,
      ),
    );
  }

}
