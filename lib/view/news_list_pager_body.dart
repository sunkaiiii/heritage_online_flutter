import 'package:flutter/cupertino.dart';

class NewsListPagerSegment extends StatefulWidget {
  ValueChanged<int>? segmentChange;
  NewsListPagerSegment(this.segmentChange, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _NewsListPagerSegmentState(segmentChange);
}

class _NewsListPagerSegmentState extends State<NewsListPagerSegment> {
  int? groupValue = 0;
  final barText = ['最新', '论坛', '特别报道'];
  ValueChanged<int>? segmentChange;

  _NewsListPagerSegmentState(this.segmentChange);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff666666),
        padding: const EdgeInsets.only(left: 36, right: 36),
        child: Column(
          children: [
            Stack(
              children: const [
                Align(alignment: Alignment.centerLeft, child: Text("data")),
                Align(alignment: Alignment.centerRight, child: Text("ddd"))
              ],
            ),
            CupertinoSlidingSegmentedControl<int>(
                children: newsSegments(barText),
                groupValue: groupValue,
                onValueChanged: (value) {
                  setState(() {
                    groupValue = value;
                    segmentChange?.call(value ?? 0);
                  });
                })
          ],
        ));
  }

  newsSegments(List<String> barTexts) {
    Map<int, Widget> result = {};
    for (int i = 0; i < barTexts.length; i++) {
      result[i] = Text(barTexts[i]);
    }
    return result;
  }
}
