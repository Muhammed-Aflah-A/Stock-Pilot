import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class EditProductButtonWidget extends StatelessWidget {
  final ProductModel product;
  final int productIndex;

  const EditProductButtonWidget({
    super.key,
    required this.product,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();
    return ElevatedButton(
      onPressed: () {
        provider.setEditingProduct(product, productIndex);
        Navigator.pushNamed(context, AppRoutes.productAddingPage1);
      },
      style: ButtonStyles.detailPageEditButton(context),
      child: Text(
        'Edit Product',
        style: TextStyles.primaryText(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
