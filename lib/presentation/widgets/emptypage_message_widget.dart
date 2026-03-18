import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// A reusable widget used to display an empty state message
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
      // Centers the content in the screen
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          // Displays the empty state icon
          Icon(icon, size: 80, color: ColourStyles.colorGrey),
          const SizedBox(height: 16),
          // Heading text
          Text(
            heading,
            style: TextStyles.caption(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Description text
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
