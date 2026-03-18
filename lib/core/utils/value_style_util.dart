import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Utility class used to control the color styling of dashboard values
class ValueStyleUtil {
  // Returns the correct TextStyle for a dashboard card value
  static TextStyle getValueStyle(BuildContext context, String title) {
    // Get the default value text style from the app theme
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
