/// 年份筛选工具
/// 统一的年份校验逻辑
class YearFilterParser {
  /// 最小有效年份
  static const int minYear = 1900;

  /// 解析年份筛选值，只返回合法年份或 null
  /// 空字符串返回 null（表示"不限"）
  /// 非法值（非4位、超出范围、非数字）返回 null
  static int? tryParseValidYear(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    if (trimmed.length != 4) return null;

    final year = int.tryParse(trimmed);
    if (year == null) return null;

    if (year < minYear || year > DateTime.now().year + 1) return null;

    return year;
  }

  /// 解析年份筛选值（兼容旧接口）
  /// 只返回合法年份或 null
  static int? parse(String text) {
    return tryParseValidYear(text);
  }

  /// 校验年份输入是否合法
  static bool isValid(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return true; // 空值允许，表示不限

    if (trimmed.length != 4) return false;

    final year = int.tryParse(trimmed);
    if (year == null) return false;

    if (year < minYear || year > DateTime.now().year + 1) return false;

    return true;
  }

  /// 获取错误类型
  static YearFilterError? getError(String text) {
    if (text.trim().isEmpty) return null;

    if (text.trim().length != 4) return YearFilterError.invalidFormat;

    final year = int.tryParse(text.trim());
    if (year == null) return YearFilterError.invalidFormat;

    if (year < minYear || year > DateTime.now().year + 1) {
      return YearFilterError.outOfRange;
    }

    return null;
  }
}

/// 年份校验错误类型
enum YearFilterError {
  invalidFormat,
  outOfRange;
}
