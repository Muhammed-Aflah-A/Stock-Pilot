import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class TextStyles {
  static const TextStyle splashQuote = TextStyle(
    fontSize: 20,
    fontFamily: "Agbalumo",
    color: ColourStyles.primaryColor,
  );

  static final TextStyle stroke = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = ColourStyles.primaryColor_2,
  );

  static const TextStyle stockText = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    color: ColourStyles.primaryColor,
  );

  static const TextStyle pilotText = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    color: ColourStyles.pilotTextColor,
  );

  static const TextStyle tagLine = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle caption_2 = TextStyle(
    fontSize: 16,
    fontFamily: "Adamina",
    color: ColourStyles.captionColor,
  );

  static const TextStyle caption_3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor_2,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
    fontFamily: "Aldrich",
    color: ColourStyles.primaryColor,
  );

  static const TextStyle buttonText_2 = TextStyle(
    fontSize: 20,
    fontFamily: "Aldrich",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 40,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle heading_2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle formLabel = TextStyle(
    fontSize: 20,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle primaryText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle primaryTextRed = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: "ManRope",
    color: ColourStyles.colorRed,
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

  static const TextStyle heading_3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle primaryText_2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle primaryText_3 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryColor_2,
  );

  static const TextStyle primaryText_4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.primaryTextBlue,
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
}
