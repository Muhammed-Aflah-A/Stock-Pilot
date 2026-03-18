import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// A reusable row widget used to display a label and its value
class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;

  final bool showDivider;
  final Color? valueColor;
  final bool showDot;

  const DetailRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.valueColor,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main row containing label and value
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label text (left side)
              Text(label, style: TextStyles.caption2(context)),
              // Value section (right side)
              Row(
                children: [
                  // Used for statuses like "In Stock", "Active", etc.
                  if (showDot)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: valueColor ?? ColourStyles.primaryColor_2,
                        shape: BoxShape.circle,
                      ),
                    ),
                  // Value text
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? ColourStyles.primaryColor_2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Optional divider separating rows
        if (showDivider) const Divider(),
      ],
    );
  }
}
