class NumberFormatterUtil {
  /// Formats a number with 'k', 'M', 'B' suffixes.
  /// Example: 1500 -> 1.5k, 1200000 -> 1.2M
  static String format(num value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      // For smaller numbers, show the full value but formatted (e.g. integer if possible)
      if (value is int || value == value.toInt()) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(1);
    }
  }

  /// Formats a number as a currency string with suffixes.
  /// Example: 1500 -> $1.5k
  static String formatCurrency(num value, {String symbol = '\$'}) {
    return '$symbol${format(value)}';
  }
}
