import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class FloatingactionbuttonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const FloatingactionbuttonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      foregroundColor: ColourStyles.primaryColor,
      backgroundColor: ColourStyles.primaryColor_2,
      child: Icon(Icons.add),
    );
  }
}
