import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class FloatingActionButtonWidget extends StatelessWidget {

  final VoidCallback onPressed;

  const FloatingActionButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPressed();
      },
      foregroundColor: ColourStyles.primaryColor,
      backgroundColor: ColourStyles.primaryColor_2,
      child: const Icon(Icons.add),
    );
  }
}
