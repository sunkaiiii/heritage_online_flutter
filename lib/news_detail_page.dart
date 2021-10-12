import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsDetailPage extends StatelessWidget {
  final Map<String, String> maps;

  NewsDetailPage(this.maps, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("NewsDetail"),
          previousPageTitle: "首页",
          backgroundColor: CupertinoColors.white,
        ),
        child: NewsDetailList(maps["link"]));
  }
}

class NewsDetailList extends StatefulWidget {
  final String? url;

  NewsDetailList(this.url, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NewsDetailState(url);
  }
}

class NewsDetailState extends State<NewsDetailList> {
  final String? url;
  List widgets = [];
  Map<String, dynamic>? result;

  NewsDetailState(this.url);

  @override
  void initState() {
    super.initState();
    loadDetailData();
  }

  loadDetailData() async {
    http.Response response = await http
        .get(Uri.parse("https://sunkai.xyz:5001/api/NewsDetail?link=$url"));
    setState(() {
      result = json.decode(response.body);
      widgets = result?["content"];
    });
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  getListView() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScroll) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Text(result!["title"].toString().trim()),
            )
          ];
        },
        body: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            }));
  }

  getProgressDialog() {
    return Center(
      child: CupertinoActivityIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getBody(),
    );
  }

  getRow(int i) {
    String type = widgets[i]["type"];
    if (type == "img") {
      return Image.network(
        "https://sunkai.xyz:5001/img/${widgets[i]["content"]}",
        fit: BoxFit.contain,
      );
    } else {
      return Text(widgets[i]["content"]);
    }
  }
}
