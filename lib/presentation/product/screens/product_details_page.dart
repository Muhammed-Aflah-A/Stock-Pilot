import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/number_formatter_util.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/add_cart_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/edit_product_button_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_image_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_detail_row_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/remove_product_button_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
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
    final productIndex = provider.activeProductIndex;

    if (productIndex == null ||
        productIndex < 0 ||
        productIndex >= provider.products.length) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }
    final product = provider.products[productIndex];
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
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
                  ProductImageWidget(
                    images: product.productImages,
                    height: (size.height * 0.35).clamp(220.0, 400.0),
                  ),
                  SizedBox(height: spacing),
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
                        Text(
                          product.productName!,
                          style: TextStyles.dialogueHeading(context),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.category!,
                          style: TextStyles.caption(context),
                        ),
                        SizedBox(height: spacing),
                        DetailRowWidget(
                          label: 'Brand',
                          value: product.brand!,
                          showDivider: true,
                        ),
                        DetailRowWidget(
                          label: 'Price',
                          value: NumberFormatterUtil.formatCurrency(
                            double.tryParse(product.salesRate ?? '0') ?? 0,
                          ),
                          showDivider: true,
                        ),
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
                  Row(
                    children: [
                      Expanded(
                        child: EditProductButtonWidget(
                          product: product,
                          productIndex: productIndex,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RemoveProductButtonWidget(
                          label: 'Delete Product',
                          dialogTitle: 'Delete Product',
                          itemName: product.productName!,
                          onDeleteAction: () async {
                            final dashProvider = context
                                .read<DashboardProvider>();
                            await provider.deleteProduct(
                              productIndex,
                              dashProvider,
                            );
                            return true;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  AddCartButtonWidget(product: product),
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

