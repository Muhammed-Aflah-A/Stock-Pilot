import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/cart_model.dart';

class PurchaseSummaryCardWidget extends StatelessWidget {
  final String? name;
  final String? phone;
  final String date;
  final List<CartItems> items;
  final double totalAmount;

  const PurchaseSummaryCardWidget({
    super.key,
    required this.name,
    required this.phone,
    required this.date,
    required this.items,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = items.fold(0, (sum, item) => sum + item.quantity);
    return Card(
      color: ColourStyles.primaryColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Customer Name"),
                Text(name ?? "-", style: TextStyles.primaryText(context)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Phone Number"),
                Text(phone ?? "-", style: TextStyles.primaryText(context)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date"),
                Text(date, style: TextStyles.primaryText(context)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Products", style: TextStyles.cardHeading(context)),
            ),
            const SizedBox(height: 8),
            Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.product.productName ?? ""),
                      Text(
                        "x${item.quantity}",
                        style: TextStyles.primaryText(context),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Items"),
                Text(
                  totalItems.toString(),
                  style: TextStyles.primaryText(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount"),
                Text(
                  "â‚¹ $totalAmount",
                  style: TextStyles.productPriceText(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

