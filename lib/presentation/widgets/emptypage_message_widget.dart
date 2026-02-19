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
    final size = MediaQuery.of(context).size;
    final iconSize = (size.width * 0.2).clamp(60.0, 100.0);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: ColourStyles.colorGrey),
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
