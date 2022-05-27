import 'package:flutter/material.dart';

import 'package:heritage_online_flutter/data/data_repository.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/pages/main_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MainPage());

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataRepository = DataRepository();
    return MultiProvider(

      providers: [
        Provider(create: (_)=>dataRepository),
        Provider(create: (_)=> NetworkRepository(dataRepository)),
      ],
      child: const MaterialApp(title: 'E-heritage', home: MainPageTabScaffold()),
    );
  }
}
