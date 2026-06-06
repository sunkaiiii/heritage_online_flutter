import 'package:flutter/material.dart';

/// Heritage Online Shape Token
/// 圆角规则：卡片、chip、图片占位统一 8dp
class HeritageShapes {
  HeritageShapes._();

  /// 4dp - 最小圆角
  static const double extraSmallRadius = 4.0;

  /// 8dp - 卡片、chip、图片占位标准圆角
  static const double smallRadius = 8.0;

  /// 8dp - 中等圆角
  static const double mediumRadius = 8.0;

  /// 8dp - 大圆角
  static const double largeRadius = 8.0;

  /// 8dp - 超大圆角
  static const double extraLargeRadius = 8.0;

  /// extraSmall 形状 - 4dp 圆角
  static final RoundedRectangleBorder extraSmallShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(extraSmallRadius),
  );

  /// small 形状 - 8dp 圆角
  static final RoundedRectangleBorder smallShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(smallRadius),
  );

  /// medium 形状 - 8dp 圆角
  static final RoundedRectangleBorder mediumShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(mediumRadius),
  );

  /// large 形状 - 8dp 圆角
  static final RoundedRectangleBorder largeShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(largeRadius),
  );

  /// extraLarge 形状 - 8dp 圆角
  static final RoundedRectangleBorder extraLargeShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(extraLargeRadius),
  );
}
