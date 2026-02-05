import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
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
        SnackbarUtil.showSnackBar(context, "Product added to cart", false);
      },
      style: ButtonStyles.detailPageButton_2,
      child: Text(
        'Add to Cart',
        style: TextStyles.primaryText(
          context,
        ).copyWith(color: ColourStyles.primaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
