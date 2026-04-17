import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyles.caption2(context)),
              Row(
                children: [
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
        if (showDivider) const Divider(),
      ],
    );
  }
}

