import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

// Button used to add a product to the cart
class AddCartButtonWidget extends StatelessWidget {
  const AddCartButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // When pressed, show success snackbar
      onPressed: () {
        SnackbarUtil.showSnackBar(context, "Product added to cart", false);
      },
      // Custom button style from theme
      style: ButtonStyles.detailPageButton_2,
      // Button text
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
