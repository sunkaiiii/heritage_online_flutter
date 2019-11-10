import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(SimpleApp());

class SimpleApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title:'Sample App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget{
  SampleAppPage({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleAppPageState();
  }
}

class _SimpleAppPageState extends State<SampleAppPage>{
  List widgets=[];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: ListView.builder(itemCount: widgets.length,itemBuilder: (BuildContext context, int position){
        return getRow(position);
      },),
    );
  }
  Widget getRow(int i){
    return Padding(padding: EdgeInsets.all(10),
    child: Text("Row ${widgets[i]["title"]}"),);
  }

  loadData()async{
    String url="https://sunkai.xyz:5001/api/NewsList";
    http.Response response=await http.get(url);
    setState(() {
      widgets=json.decode(response.body);
    });
  }
}