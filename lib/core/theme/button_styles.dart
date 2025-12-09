import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ButtonStyles {
  static final nextButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.nextButtonColor,
    foregroundColor: ColourStyles.nextButtonTextColor,
    minimumSize: Size(280, 70),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  );
  static final backButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.backButtonColor,
    foregroundColor: ColourStyles.backButtonTextColor,
    minimumSize: Size(280, 70),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide(color: ColourStyles.backButtonborderColor, width: 1),
  );
}
