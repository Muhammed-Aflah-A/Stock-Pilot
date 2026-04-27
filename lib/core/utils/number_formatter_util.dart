class NumberFormatterUtil {
  static String format(num value) {
    if (value.abs() >= 1e15) {
      return '${_formatValue(value / 1e15)}Q';
    } else if (value.abs() >= 1e12) {
      return '${_formatValue(value / 1e12)}T';
    } else if (value.abs() >= 1e9) {
      return '${_formatValue(value / 1e9)}B';
    } else if (value.abs() >= 1e6) {
      return '${_formatValue(value / 1e6)}M';
    } else if (value.abs() >= 1e3) {
      return '${_formatValue(value / 1e3)}K';
    } else {
      return _formatValue(value);
    }
  }

  static String _formatValue(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    String formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('.0')) {
      return formatted.substring(0, formatted.length - 2);
    }
    return formatted;
  }

  static String formatCurrency(num value, {String symbol = '₹'}) {
    return '$symbol ${format(value)}';
  }
}
