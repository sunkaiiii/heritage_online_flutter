import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class HeritageProjectPage extends StatelessWidget {
  const HeritageProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("非遗项目"),
        backgroundColor: CupertinoColors.white,
      ),
      child: HeritageBodyWidget(),
    );
  }
}

class HeritageBodyWidget extends StatelessWidget {
  const HeritageBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScroll) {
        return <Widget>[
          const SliverToBoxAdapter(
            child: HeritageBodyTopWidget(),
          )
        ];
      },
      body: HeritageBodyBottomWidget(),
    );
  }
}

class HeritageBodyTopWidget extends StatefulWidget {
  const HeritageBodyTopWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HeritageTopBodyState();
  }
}

class HeritageTopBodyState extends State<HeritageBodyTopWidget> {
  Map? result;

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
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Column(
      children: <Widget>[
        Center(
          child: Text(result?["title"]),
        ),
        Text(result?["content"]),
      ],
    );
  }

  void loadData() async {
    String url = "https://sunkai.xyz:5001/api/HeritageProject/GetMainPage";
    var response = await get(Uri.parse(url));
    setState(() {
      result = jsonDecode(response.body);
    });
  }
}

class HeritageBodyBottomWidget extends StatefulWidget {
  const HeritageBodyBottomWidget({Key? key}) : super(key: key);

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
    var response = await get(Uri.parse(url));
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
      return const CupertinoActivityIndicator();
    }
    Map rowInfo = result[i];
    return HeritageProjectRow(rowInfo);
  }
}

class HeritageProjectRow extends StatefulWidget {
  Map result;

  HeritageProjectRow(this.result, {Key? key}) : super(key: key);

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
    return getRow();
  }

  getRow() {
    var widgets = <Widget>[];
    widgets = <Widget>[Text(row["title"] + "(${row["province"]})")];
    if (expended) {
      var rowValues = row.values.toList();
      print("rowValues" + rowValues.toString());
      widgets.add(Container(
          height: 200,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0,
                ),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 5)],
                    child: Text(rowValues[index]),
                  );
                }, childCount: rowValues.length),
              )
            ],
          )));
//      widgets.add(Container(
//          color: Colors.grey,
//          child: Column(
//            children: <Widget>[
//              Text(row["num"]),
//              Text(row["type"]),
//              Text(row["rx_time"]),
//            ],
//          )));
    }
    return GestureDetector(
        onTap: () {
          setState(() {
            expended = !expended;
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ));
  }
}
