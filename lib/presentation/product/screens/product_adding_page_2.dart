import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/addProduct_button_widget.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/dropdown_feild_widget.dart';
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
    final currentHeigth = MediaQuery.of(context).size.height;
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: currentHeigth * 0.01,
            horizontal: currentWidth * 0.03,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: provider.secondFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product brand", style: TextStyles.sectionHeading),
                      SizedBox(height: currentHeigth * 0.01),
                      DropdownFeildWidget(
                        value: provider.brand,
                        items: provider.brandsList,
                        onChanged: (value) {
                          provider.brand = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a brand';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: currentHeigth * 0.01),
                      Text(
                        "Product category",
                        style: TextStyles.sectionHeading,
                      ),
                      SizedBox(height: currentHeigth * 0.01),
                      DropdownFeildWidget(
                        value: provider.category,
                        items: provider.categoryList,
                        onChanged: (value) {
                          provider.category = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: currentHeigth * 0.01),
                      Text("Purchase Rate", style: TextStyles.sectionHeading),
                      SizedBox(height: currentHeigth * 0.01),
                      FormWidget(
                        initialValue: provider.purchaseRate,
                        keyboard: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the purchase rate';
                          }
                          if (RegExp(r'\s').hasMatch(value)) {
                            return "Purchase rate must not contain spaces";
                          }
                          if (value.startsWith('-')) {
                            return "Purchase rate must not be negative";
                          }
                          if (RegExp(r'[A-Za-z]').hasMatch(value)) {
                            return "Purchase rate must not contain letters";
                          }
                          if (RegExp(r'[^0-9.]').hasMatch(value)) {
                            return "Purchase rate must not contain special characters";
                          }
                          if (RegExp(r'\.\d{3,}$').hasMatch(value)) {
                            return "Purchase rate must not contain more than 2 decimals";
                          }
                          if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                            return "Invalid purchase rate format";
                          }
                          return null;
                        },
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
                      SizedBox(height: currentHeigth * 0.01),
                      Text("Sales Rate", style: TextStyles.sectionHeading),
                      SizedBox(height: currentHeigth * 0.01),
                      FormWidget(
                        initialValue: provider.salesRate,
                        keyboard: TextInputType.number,
                        focus: provider.salesRateFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Sales rate';
                          }
                          if (RegExp(r'\s').hasMatch(value)) {
                            return "Sales rate must not contain spaces";
                          }
                          if (value.startsWith('-')) {
                            return "Sales rate must not be negative";
                          }
                          if (RegExp(r'[A-Za-z]').hasMatch(value)) {
                            return "Sales rate must not contain letters";
                          }
                          if (RegExp(r'[^0-9.]').hasMatch(value)) {
                            return "Sales rate must not contain special characters";
                          }
                          if (RegExp(r'\.\d{3,}$').hasMatch(value)) {
                            return "sales rate must not contain more than 2 decimals";
                          }
                          if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                            return "Invalid Sales rate format";
                          }
                          return null;
                        },
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
                      SizedBox(height: currentHeigth * 0.01),
                      Text("Item count", style: TextStyles.sectionHeading),
                      SizedBox(height: currentHeigth * 0.01),
                      FormWidget(
                        initialValue: provider.itemCount,
                        keyboard: TextInputType.number,
                        focus: provider.itemCountFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the item count';
                          }
                          if (RegExp(r'\s').hasMatch(value)) {
                            return "Item count must not contain spaces";
                          }
                          if (value.startsWith('-')) {
                            return "Item count must not be negative";
                          }
                          if (RegExp(r'[A-Za-z]').hasMatch(value)) {
                            return "Item count must not contain letters";
                          }
                          if (RegExp(r'[^0-9]').hasMatch(value)) {
                            return "Item count must not contain special characters or decimals";
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return "Item count must be a whole number";
                          }
                          return null;
                        },
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
                      SizedBox(height: currentHeigth * 0.01),
                      Text("Low stock count", style: TextStyles.sectionHeading),
                      SizedBox(height: currentHeigth * 0.01),
                      FormWidget(
                        initialValue: provider.lowStockCount,
                        keyboard: TextInputType.number,
                        focus: provider.lowStockCountFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Low stock count';
                          }
                          if (RegExp(r'\s').hasMatch(value)) {
                            return "Low stock count must not contain spaces";
                          }
                          if (value.startsWith('-')) {
                            return "Low stock count must not be negative";
                          }
                          if (RegExp(r'[A-Za-z]').hasMatch(value)) {
                            return "Low stock count must not contain letters";
                          }
                          if (RegExp(r'[^0-9]').hasMatch(value)) {
                            return "Low stock count must not contain special characters or decimals";
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return "Low stock count must be a whole number";
                          }
                          return null;
                        },
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
                SizedBox(height: currentHeigth * 0.05),
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
    );
  }
}
