import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class TextStyles {
  static double _getFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Scale factor based on screen width
    // Mobile: 1.0x
    //Tablet: 1.1-1.2x
    // Desktop: 1.2-1.3x
    if (screenWidth < 360) return baseSize * 0.9; // Small phones
    if (screenWidth < 600) return baseSize * 1.0; // Normal phones
    if (screenWidth < 900) return baseSize * 1.1; // Tablets
    return baseSize * 1.2;
  }

  static TextStyle _responsive(BuildContext context, TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontSize: _getFontSize(context, baseStyle.fontSize ?? 14),
    );
  }

  static TextStyle splashQuote(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 18,
      fontFamily: "Agbalumo",
      color: ColourStyles.primaryColor,
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

  static TextStyle dialogueHeading(BuildContext context) => _responsive(
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
      fontSize: 16,
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

  static TextStyle buttonCaption(BuildContext context) => _responsive(
    context,
    const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: "ManRope",
      color: ColourStyles.captionColor,
    ),
  );

  static const TextStyle caption_4 = TextStyle(
    fontSize: 16,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle heading_3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );
  static const TextStyle heading_4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle formLabel = TextStyle(
    fontSize: 20,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );
  static const TextStyle formHint = TextStyle(
    fontSize: 16,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle primaryText_2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle dashboardCardText = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle recentCardtext = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle recentCardtext_2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
  );

  static const TextStyle recentCardtext_3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle primaryTextWhite = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor,
  );

  static const TextStyle primaryTextBlue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.colorBlue,
  );

  static const TextStyle turnOver = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.colorGreen,
  );

  static const TextStyle lowStock = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.colorYellow,
  );

  static const TextStyle outOfStock = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.colorRed,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle label_2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );
}
