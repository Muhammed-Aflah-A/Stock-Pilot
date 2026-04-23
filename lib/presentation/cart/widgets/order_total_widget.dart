import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';

class OrderTotalWidget extends StatelessWidget {
  const OrderTotalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    if (provider.cartItems.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Total", style: TextStyles.cardHeading(context)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Items", style: TextStyles.titleText(context)),
            Text(
              provider.totalItems.toString(),
              style: TextStyles.productPriceText(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Price", style: TextStyles.titleText(context)),
            Text(
              NumberFormatterUtil.formatCurrency(provider.totalPrice),
              style: TextStyles.productPriceText(context),
            ),
          ],
        ),
      ],
    );
  }
}
