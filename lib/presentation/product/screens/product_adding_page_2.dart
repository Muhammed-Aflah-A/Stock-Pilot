import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/select_validator_util.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/product/widgets/add_product_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/product/widgets/dropdown_feild_widget.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';

// Second step: pricing and inventory
class ProductAddingPage2 extends StatelessWidget {
  const ProductAddingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final headingStyle = TextStyles.sectionHeading(
      context,
    ).copyWith(color: ColourStyles.primaryColor_2);
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: const AppBarWidget(
        showLeading: true,
        title: "Pricing & Inventory",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Form(
                  key: provider.secondFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// CATEGORY
                      Text("Product category", style: headingStyle),
                      const SizedBox(height: 8),
                      DropdownFieldWidget(
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
                      const SizedBox(height: 20),
                      // BRAND
                      Text("Product brand", style: headingStyle),
                      const SizedBox(height: 8),
                      DropdownFieldWidget(
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
                      const SizedBox(height: 20),
                      // PURCHASE RATE
                      Text("Purchase Rate", style: headingStyle),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.purchaseRate,
                        keyboard: TextInputType.number,
                        validator: (value) => SelectValidatorUtil.validate(
                          value,
                          "purchase rate",
                        ),
                        onSaved: (value) =>
                            provider.purchaseRate = value!.trim(),
                        action: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.salesRateFocus);
                        },
                      ),
                      const SizedBox(height: 20),
                      // SALES RATE
                      Text("Sales Rate", style: headingStyle),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.salesRate,
                        keyboard: TextInputType.number,
                        focus: provider.salesRateFocus,
                        validator: (value) =>
                            SelectValidatorUtil.validate(value, "sales rate"),
                        onSaved: (value) => provider.salesRate = value!.trim(),
                        action: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.itemCountFocus);
                        },
                      ),
                      const SizedBox(height: 20),
                      // ITEM COUNT
                      Text("Item count", style: headingStyle),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.itemCount,
                        keyboard: TextInputType.number,
                        focus: provider.itemCountFocus,
                        validator: (value) =>
                            SelectValidatorUtil.validate(value, "item count"),
                        onSaved: (value) => provider.itemCount = value!.trim(),
                        action: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.lowStockCountFocus);
                        },
                      ),
                      const SizedBox(height: 20),
                      // LOW STOCK COUNT
                      Text("Low stock count", style: headingStyle),
                      const SizedBox(height: 8),
                      FormWidget(
                        initialValue: provider.lowStockCount,
                        keyboard: TextInputType.number,
                        focus: provider.lowStockCountFocus,
                        validator: (value) => SelectValidatorUtil.validate(
                          value,
                          "low stock count",
                        ),
                        onSaved: (value) =>
                            provider.lowStockCount = value!.trim(),
                        action: TextInputAction.done,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                      ),
                      const SizedBox(height: 40),
                      // ADD PRODUCT BUTTON
                      const Center(child: AddProductButtonWidget()),
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
