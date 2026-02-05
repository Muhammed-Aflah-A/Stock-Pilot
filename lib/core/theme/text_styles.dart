import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class TextStyles {
  static double _getFontSize(BuildContext context, double baseSize) {
    final double width = MediaQuery.of(context).size.width;
    const double referenceWidth = 375.0;
    double scaleFactor = width / referenceWidth;
    scaleFactor = scaleFactor.clamp(0.85, 1.4);
    return baseSize * scaleFactor;
  }

  static TextStyle _responsive(BuildContext context, TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontSize: _getFontSize(context, baseStyle.fontSize ?? 14),
      height: baseStyle.height ?? 1.2,
    );
  }

  static TextStyle splashQuote(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 18,
      fontFamily: "Agbalumo",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle stroke(BuildContext context) => _responsive(
    context,
    TextStyle(
      fontSize: 40,
      fontFamily: "FrancoisOne",
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle stockText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 40,
      fontFamily: "FrancoisOne",
      color: ColourStyles.primaryColor,
    ),
  );

  static TextStyle pilotText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 40,
      fontFamily: "FrancoisOne",
      color: ColourStyles.pilotTextColor,
    ),
  );
  static TextStyle tagLine(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle tagLineCaption(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle indroductionHeading(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 40,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle indroductionCaption(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 16,
      fontFamily: "Adamina",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle formLabel(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 20,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle formHint(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 16,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle dialogueHeading(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle appBarHeading(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle primaryText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle buttonTextWhite(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 20,
      fontFamily: "Aldrich",
      color: ColourStyles.primaryColor,
    ),
  );

  static TextStyle buttonTextBlack(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 20,
      fontFamily: "Aldrich",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle smallButtonTextWhite(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 15,
      fontFamily: "Aldrich",
      color: ColourStyles.primaryColor,
    ),
  );

  static TextStyle smallButtonTextBlack(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 15,
      fontFamily: "Aldrich",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle buttonCaption(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle titleText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle valueText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle sectionHeading(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle cardHeading(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle activityCardText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle activityCardUnit(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
    ),
  );

  static TextStyle activityCardLabel(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle productPriceText(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: "ManRope",
      color: ColourStyles.primaryColor_2,
    ),
  );

  static TextStyle caption(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 16,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static TextStyle caption2(BuildContext context) => _responsive(
    context,
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: "ManRope",
      color: ColourStyles.colorGrey,
    ),
  );

  static const TextStyle primaryTextWhite = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor,
  );
}
