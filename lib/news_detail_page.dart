import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/entity/news_type.dart';
import 'package:heritage_online_flutter/helper/image_url_helper.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/news_detail_response.dart';
import 'package:heritage_online_flutter/view/general_progress_indicator.dart';
import 'package:provider/provider.dart';

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
          backgroundColor: Color(0xFFD0C6C1),
        ),
        child: Container(
          child: _detailBody(context),
          color: const Color(0xFFD0C6C1),
        ));
  }

  FutureBuilder<NewsDetailResponse> _detailBody(BuildContext context) {
    var repo = Provider.of<NetworkRepository>(context);
    return FutureBuilder(
        future: newsType.getDetailRequest(repo)(link),
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
    return Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScroll) {
              return [
                SliverToBoxAdapter(
                    child: Column(
                  children: newsDetailHeaderWidgets(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                ))
              ];
            },
            body: ListView.builder(
                itemCount: newsDetailResponse.content.length,
                itemBuilder: (context, index) {
                  return getRow(index);
                })));
  }

  getRow(int index) {
    final Content rowData = newsDetailResponse.content[index];
    if (rowData.type == "img") {
      return Image.network(
        "https://www.sunkai.xyz:5001/img/${rowData.compressImg}",
        fit: BoxFit.contain,
      );
    } else {
      return Text(rowData.content ?? "");
    }
  }

  newsDetailHeaderWidgets() {
    List<Widget> result = [];
    final imgUrl = newsDetailResponse.compressImg;
    if (imgUrl != null) {
      result.add(Image.network(imgUrl.buildImageRequestUrl()));
    }
    result.add(Text(newsDetailResponse.title,
        style: const TextStyle(
            color: CupertinoColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold)));
    result.add(ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding:
            const EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 15),
        child: Text(
          newsDetailResponse.subContent,
          style: const TextStyle(color: CupertinoColors.black, fontSize: 14),
        ),
        color: const Color(0XFFE4E4E4),
      ),
    ));
    TextStyle authorAndDateTextStyle =
        const TextStyle(color: Color(0xff1D0500), fontSize: 14);
    result.add(const SizedBox(
      height: 10,
    ));
    result.add(Text(
      newsDetailResponse.author,
      style: authorAndDateTextStyle,
    ));
    result.add(Text(
      newsDetailResponse.date,
      style: authorAndDateTextStyle,
    ));
    return result;
  }
}
