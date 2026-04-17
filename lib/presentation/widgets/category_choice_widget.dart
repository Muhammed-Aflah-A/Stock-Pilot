import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class CategoryChoiceWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChoiceWidget({
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
        padding: EdgeInsets.symmetric(
          horizontal: (size.width * 0.04).clamp(12.0, 20.0),
          vertical: (size.height * 0.008).clamp(6.0, 10.0),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(
                Icons.check,
                size: 14,
                color: ColourStyles.primaryColor_2,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: selected
                  ? TextStyles.primaryText(context).copyWith(fontSize: 12)
                  : TextStyles.primaryText(
                      context,
                    ).copyWith(fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

