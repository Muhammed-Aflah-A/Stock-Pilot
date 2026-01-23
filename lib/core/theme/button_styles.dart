import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ButtonStyles {
  static double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return size * 0.9; // Small phones
    if (screenWidth < 600) return size * 1.0; // Normal phones
    if (screenWidth < 900) return size * 1.1; // Tablets
    return size * 1.2; // Desktop
  }

  static Size _responsiveSize(
    BuildContext context,
    double width,
    double height,
  ) {
    return Size(_scale(context, width), _scale(context, height));
  }

  static ButtonStyle nextButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: _responsiveSize(context, 280, 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      );

  static ButtonStyle backButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor,
        foregroundColor: ColourStyles.primaryColor_2,
        minimumSize: _responsiveSize(context, 280, 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle dialogBackButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor,
        foregroundColor: ColourStyles.primaryColor_2,
        minimumSize: _responsiveSize(context, 250, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle dialogNextButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: _responsiveSize(context, 250, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle smallDialogBackButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor,
        foregroundColor: ColourStyles.primaryColor_2,
        minimumSize: Size(120, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle smallDialogNextButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: Size(120, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );

  static final detailPageButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.primaryColor,
    foregroundColor: ColourStyles.primaryColor_2,
    minimumSize: Size(120, 60),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
  );

  static final detailPageButton_2 = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.primaryColor_2,
    foregroundColor: ColourStyles.primaryColor,
    minimumSize: Size(400, 60),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
  );

  static final removeButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.colorRed,
    foregroundColor: ColourStyles.primaryColor,
    minimumSize: Size(120, 60),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: ColourStyles.colorRed, width: 2),
  );
  static final removeButton_2 = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.colorRed,
    foregroundColor: ColourStyles.primaryColor,
    minimumSize: Size(120, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide(color: ColourStyles.colorRed, width: 2),
  );
}
