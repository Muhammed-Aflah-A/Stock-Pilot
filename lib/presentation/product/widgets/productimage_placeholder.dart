import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ProductimagePlaceholder extends StatelessWidget {
  const ProductimagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: 80,
        color: ColourStyles.colorGrey,
      ),
    );
  }
}
