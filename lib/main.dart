import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(SimpleApp());

class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-heritage',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleAppPageState();
  }
}

class _SimpleAppPageState extends State<SampleAppPage> {
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

  Widget getRow(int i) {
    return Container(
      color: Color.fromARGB(255, 230, 230, 230),
      padding: EdgeInsets.all(4),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }

  loadData() async {
    String url = "https://sunkai.xyz:5001/api/NewsList";
    http.Response response = await http.get(url);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
