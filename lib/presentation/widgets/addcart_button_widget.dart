import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';

class AddcartButtonWidget extends StatelessWidget {
  final ProductModel product;
  final int productIndex;
  const AddcartButtonWidget({
    super.key,
    required this.product,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('${product.productName} Added to cart'),
            ),
            backgroundColor: ColourStyles.colorGreen,
          ),
        );
      },
      style: ButtonStyles.detailPageButton_2,
      child: Text('Add to Cart', style: TextStyles.primaryTextWhite),
    );
  }
}
