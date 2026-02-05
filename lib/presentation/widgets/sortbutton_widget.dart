import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class SortbuttonWidget extends StatelessWidget {
  const SortbuttonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColourStyles.primaryColor_2, width: 2),
          ),
          child: Icon(Icons.sort, size: 22, color: ColourStyles.primaryColor_2),
        ),
      ),
    );
  }
}
