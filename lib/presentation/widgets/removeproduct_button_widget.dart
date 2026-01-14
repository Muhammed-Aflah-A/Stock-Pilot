import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/widgets/delete_conformation_widget.dart';

class RemoveproductButtonWidget extends StatelessWidget {
  final ProductModel product;
  final int productIndex;
  const RemoveproductButtonWidget({
    super.key,
    required this.product,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => DeleteConformationWidget(
            productName: product.productName,
            productIndex: productIndex,
          ),
        );
      },
      style: ButtonStyles.removeButton,
      child: Text('Remove Product', style: TextStyles.primaryTextWhite),
    );
  }
}
