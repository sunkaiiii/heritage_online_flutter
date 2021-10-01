import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:heritage_online_flutter/heritage_project_page.dart';
import 'package:heritage_online_flutter/view/main_page.dart';
import 'package:heritage_online_flutter/view/main_page_bottom_navigation.dart';

void main() => runApp(MainPage());

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(title: 'E-heritage', home: MainPageTabScaffold());
  }
}




//getTabTextStyle(int curIndex) {
//  if (curIndex == _tabIndex) {
//    return tabTextStyleSelected;
//  }
//  return tabTextStyleNormal;
//}



