import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HeritageProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("非遗项目"),
        backgroundColor: CupertinoColors.white,
      ),
      child: HeritageBodyWidget(),
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
  List result = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData(page);
  }

  void loadData(int page) async {
    isLoading = true;
    String url =
        "https://sunkai.xyz:5001/api/HeritageProject/GetHeritageProjectList/$page";
    var response = await get(url);
    setState(() {
      result.addAll(jsonDecode(response.body));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: result.length + 1,
        itemBuilder: (context, position) {
          if (result.length - position < 10 && !isLoading) {
            loadData(++page);
          }
          return getRow(position);
        });
  }

  getRow(int i) {
    if (i == result.length) {
      return CupertinoActivityIndicator();
    }
    Map rowInfo = result[i];
    return HeritageProjectRow(rowInfo);
  }
}

class HeritageProjectRow extends StatefulWidget {
  Map result;

  HeritageProjectRow(this.result);

  @override
  State<StatefulWidget> createState() {
    return HeritageProjectRowState(result);
  }
}

class HeritageProjectRowState extends State<HeritageProjectRow> {
  Map row;
  bool expended = false;

  HeritageProjectRowState(this.row);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(row["num"]),
          Text(row["title"]),
          Text(row["type"]),
          Text(row["rx_time"]),
          Text(row["province"])
        ],
      ),
    );
  }
}
