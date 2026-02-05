import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/addcart_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/editproduct_button_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_image_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/product_detailrow_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/removeproduct_button_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final int productIndex;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.productIndex,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isDescriptionExpanded = true;

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProductProvider>();
    if (widget.productIndex < 0 ||
        widget.productIndex >= provider.products.length) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }
    final product = provider.products[widget.productIndex];
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBarWidget(
        showleading: true,
        title: "Product Details",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: currentWidth * 0.05,
            vertical: currentHeight * 0.02,
          ),
          child: Column(
            children: [
              ProductImageWidget(
                images: product.productImages,
                height: currentHeight * 0.35,
              ),
              SizedBox(height: currentHeight * 0.025),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(currentWidth * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName!,
                      style: TextStyles.dialogueHeading(context),
                    ),
                    SizedBox(height: currentHeight * 0.005),
                    Text(product.category!, style: TextStyles.caption(context)),
                    SizedBox(height: currentHeight * 0.025),
                    DetailRowWidget(
                      label: 'Brand',
                      value: product.brand!,
                      showDivider: true,
                    ),
                    DetailRowWidget(
                      label: 'Price',
                      value: '\$${product.salesRate}',
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
              SizedBox(height: currentHeight * 0.02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(currentWidth * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Description',
                            style: TextStyles.cardHeading(context),
                          ),
                          Icon(
                            _isDescriptionExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                    if (_isDescriptionExpanded) ...[
                      SizedBox(height: currentHeight * 0.015),
                      Text(
                        product.productDescription!,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColourStyles.colorGrey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: currentHeight * 0.03),
              Row(
                children: [
                  Expanded(
                    child: EditproductButtonWidget(
                      product: product,
                      productIndex: widget.productIndex,
                    ),
                  ),
                  SizedBox(width: currentWidth * 0.03),
                  Expanded(
                    child: RemoveproductButtonWidget(
                      label: 'Remove Product',
                      dialogTitle: 'Delete Product',
                      itemName: product.productName!,
                      onDeleteAction: () async {
                        final dashProvider = context.read<DashboardProvider>();
                        await provider.deleteProduct(
                          widget.productIndex,
                          dashProvider,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: currentHeight * 0.02),
              AddcartButtonWidget(
                product: product,
                productIndex: widget.productIndex,
              ),
              SizedBox(height: currentHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
