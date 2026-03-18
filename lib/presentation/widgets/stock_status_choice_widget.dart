import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// A reusable widget used to display a stock status option
class StockStatusChoiceWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const StockStatusChoiceWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // Background color changes when selected
          color: selected
              ? ColourStyles.choiceColor2
              : ColourStyles.choiceColor,
          borderRadius: BorderRadius.circular(10),
          // Border color also changes depending on selection state
          border: Border.all(
            color: selected
                ? ColourStyles.primaryColor_2
                : ColourStyles.borderColor,
            width: 1.5,
          ),
        ),
        // Stock status label text
        child: Text(
          label,
          // Text style changes depending on whether it is selected
          style: selected
              ? TextStyles.primaryText(context)
              : TextStyles.primaryText(
                  context,
                ).copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
