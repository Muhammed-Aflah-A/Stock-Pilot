import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class ValueStyleUtil {
  static TextStyle getValueStyle(BuildContext context, String title) {
    if (title == "Monthly Turnover") {
      return TextStyles.valueText(
        context,
      ).copyWith(color: ColourStyles.colorGreen);
    }
    if (title == "Low Stock") {
      return TextStyles.valueText(
        context,
      ).copyWith(color: ColourStyles.colorYellow);
    }
    if (title == "Out of Stock") {
      return TextStyles.valueText(context).copyWith(color: ColourStyles.colorRed);
    }
    return TextStyles.valueText(context);
  }
}
