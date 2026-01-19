import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/addcart_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/editproduct_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/producct_image_widget.dart';
import 'package:stock_pilot/presentation/widgets/product_detailrow_widget.dart';
import 'package:stock_pilot/presentation/widgets/removeproduct_button_widget.dart';

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
                images: widget.product.productImages,
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
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.productName,
                      style: TextStyles.dialogueHeading(context),
                    ),
                    SizedBox(height: currentHeight * 0.005),
                    Text(widget.product.category, style: TextStyles.caption_4),
                    SizedBox(height: currentHeight * 0.025),
                    DetailRowWidget(
                      label: 'Price',
                      value: '\$${widget.product.salesRate}',
                      showDivider: true,
                    ),
                    DetailRowWidget(
                      label: 'Stock Quantity',
                      value: provider.getStockText(widget.product),
                      showDivider: true,
                      valueColor: provider.getStockColor(widget.product),
                      showDot: true,
                    ),
                    DetailRowWidget(
                      label: 'Brand',
                      value: widget.product.brand,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: currentHeight * 0.02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(currentWidth * 0.05),
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyles.heading_4,
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
                        widget.product.productDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
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
                      product: widget.product,
                      productIndex: widget.productIndex,
                    ),
                  ),
                  SizedBox(width: currentWidth * 0.03),
                  Expanded(
                    child: RemoveproductButtonWidget(
                      product: widget.product,
                      productIndex: widget.productIndex,
                    ),
                  ),
                ],
              ),
              SizedBox(height: currentHeight * 0.02),
              AddcartButtonWidget(
                product: widget.product,
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
