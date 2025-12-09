import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class TextStyles {
  static const TextStyle logoQuote = TextStyle(
    fontSize: 20,
    fontFamily: "Agbalumo",
    color: ColourStyles.logoQuoteColor,
  );
  static final TextStyle logoNameStroke = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = ColourStyles.logoNameStrokeColor,
  );
  static const TextStyle logoNameStock = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    color: ColourStyles.logoNameStockColor,
  );
  static const TextStyle logoNamePilot = TextStyle(
    fontSize: 40,
    fontFamily: "FrancoisOne",
    color: ColourStyles.logoNamePilotColor,
  );
  static const TextStyle onboardingHeading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: "ManRope",
    color: ColourStyles.onboardingHeadingColor,
  );
  static const TextStyle onboardingMessage = TextStyle(
    fontSize: 20,
    fontFamily: "ManRope",
    color: ColourStyles.onboardingMessageColor,
  );
  static const TextStyle nextButtonText = TextStyle(
    fontSize: 20,
    fontFamily: "Aldrich",
    color: ColourStyles.nextButtonTextColor,
  );
  static const TextStyle backButtonText = TextStyle(
    fontSize: 20,
    fontFamily: "Aldrich",
    color: ColourStyles.backButtonTextColor,
  );
}
