import 'package:intl/intl.dart';

class DateUtil {
  static const String formatPattern = 'dd - MMM - yyyy';

  static String now() {
    return DateFormat(formatPattern, 'en_US').format(DateTime.now());
  }

  static String format(DateTime date) {
    return DateFormat(formatPattern, 'en_US').format(date);
  }

  static DateTime? parse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      if (dateStr.contains('/')) {
        return DateFormat('dd/MM/yyyy', 'en_US').parse(dateStr);
      } else {
        return DateFormat(formatPattern, 'en_US').parse(dateStr);
      }
    } catch (e) {
      return null;
    }
  }

  static bool isSameMonth(String? dateStr, int month, int year) {
    final date = parse(dateStr);
    if (date == null) return false;
    return date.month == month && date.year == year;
  }
}
