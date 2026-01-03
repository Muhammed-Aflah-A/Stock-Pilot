import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class SortbuttonWidget extends StatelessWidget {
  const SortbuttonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColourStyles.primaryColor_2, width: 2),
        ),
        child: Icon(Icons.sort, size: 20, color: ColourStyles.primaryColor_2),
      ),
    );
  }
}
