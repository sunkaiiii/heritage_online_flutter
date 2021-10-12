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
                padding: const EdgeInsets.all(32),
                color: CupertinoColors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildNewsListInformation(),
                ))));
  }

  List<Widget> _buildNewsListInformation() {
    List<Widget> information = [];
    if (response.compressImg != null) {
      information.add(
        Container(
            padding: const EdgeInsets.only(left: 22),
            child: Image.network(
              "https://sunkai.xyz:5001/img/${response.compressImg}",
              height: 84,
              width: 84,
              fit: BoxFit.contain,
            )),
      );
    }
    information.add(Column(
      children: [
        const Text(
          "作者:",
          style: TextStyle(color: Color(0x888888), fontSize: 14),
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
          style: const TextStyle(color: Color(0x00bcbcbc), fontSize: 14),
        )
      ],
    ));
    return information;
  }
}
