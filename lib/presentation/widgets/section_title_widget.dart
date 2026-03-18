import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

// A reusable widget used to display section titles
class SectionTitleWidget extends StatelessWidget {
  final String title;

  const SectionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return
    // section heading
    Text(
      title,
      style: TextStyles.sectionHeading(
        context,
      ).copyWith(color: ColourStyles.primaryColor_2),
    );
  }
}
