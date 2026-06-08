/// 年份筛选工具
/// 统一的年份校验逻辑
class YearFilterParser {
  /// 最小有效年份
  static const int minYear = 1900;

  /// 解析年份筛选值
  /// 返回 null 表示"不限"（空字符串）
  /// 返回 int 表示有效年份
  /// 返回 null（带错误）表示格式不正确
  static int? parse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final year = int.tryParse(trimmed);
    if (year == null) return null; // 不是数字

    return year;
  }

  /// 校验年份输入是否合法
  static bool isValid(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return true; // 空值允许，表示不限

    if (trimmed.length != 4) return false;

    final year = int.tryParse(trimmed);
    if (year == null) return false;

    // 年份范围校验
    if (year < minYear || year > DateTime.now().year + 1) return false;

    return true;
  }

  /// 获取错误消息（返回 null 表示无错误）
  static String? validate(String text) {
    if (text.trim().isEmpty) return null;

    if (text.trim().length != 4) return '请输入4位年份';

    final year = int.tryParse(text.trim());
    if (year == null) return '请输入有效年份';

    if (year < minYear || year > DateTime.now().year + 1) {
      return '年份范围: $minYear - ${DateTime.now().year + 1}';
    }

    return null;
  }
}
