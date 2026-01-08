import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/dropdown_feild_widget.dart';

class ProductAddingPage2 extends StatefulWidget {
  const ProductAddingPage2({super.key});

  @override
  State<ProductAddingPage2> createState() => _ProductAddingPage2State();
}

class _ProductAddingPage2State extends State<ProductAddingPage2> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        showleading: true,
        title: "Pricing and Iventory",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      SizedBox(height: h * 0.01),
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
