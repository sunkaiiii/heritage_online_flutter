import 'package:flutter/material.dart';

class MainPageTopPager extends StatefulWidget {
  const MainPageTopPager({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageTopPagerState();
  }
}

class MainPageTopPagerState extends State<MainPageTopPager> {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
