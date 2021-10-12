import 'package:flutter/cupertino.dart';
import 'package:heritage_online_flutter/network/repository.dart';
import 'package:heritage_online_flutter/network/response/news_list_response.dart';

class NewsList extends StatefulWidget {
  ValueSetter? onItemClick;
  final Function request;
  NewsList(this.request, this.onItemClick, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsListState(request, onItemClick);
}

class _NewsListState extends State<NewsList> {
  ValueSetter? onItemClick;
  final Function request;
  _NewsListState(this.request, this.onItemClick);

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      top: false,
      sliver: _newsListBody(context),
    );
  }

  FutureBuilder<List<NewsListResponse>> _newsListBody(BuildContext context) {
    return FutureBuilder<List<NewsListResponse>>(
        future: request(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<NewsListResponse> response = snapshot.data ?? [];
            return getListView(response);
          } else {
            return SliverFillRemaining(child: getProgressDialog());
          }
        });
  }

  getListView(List<NewsListResponse> response) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return getRow(index < response.length ? response[index] : null);
      }, childCount: response.length + 1),
    );
  }

  Widget getRow(final NewsListResponse? response) {
    if (response != null) {
      return Container(
          color: CupertinoColors.lightBackgroundGray,
          padding: EdgeInsets.all(4),
          child: GestureDetector(
              onTap: () => onItemClick?.call(response),
              child: Container(
                color: CupertinoColors.white,
                child: Column(
                  children: <Widget>[
                    response.compressImg != null
                        ? Image(
                            image: NetworkImage(
                                "https://sunkai.xyz:5001/img/${response.compressImg}"),
                            fit: BoxFit.contain,
                          )
                        : Text('123'),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            response.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            response.date,
                            style: TextStyle(
                                color: CupertinoColors.inactiveGray,
                                fontSize: 14),
                          ),
                          Text(response.content, style: TextStyle(fontSize: 16))
                        ],
                      ),
                    )
                  ],
                ),
              )));
    }
    return CupertinoActivityIndicator();
  }

  getProgressDialog() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
