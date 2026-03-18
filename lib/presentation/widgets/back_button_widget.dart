import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// Button created to navigate back to previous page
class BackbuttonWidget extends StatelessWidget {
  const BackbuttonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ButtonStyles.backButton(context),
      // Button label
      child: Text("Back", style: TextStyles.buttonTextBlack(context)),
    );
  }
}
