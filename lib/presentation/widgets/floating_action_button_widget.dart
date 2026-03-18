import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

// Reusable Floating Action Button widget
class FloatingActionButtonWidget extends StatelessWidget {

  final VoidCallback onPressed;

  const FloatingActionButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Executes the callback passed from the parent screen
      onPressed: onPressed,
      foregroundColor: ColourStyles.primaryColor,
      backgroundColor: ColourStyles.primaryColor_2,
      // Add icon inside the button
      child: const Icon(Icons.add),
    );
  }
}
