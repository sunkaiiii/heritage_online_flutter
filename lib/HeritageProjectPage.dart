import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HeritageProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("非遗项目"),
      ),
      body: HeritageBodyWidget(),
    );
  }
}

class HeritageBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScroll) {
        return <Widget>[
          SliverToBoxAdapter(
            child: HeritageBodyTopWidget(),
          )
        ];
      },
      body: HeritageBodyBottomWidget(),
    );
  }
}

class HeritageBodyTopWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeritageTopBodyState();
  }
}

class HeritageTopBodyState extends State<HeritageBodyTopWidget> {
  Map result;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody() {
    if (result == null) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Text(result["title"]),
          ),
          Text(result["content"]),
        ],
      ),
    );
  }

  void loadData() async {
    String url = "https://sunkai.xyz:5001/api/HeritageProject/GetMainPage";
    var response = await get(url);
    setState(() {
      result = jsonDecode(response.body);
    });
  }
}

class HeritageBodyBottomWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HeritageBodyBottomWidgetState();
  }
}

class HeritageBodyBottomWidgetState extends State<HeritageBodyBottomWidget> {
  Map result;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Text("@3123");
  }
}
