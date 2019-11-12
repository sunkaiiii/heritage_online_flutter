import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/NewsDetailPage.dart';
import 'package:http/http.dart' as http;

void main() => runApp(SimpleApp());

class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-heritage',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainListPage(),
    );
  }
}

class MainListPage extends StatefulWidget {
  MainListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageListState();
  }
}

class MainPageListState extends State<MainListPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  getListView() {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      },
    );
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("E-heritage"),
        ),
        body: getBody());
  }

  toDetailPage(widget) {
    Map<String,String> info=Map();
    info["content"]=widget["content"];
    info["title"]=widget["title"];
    info["link"]=widget["link"];
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return NewsDetailPage(info);
    }));
  }

  Widget getRow(int i) {
    return Container(
        color: Color.fromARGB(255, 230, 230, 230),
        padding: EdgeInsets.all(4),
        child: GestureDetector(
          onTap: ()=>toDetailPage(widgets[i]),
          child: Card(
            elevation: 2,
            child: Container(
              child: Column(
                children: <Widget>[
                  Image(
                    image: NetworkImage(
                        "https://sunkai.xyz:5001/img/${widgets[i]["img"]}"),
                    fit: BoxFit.contain,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widgets[i]["title"]}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widgets[i]["date"]}",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text("${widgets[i]["content"]}",
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  loadData() async {
    String url = "https://sunkai.xyz:5001/api/NewsList";
    http.Response response = await http.get(url);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
