import 'package:flutter/cupertino.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';

class NewsListRow extends StatelessWidget {
  final NewsListResponse response;
  ValueSetter<NewsListResponse>? onItemClick;
  NewsListRow(this.response, this.onItemClick, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: CupertinoColors.lightBackgroundGray,
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
            onTap: () => onItemClick?.call(response),
            child: Container(
                padding: const EdgeInsets.only(
                    left: 32, right: 32, top: 16, bottom: 16),
                color: CupertinoColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildNewsListInformation(),
                ))));
  }

  List<Widget> _buildNewsListInformation() {
    List<Widget> information = [];
    information.add(Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "作者:",
          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
        ),
        Text(
          response.title,
          style: const TextStyle(
              color: CupertinoColors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        Text(
          response.date,
          style: const TextStyle(color: Color(0xFFbcbcbc), fontSize: 14),
        )
      ],
    )));
    if (response.compressImg != null) {
      information.add(
        Container(
            padding: const EdgeInsets.only(left: 22),
            child: Image.network(
              "https://heritage.duckylife.net:8443/img/${response.compressImg}",
              height: 84,
              width: 84,
              fit: BoxFit.cover,
            )),
      );
    }

    return information;
  }
}
