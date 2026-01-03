import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/app_bar_widget.dart';
import 'package:stock_pilot/presentation/widgets/image_adding_widget.dart';

class ProductAddingPage extends StatefulWidget {
  const ProductAddingPage({super.key});

  @override
  State<ProductAddingPage> createState() => _ProductAddingState();
}

class _ProductAddingState extends State<ProductAddingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourStyles.primaryColor,
      appBar: AppBarWidget(
        showleading: true,
        title: "Add Product",
        centeredTitle: true,
        showAvatar: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product image", style: TextStyles.heading_3),
              SizedBox(height: 10),
              ImageAddingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
