import 'package:flutter/material.dart';

class BottomNavigationItem {
  late Image selectedImg;
  late Image unSelectedImg;
  String itemText;

  BottomNavigationItem(
      String selectedImgUrl, String unSelectedImgUrl, this.itemText) {
    selectedImg = _getTabImage(selectedImgUrl);
    unSelectedImg = _getTabImage(unSelectedImgUrl);
  }

  Image _getTabImage(String url) {
    return Image.asset(url, width: 20.0, height: 20.0);
  }
}
