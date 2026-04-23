import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

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
          color: selected
              ? ColourStyles.choiceColor2
              : ColourStyles.choiceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? ColourStyles.primaryColor_2
                : ColourStyles.borderColor,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
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
