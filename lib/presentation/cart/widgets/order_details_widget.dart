import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/cart/viewmodel/cart_provider.dart';
class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartProvider>();
    if (provider.cartItems.isEmpty) {
      return const SizedBox();
    }
    return Card(
      color: ColourStyles.primaryColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Details", style: TextStyles.cardHeading(context)),
            const SizedBox(height: 10),
            ...provider.cartItems.map((item) {
              final price = double.tryParse(item.product.salesRate ?? '0') ?? 0;
              final priceText = "\$${price.toStringAsFixed(2)}";
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColourStyles.primaryColor,
                    border: Border.all(
                      color: ColourStyles.borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 70,
                          height: 70,
                          color: ColourStyles.primaryColor_2,
                          child:
                              (item.product.productImages.isNotEmpty &&
                                  item.product.productImages.first.isNotEmpty)
                              ? Image.file(
                                  File(item.product.productImages.first),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.inventory_2_rounded),
                                )
                              : const Icon(Icons.inventory_2_rounded),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.productName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.titleText(context),
                            ),
                            Text(
                              item.product.category ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.activityCardLabel(context),
                            ),
                            Text(
                              item.product.brand ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.activityCardText(context),
                            ),
                            Text(
                              priceText,
                              style: TextStyles.activityCardText(context),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item.quantity.toString(),
                        style: TextStyles.productPriceText(context),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

