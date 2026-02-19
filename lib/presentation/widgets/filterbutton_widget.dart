import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class FilterbuttonWidget extends StatelessWidget {
  const FilterbuttonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColourStyles.primaryColor_2,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.filter_alt_outlined,
              size: 22,
              color: ColourStyles.primaryColor_2,
            ),
          ),
        ),
      ),
    );
  }
}
