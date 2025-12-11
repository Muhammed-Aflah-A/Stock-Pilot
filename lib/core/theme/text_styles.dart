import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class TextStyles {
  static const TextStyle quote = TextStyle(
    fontSize: 20,
    fontFamily: "Agbalumo",
    color: ColourStyles.quoteColor,
  );

  static final TextStyle stroke = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = ColourStyles.strokeColor,
  );

  static const TextStyle stockText = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    color: ColourStyles.stockTextColor,
  );

  static const TextStyle pilotText = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    color: ColourStyles.pilotTextColor,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 40,
    fontFamily: "ManRope",
    color: ColourStyles.headingColor,
  );

  static const TextStyle heading_2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: "ManRope",
    color: ColourStyles.headingColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle caption_2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: "ManRope",
    color: ColourStyles.captionColor,
  );

  static const TextStyle caption_3 = TextStyle(
    fontSize: 16,
    fontFamily: "Adamina",
    color: ColourStyles.captionColor,
  );

  static const TextStyle primaryButtonText = TextStyle(
    fontSize: 20,
    fontFamily: "Aldrich",
    color: ColourStyles.nextButtonTextColor,
  );

  static const TextStyle backButtonText = TextStyle(
    fontSize: 20,
    fontFamily: "Aldrich",
    color: ColourStyles.backButtonTextColor,
  );

  static const TextStyle formLabel = TextStyle(
    fontSize: 20,
    fontFamily: "ManRope",
    color: ColourStyles.labelColor,
  );
}
