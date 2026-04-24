import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/image_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
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
    final provider = context.watch<ProductProvider>();
    final stockColor = provider.getStockColor(product);
    final stockText = provider.getStockText(product);
    return Card(
      color: ColourStyles.primaryColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                  width: 70,
                  height: 70,
                  color: ColourStyles.primaryColor_2,
                  child: product.productImages.isNotEmpty
                      ? Image(
                          image: ImageUtil.getProductImage(
                            product.productImages.first,
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.inventory_2_rounded),
                        )
                      : const Icon(Icons.inventory_2_rounded),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? "",
                      style: TextStyles.titleText(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.category ?? "",
                      style: TextStyles.activityCardLabel(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.brand ?? "",
                      style: TextStyles.activityCardText(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                        Text(
                          stockText,
                          style: TextStyles.activityCardLabel(
                            context,
                          ).copyWith(color: stockColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                NumberFormatterUtil.formatCurrency(
                  double.tryParse(product.salesRate ?? '0') ?? 0,
                ),
                style: TextStyles.productPriceText(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
