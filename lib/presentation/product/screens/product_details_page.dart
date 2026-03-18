import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/add_cart_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/edit_product_button_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_image_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_detail_row_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/remove_product_button_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productIndex;

  const ProductDetailsPage({super.key, required this.productIndex});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // Controls whether description section is expanded
  final ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(true);

  @override
  void dispose() {
    _isDescriptionExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(16.0, 28.0);
    final spacing = (size.height * 0.025).clamp(16.0, 28.0);
    final provider = context.watch<ProductProvider>();
    // Safety check for invalid index
    if (widget.productIndex < 0 ||
        widget.productIndex >= provider.products.length) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }
    // Current product
    final product = provider.products[widget.productIndex];
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      // APP BAR
      appBar: const AppBarWidget(
        showLeading: true,
        title: "Product Details",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                children: [
                  // PRODUCT IMAGE CAROUSEL
                  ProductImageWidget(
                    images: product.productImages,
                    height: (size.height * 0.35).clamp(220.0, 400.0),
                  ),
                  SizedBox(height: spacing),
                  // PRODUCT INFO CARD
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(horizontalPadding),
                    decoration: BoxDecoration(
                      color: ColourStyles.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColourStyles.shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PRODUCT NAME
                        Text(
                          product.productName!,
                          style: TextStyles.dialogueHeading(context),
                        ),
                        const SizedBox(height: 6),
                        // CATEGORY
                        Text(
                          product.category!,
                          style: TextStyles.caption(context),
                        ),
                        SizedBox(height: spacing),
                        // BRAND
                        DetailRowWidget(
                          label: 'Brand',
                          value: product.brand!,
                          showDivider: true,
                        ),
                        // PRICE
                        DetailRowWidget(
                          label: 'Price',
                          value: '\$${product.salesRate}',
                          showDivider: true,
                        ),
                        // STOCK STATUS
                        DetailRowWidget(
                          label: 'Stock Quantity',
                          value: provider.getStockText(product),
                          showDivider: false,
                          valueColor: provider.getStockColor(product),
                          showDot: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),
                  // DESCRIPTION CARD
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(horizontalPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColourStyles.shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isDescriptionExpanded,
                      builder: (context, expanded, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // DESCRIPTION HEADER (TOGGLE)
                            InkWell(
                              onTap: () {
                                _isDescriptionExpanded.value = !expanded;
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyles.cardHeading(context),
                                  ),
                                  Icon(
                                    expanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 35,
                                  ),
                                ],
                              ),
                            ),
                            // DESCRIPTION TEXT
                            if (expanded) ...[
                              const SizedBox(height: 14),
                              Text(
                                product.productDescription!,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: ColourStyles.colorGrey,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: spacing),
                  // EDIT + REMOVE BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: EditProductButtonWidget(
                          product: product,
                          productIndex: widget.productIndex,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RemoveProductButtonWidget(
                          label: 'Remove Product',
                          dialogTitle: 'Delete Product',
                          itemName: product.productName!,
                          onDeleteAction: () async {
                            final dashProvider = context
                                .read<DashboardProvider>();
                            await provider.deleteProduct(
                              widget.productIndex,
                              dashProvider,
                            );
                            if (context.mounted) {
                              Navigator.pop(
                                context,
                                "Product deleted successfully",
                              );
                            }
                            return true;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  // ADD TO CART BUTTON
                  AddCartButtonWidget(),
                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
