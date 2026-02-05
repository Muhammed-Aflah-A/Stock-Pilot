import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/addproduct_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/dropdown_feild_widget.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';

class ProductAddingPage2 extends StatefulWidget {
  final ProductModel? product;
  final int? productIndex;

  const ProductAddingPage2({super.key, this.product, this.productIndex});

  @override
  State<ProductAddingPage2> createState() => _ProductAddingPage2State();
}

class _ProductAddingPage2State extends State<ProductAddingPage2> {
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    final provider = context.watch<ProductProvider>();
    final isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        showleading: true,
        title: isEditing ? "Edit Pricing & Inventory" : "Pricing & Inventory",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: currentHeight * 0.015,
                      horizontal: currentWidth * 0.04,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: provider.secondFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Product brand",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                DropdownFeildWidget(
                                  value: provider.brand,
                                  items: provider.brandsList,
                                  onChanged: (value) {
                                    provider.brand = value;
                                  },
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "product brand",
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.02),
                                Text(
                                  "Product category",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                DropdownFeildWidget(
                                  value: provider.category,
                                  items: provider.categoryList,
                                  onChanged: (value) {
                                    provider.category = value;
                                  },
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "Product category",
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.02),
                                Text(
                                  "Purchase Rate",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                FormWidget(
                                  initialValue: provider.purchaseRate,
                                  keyboard: TextInputType.number,
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "purchase rate",
                                      ),
                                  onSaved: (newValue) {
                                    provider.purchaseRate = newValue!.trim();
                                  },
                                  action: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(provider.salesRateFocus);
                                  },
                                ),
                                SizedBox(height: currentHeight * 0.02),
                                Text(
                                  "Sales Rate",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                FormWidget(
                                  initialValue: provider.salesRate,
                                  keyboard: TextInputType.number,
                                  focus: provider.salesRateFocus,
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "sales rate",
                                      ),
                                  onSaved: (newValue) {
                                    provider.salesRate = newValue!.trim();
                                  },
                                  action: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(provider.itemCountFocus);
                                  },
                                ),
                                SizedBox(height: currentHeight * 0.02),
                                Text(
                                  "Item count",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                FormWidget(
                                  initialValue: provider.itemCount,
                                  keyboard: TextInputType.number,
                                  focus: provider.itemCountFocus,
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "item count",
                                      ),
                                  onSaved: (newValue) {
                                    provider.itemCount = newValue!.trim();
                                  },
                                  action: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(provider.lowStockCountFocus);
                                  },
                                ),
                                SizedBox(height: currentHeight * 0.02),
                                Text(
                                  "Low stock count",
                                  style: TextStyles.sectionHeading(context)
                                      .copyWith(
                                        color: ColourStyles.primaryColor_2,
                                      ),
                                ),
                                SizedBox(height: currentHeight * 0.01),
                                FormWidget(
                                  initialValue: provider.lowStockCount,
                                  keyboard: TextInputType.number,
                                  focus: provider.lowStockCountFocus,
                                  validator: (value) =>
                                      SelectValidatorUtil.validate(
                                        value,
                                        "low stock count",
                                      ),
                                  onSaved: (newValue) {
                                    provider.lowStockCount = newValue!.trim();
                                  },
                                  action: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(height: currentHeight * 0.04),
                          Center(
                            child: AddproductButtonWidget(
                              product: widget.product,
                              productIndex: widget.productIndex,
                            ),
                          ),
                          SizedBox(height: currentHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
