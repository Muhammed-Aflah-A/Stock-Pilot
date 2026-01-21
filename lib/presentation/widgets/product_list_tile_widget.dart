import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class ProductListTileWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductListTileWidget({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProductProvider>();

    return Card(
      color: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColourStyles.colorgrey!),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: ColourStyles.primaryColor_2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    product.productImages.isNotEmpty &&
                        product.productImages.first.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(product.productImages.first),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.inventory_2_outlined,
                              color: ColourStyles.colorgrey,
                              size: 30,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: ColourStyles.colorgrey,
                        size: 30,
                      ),
              ),
              SizedBox(width: currentWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyles.titleText(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: currentHeight * 0.001),
                    Text(
                      product.brand,
                      style: TextStyles.activityCardText(context),
                    ),
                    SizedBox(height: currentHeight * 0.001),
                    Text(
                      product.category,
                      style: TextStyles.activityCardLabel(context),
                    ),
                    SizedBox(height: currentHeight * 0.005),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: provider.getStockColor(product),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: currentWidth * 0.02),
                        Text(
                          provider.getStockText(product),
                          style: TextStyles.activityCardLabel(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text('\$ ${product.salesRate}', style: TextStyles.heading_4),
            ],
          ),
        ),
      ),
    );
  }
}
