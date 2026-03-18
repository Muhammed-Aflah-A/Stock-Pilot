import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

// Widget used when a product has no image
class ProductImagePlaceholder extends StatelessWidget {
  const ProductImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centers the placeholder icon inside the available space
      // Inventory product icon used as placeholder
      child: Icon(
        Icons.inventory_2_outlined,
        size: 80,
        // Grey color to indicate inactive/empty state
        color: ColourStyles.colorGrey,
      ),
    );
  }
}
