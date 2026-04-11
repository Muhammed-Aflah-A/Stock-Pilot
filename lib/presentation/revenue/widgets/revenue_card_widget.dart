import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';

class RevenueCardWidget extends StatelessWidget {
  final String title;
  final double amount;

  const RevenueCardWidget({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColourStyles.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColourStyles.borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(color: ColourStyles.shadowColor, blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.sectionHeading(context).copyWith(
                color: ColourStyles.captionColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormatterUtil.formatCurrency(amount),
              style: TextStyles.valueText(
                context,
              ).copyWith(color: ColourStyles.primaryColor_2),
            ),
          ],
        ),
      ),
    );
  }
}
