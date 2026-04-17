import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class BrandChoiceWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const BrandChoiceWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(
          horizontal: (size.width * 0.04).clamp(12.0, 20.0),
          vertical: (size.height * 0.016).clamp(12.0, 18.0),
        ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: selected
                  ? TextStyles.primaryText(context).copyWith(fontSize: 12)
                  : TextStyles.primaryText(
                      context,
                    ).copyWith(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            if (selected)
              const Icon(
                Icons.check,
                size: 16,
                color: ColourStyles.primaryColor_2,
              ),
          ],
        ),
      ),
    );
  }
}

