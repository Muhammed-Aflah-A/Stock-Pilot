import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class EmptypageMessageWidget extends StatelessWidget {
  final String heading;
  final String label;
  final IconData icon;

  const EmptypageMessageWidget({
    super.key,
    required this.heading,
    required this.label,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: ColourStyles.colorGrey),
          const SizedBox(height: 16),
          Text(
            heading,
            style: TextStyles.caption(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyles.caption(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
