import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';

class NoproductMessageWidget extends StatelessWidget {
  const NoproductMessageWidget({super.key});

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
            color: ColourStyles.colorgrey,
          ),
          SizedBox(height: currentHeigth * 0.016),
          Text('No products yet', style: TextStyles.caption_4),
          SizedBox(height: currentHeigth * 0.01),
          Text(
            'Add your first product to get started',
            style: TextStyles.caption_4,
          ),
        ],
      ),
    );
  }
}
