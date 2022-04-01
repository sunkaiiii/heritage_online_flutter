import 'package:flutter/material.dart';
import 'package:heritage_online_flutter/network/network_repository.dart';
import 'package:heritage_online_flutter/network/response/banner_response.dart';
import 'package:provider/provider.dart';

class MainPageTopPager extends StatelessWidget {
  const MainPageTopPager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bannerBody(context);
  }

  FutureBuilder<List<BannerResponse>> bannerBody(BuildContext context) {
    NetworkRepository repo = Provider.of<NetworkRepository>(context);
    return FutureBuilder<List<BannerResponse>>(
        future: repo.getBanner(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<BannerResponse> response = snapshot.data ?? [];
            return bannerPager(response);
          } else {
            return const Center();
          }
        });
  }

  bannerPager(List<BannerResponse> response) {
    final PageController controller = PageController(initialPage: 1);
    return PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: bannerPagerItem(response));
  }

  bannerPagerItem(List<BannerResponse> response) {
    List<Widget> item = [];
    for (var element in response) {
      item.add(Image.network(
        "https://www.sunkai.xyz:5001/img/${element.compressImg}",
        fit: BoxFit.fitHeight,
      ));
    }
    return item;
  }
}
