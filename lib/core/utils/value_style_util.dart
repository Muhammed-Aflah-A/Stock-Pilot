import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class ValueStyleUtil {
  static TextStyle getValueStyle(BuildContext context, String title) {
    final baseStyle = TextStyles.valueText(context);
    if (title == "Monthly Turnover") {
      return baseStyle.copyWith(color: ColourStyles.colorGreen);
    }
    if (title == "Low Stock") {
      return baseStyle.copyWith(color: ColourStyles.colorYellow);
    }
    if (title == "Out of Stock") {
      return baseStyle.copyWith(color: ColourStyles.colorRed);
    }
    return baseStyle;
  }
}
