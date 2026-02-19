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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final imageWidth = (width * 0.22).clamp(70.0, 110.0);
    final imageHeight = (imageWidth * 0.75);
    final horizontalSpacing = (width * 0.04).clamp(12.0, 20.0);
    final smallSpacing = 1.0;

    return Selector<ProductProvider, ProductProvider>(
      selector: (_, provider) => provider,
      builder: (context, provider, _) {
        final stockColor = provider.getStockColor(product);
        final stockText = provider.getStockText(product);
        return Card(
          color: ColourStyles.primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: imageWidth,
                      height: imageHeight,
                      color: ColourStyles.primaryColor_2,
                      child:
                          product.productImages.isNotEmpty &&
                              product.productImages.first.isNotEmpty
                          ? Image.file(
                              File(product.productImages.first),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.inventory_2_rounded,
                                  color: ColourStyles.iconColor,
                                );
                              },
                            )
                          : const Icon(
                              Icons.inventory_2_rounded,
                              color: ColourStyles.iconColor,
                            ),
                    ),
                  ),
                  SizedBox(width: horizontalSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.productName ?? "",
                          style: TextStyles.titleText(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: smallSpacing),
                        Text(
                          product.brand ?? "",
                          style: TextStyles.activityCardText(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: smallSpacing),
                        Text(
                          product.category ?? "",
                          style: TextStyles.activityCardLabel(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: smallSpacing),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: stockColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                stockText,
                                style: TextStyles.activityCardLabel(
                                  context,
                                ).copyWith(color: stockColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '\$ ${product.salesRate}',
                      style: TextStyles.productPriceText(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
