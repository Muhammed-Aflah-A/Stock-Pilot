import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ButtonStyles {
  static double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    if (screenWidth < 900) return size * 1.1;
    return size * 1.2;
  }

  static Size _responsiveSize(
    BuildContext context,
    double width,
    double height,
  ) {
    return Size(_scale(context, width), _scale(context, height));
  }

  static ButtonStyle skipButton(BuildContext context) =>
      TextButton.styleFrom(foregroundColor: ColourStyles.primaryColor_2);

  static ButtonStyle nextButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: _responsiveSize(context, 280, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );

  static ButtonStyle backButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor,
        foregroundColor: ColourStyles.primaryColor_2,
        minimumSize: _responsiveSize(context, 280, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        minimumSize: Size(110, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle smallDialogNextButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: Size(120, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );

  static ButtonStyle detailPageEditButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor,
        foregroundColor: ColourStyles.primaryColor_2,
        minimumSize: Size(110, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle detailPageRemoveButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.colorRed,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: Size(110, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColourStyles.colorRed, width: 2),
      );

  static ButtonStyle dialogueRemoveButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.colorRed,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: Size(120, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColourStyles.colorRed, width: 2),
      );

  static ButtonStyle dialogueAddButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.colorGreen,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: Size(120, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColourStyles.colorGreen, width: 2),
      );

  static ButtonStyle detailPageButton_2(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: Size(400, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
      );

  static ButtonStyle billingButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: ColourStyles.primaryColor_2,
        foregroundColor: ColourStyles.primaryColor,
        minimumSize: _responsiveSize(context, 100, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );
}

