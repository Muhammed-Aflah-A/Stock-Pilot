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
    final size = MediaQuery.of(context).size;
    final horizontalPadding = (size.width * 0.05).clamp(16.0, 40.0);
    final verticalPadding = (size.height * 0.02).clamp(12.0, 24.0);
    final spacing = (size.height * 0.02).clamp(14.0, 24.0);
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
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Form(
                  key: provider.secondFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product brand",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                      const SizedBox(height: 8),
                      DropdownFeildWidget(
                        value: provider.brand,
                        items: provider.brandsList,
                        onChanged: (value) {
                          provider.brand = value;
                        },
                        validator: (value) => SelectValidatorUtil.validate(
                          value,
                          "product brand",
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        "Product category",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                      const SizedBox(height: 8),
                      DropdownFeildWidget(
                        value: provider.category,
                        items: provider.categoryList,
                        onChanged: (value) {
                          provider.category = value;
                        },
                        validator: (value) => SelectValidatorUtil.validate(
                          value,
                          "product category",
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        "Purchase Rate",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.purchaseRate,
                        keyboard: TextInputType.number,
                        validator: (value) => SelectValidatorUtil.validate(
                          value,
                          "purchase rate",
                        ),
                        onSaved: (newValue) {
                          provider.purchaseRate = newValue!.trim();
                        },
                        action: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.salesRateFocus);
                        },
                      ),
                      SizedBox(height: spacing),
                      Text(
                        "Sales Rate",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.salesRate,
                        keyboard: TextInputType.number,
                        focus: provider.salesRateFocus,
                        validator: (value) =>
                            SelectValidatorUtil.validate(value, "sales rate"),
                        onSaved: (newValue) {
                          provider.salesRate = newValue!.trim();
                        },
                        action: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.itemCountFocus);
                        },
                      ),
                      SizedBox(height: spacing),
                      Text(
                        "Item count",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.itemCount,
                        keyboard: TextInputType.number,
                        focus: provider.itemCountFocus,
                        validator: (value) =>
                            SelectValidatorUtil.validate(value, "item count"),
                        onSaved: (newValue) {
                          provider.itemCount = newValue!.trim();
                        },
                        action: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.lowStockCountFocus);
                        },
                      ),
                      SizedBox(height: spacing),
                      Text(
                        "Low stock count",
                        style: TextStyles.sectionHeading(
                          context,
                        ).copyWith(color: ColourStyles.primaryColor_2),
                      ),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.lowStockCount,
                        keyboard: TextInputType.number,
                        focus: provider.lowStockCountFocus,
                        validator: (value) => SelectValidatorUtil.validate(
                          value,
                          "low stock count",
                        ),
                        onSaved: (newValue) {
                          provider.lowStockCount = newValue!.trim();
                        },
                        action: TextInputAction.done,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                      ),
                      SizedBox(height: spacing * 2),
                      Center(
                        child: AddproductButtonWidget(
                          product: widget.product,
                          productIndex: widget.productIndex,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
