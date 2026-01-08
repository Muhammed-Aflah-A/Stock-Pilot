import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/form_widget.dart';
import 'package:stock_pilot/presentation/widgets/image_adding_widget.dart';
import 'package:stock_pilot/presentation/widgets/nextbutton_widget.dart';

class ProductAddingPage1 extends StatefulWidget {
  const ProductAddingPage1({super.key});

  @override
  State<ProductAddingPage1> createState() => _ProductAddingState();
}

class _ProductAddingState extends State<ProductAddingPage1> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        showleading: true,
        title: "Basic Info",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Image", style: TextStyles.sectionHeading),
                SizedBox(height: h * 0.01),
                ImageAddingWidget(),
                SizedBox(height: h * 0.01),
                if (!provider.hasImage)
                  Center(
                    child: Text(
                      "Please add at least one product image",
                      style: TextStyle(color: ColourStyles.colorRed),
                    ),
                  ),
                SizedBox(height: h * 0.01),
                Form(
                  key: provider.firstFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Name", style: TextStyles.sectionHeading),
                      SizedBox(height: h * 0.01),
                      FormWidget(
                        maxlength: 25,
                        keyboard: TextInputType.name,
                        validator: (value) {
                          value = value?.trim();
                          if (value == null || value.isEmpty) {
                            return "Please enter the name of product";
                          }
                          if (RegExp(r'\s{2,}').hasMatch(value)) {
                            return "product name cannot contain multiple spaces together";
                          }
                          if (!RegExp(r'^[A-Za-z ]{3,25}$').hasMatch(value)) {
                            return "Name must be 3–25 letters only";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          provider.productName = newValue!.trim();
                        },
                        action: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(
                            context,
                          ).requestFocus(provider.productDescriptionFocus);
                        },
                      ),
                      Text(
                        "Product Description",
                        style: TextStyles.sectionHeading,
                      ),
                      SizedBox(height: h * 0.01),
                      FormWidget(
                        maxlength: 500,
                        maxline: 6,
                        focus: provider.productDescriptionFocus,
                        keyboard: TextInputType.multiline,
                        validator: (value) {
                          value = value?.trim();
                          if (value == null || value.isEmpty) {
                            return "Please enter product details";
                          }
                          if (!RegExp(r'^.{10,500}$').hasMatch(value)) {
                            return "Description must be 10–500 characters";
                          }
                          if (RegExp(r'\s{2,}').hasMatch(value)) {
                            return "description cannot contain multiple spaces together";
                          }
                          value = value.replaceAll("  ", " ");
                          return null;
                        },
                        onSaved: (newValue) {
                          provider.productDescription = newValue!.trim();
                        },
                        action: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.02),
                Center(
                  child: Column(
                    children: [
                      NextbuttonWidget(
                        onPressed: () {
                          final formValid = provider.firstFormKey.currentState!
                              .validate();
                          if (!provider.hasImage || !formValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    "Please add image and complete the form",
                                  ),
                                ),
                                backgroundColor: ColourStyles.colorRed,
                              ),
                            );
                          }
                          if (formValid) {
                            provider.firstFormKey.currentState!.save();
                            Navigator.pushNamed(
                              context,
                              AppRoutes.productAddingPage2,
                            );
                          }
                        },
                        text: "Next",
                      ),
                    ],
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
