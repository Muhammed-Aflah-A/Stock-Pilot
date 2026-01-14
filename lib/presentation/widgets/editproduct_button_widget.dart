import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class EditproductButtonWidget extends StatelessWidget {
  final ProductModel product;
  final int productIndex;
  const EditproductButtonWidget({
    super.key,
    required this.product,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();
    return ElevatedButton(
      onPressed: () {
        provider.loadProductForEdit(product);
        Navigator.pushNamed(
          context,
          AppRoutes.productAddingPage1,
          arguments: {'product': product, 'productIndex': productIndex},
        );
      },
      style: ButtonStyles.detailPageButton,
      child: Text('Edit Product', style: TextStyles.primaryText),
    );
  }
}
