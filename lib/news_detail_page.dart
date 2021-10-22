import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/news_type.dart';
import 'package:heritage_online_flutter/network/response/news_detail_response.dart';
import 'package:heritage_online_flutter/view/general_progress_indicator.dart';

class NewsDetailPage extends StatelessWidget {
  final String link;
  final NewsType newsType;

  const NewsDetailPage(this.link, this.newsType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("NewsDetail"),
          previousPageTitle: "首页",
          backgroundColor: CupertinoColors.white,
        ),
        child: _detailBody());
  }

  FutureBuilder<NewsDetailResponse> _detailBody() {
    return FutureBuilder(
        future: newsType.detailRequest(link),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final NewsDetailResponse? response = snapshot.data;
            if (response != null) {
              return NewsDetailContentList(response);
            } else {
              return const Center(
                child: Text("没有数据"),
              );
            }
          } else {
            return const GeneralProgressIndicator();
          }
        });
  }
}

class NewsDetailContentList extends StatelessWidget {
  final NewsDetailResponse newsDetailResponse;
  const NewsDetailContentList(this.newsDetailResponse, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScroll) {
          return [
            SliverToBoxAdapter(
              child: Text(newsDetailResponse.title),
            )
          ];
        },
        body: ListView.builder(
            itemCount: newsDetailResponse.content.length,
            itemBuilder: (context, index) {
              return getRow(index);
            }));
  }

  getRow(int index) {
    final Content rowData = newsDetailResponse.content[index];
    if (rowData.type == "img") {
      return Image.network(
        "https://sunkai.xyz:5001/img/${rowData.compressImg}",
        fit: BoxFit.contain,
      );
    } else {
      return Text(rowData.content ?? "");
    }
  }
}
