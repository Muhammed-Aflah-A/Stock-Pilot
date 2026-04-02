import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/revenue/viewmodel/revenue_provider.dart';

class MostSoldItemsWidget extends StatelessWidget {
  const MostSoldItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueProvider>(
      builder: (context, provider, child) {
        final items = provider.mostSoldItems;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColourStyles.primaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColourStyles.borderColor,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Top Selling Products",
                style: TextStyles.sectionTitle(context).copyWith(
                  fontSize: 16,
                  color: ColourStyles.primaryColor_2,
                ),
              ),
              const SizedBox(height: 20),
              if (items.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("No sales recorded yet"),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 30,
                    color: ColourStyles.borderColor,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item.key;
                    final quantity = item.value;

                    return Row(
                      children: [
                        // Product Image
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColourStyles.primaryColor_3,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product.productImages.isNotEmpty
                                ? Image.file(
                                    File(product.productImages[0]),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image, size: 24),
                                  )
                                : const Icon(Icons.inventory_2, size: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Product Name & Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName ?? "Unknown Product",
                                style: TextStyles.titleText(context).copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${product.category ?? 'Uncategorized'} • ${product.brand ?? 'Generic'}",
                                style: TextStyles.caption2(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Quantity Sold
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "$quantity",
                              style: TextStyles.valueText(context).copyWith(
                                fontSize: 20,
                                color: ColourStyles.primaryColor_2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "sold",
                              style: TextStyle(
                                fontSize: 10,
                                color: ColourStyles.captionColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
