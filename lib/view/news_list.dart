import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';
import 'package:heritage_online_flutter/view/general_progress_indicator.dart';

import '../entity/news_type.dart';
import '../pages/news_detail_page.dart';
import 'news_list_raw.dart';

class NewsSliverList extends StatefulWidget {
  NewsType newsListRepo;
  NetworkRepository networkRepo;
  NewsSliverList({required this.newsListRepo,required this.networkRepo,Key? key}) : super(key: key);
 

  @override
  State<NewsSliverList> createState() => _NewsSliverListState();
}

class _NewsSliverListState extends State<NewsSliverList> {
  List<NewsListResponse> response=[];
  int page=1;
  @override
  Widget build(BuildContext context) {
    fetchNewsData();
    if(response.isEmpty){
      return const SliverFillRemaining(child: GeneralProgressIndicator(),);
    }else{
      return SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              // This builder is called for each child.
              // In this example, we just number each list item.
              return NewsListRow(response[index], toDetailPage);
            },
            childCount: response.length,
          ));
    }

  }

  toDetailPage(final NewsListResponse response) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return NewsDetailPage(response.link, widget.newsListRepo);
    }));
  }
  
  fetchNewsData() async{
    var result = await widget.newsListRepo.getNewsListRequest(widget.networkRepo)(page++);
    response.addAll(result);
    if(mounted){
      setState(() {});
    }

  }
}
