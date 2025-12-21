import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ButtonStyles {
  static final nextButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.primaryColor_2,
    foregroundColor: ColourStyles.primaryColor,
    minimumSize: Size(280, 70),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  );

  static final backButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.primaryColor,
    foregroundColor: ColourStyles.primaryColor_2,
    minimumSize: Size(280, 70),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
  );

  static final dialogNextButton = ElevatedButton.styleFrom(
    backgroundColor: ColourStyles.primaryColor_2,
    foregroundColor: ColourStyles.primaryColor,
    minimumSize: Size(250, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  );

  static final dialogBackButton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    foregroundColor: ColourStyles.primaryColor_2,
    minimumSize: Size(250, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    side: BorderSide(color: ColourStyles.primaryColor_2, width: 2),
  );

}
