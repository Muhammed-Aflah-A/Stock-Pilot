class NumberFormatterUtil {
  static String format(num value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      if (value is int || value == value.toInt()) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(1);
    }
  }

  static String formatCurrency(num value, {String symbol = '₹'}) {
    return '$symbol ${format(value)}';
  }
}
