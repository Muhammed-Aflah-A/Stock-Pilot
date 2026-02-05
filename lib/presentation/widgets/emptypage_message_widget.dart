import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class EmptypageMessageWidget extends StatelessWidget {
  final String heading;
  final String label;
  const EmptypageMessageWidget({
    super.key,
    required this.heading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final currentHeigth = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: ColourStyles.colorGrey,
          ),
          SizedBox(height: currentHeigth * 0.016),
          Text(heading, style: TextStyles.caption(context)),
          SizedBox(height: currentHeigth * 0.01),
          Text(
            label,
            style: TextStyles.caption(context),
          ),
        ],
      ),
    );
  }
}
