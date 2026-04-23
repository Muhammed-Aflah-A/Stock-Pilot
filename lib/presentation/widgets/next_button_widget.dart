import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class NextbuttonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const NextbuttonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyles.nextButton(context),
      child: Text(text, style: TextStyles.buttonTextWhite(context)),
    );
  }
}
