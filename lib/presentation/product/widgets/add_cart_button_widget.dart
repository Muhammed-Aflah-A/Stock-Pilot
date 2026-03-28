import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';

// Button used to add a product to the cart
class AddCartButtonWidget extends StatelessWidget {
  final ProductModel product;

  const AddCartButtonWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // When pressed, show success snackbar
      onPressed: () async {
        final cartProvider = context.read<CartProvider>();
        final success = await cartProvider.addItem(product);
        if (!context.mounted) return;
        if (!success) {
          SnackbarUtil.showSnackBar(context, "Product is out of stock", true);
          return;
        }
        SnackbarUtil.showSnackBar(context, "Product added to cart", false);
      },
      // Custom button style from theme
      style: ButtonStyles.detailPageButton_2(context),
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
