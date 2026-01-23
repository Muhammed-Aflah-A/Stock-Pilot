import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class DeleteConformationWidget extends StatelessWidget {
  final String productName;
  final int productIndex;

  const DeleteConformationWidget({
    super.key,
    required this.productName,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Remove Product',
        style: TextStyles.dialogueHeading(context),
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Are you sure you want to remove "$productName"? This action cannot be undone.',
        style: TextStyles.primaryText(
          context,
        ).copyWith(color: ColourStyles.colorRed),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyles.smallDialogBackButton(context),
              child: Text('Cancel'),
            ),
            SizedBox(width: currentWidth * 0.02),
            ElevatedButton(
              onPressed: () async {
                final provider = context.read<ProductProvider>();
                await provider.deleteProduct(productIndex);
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text('$productName removed successfully'),
                    ),
                    backgroundColor: ColourStyles.colorRed,
                  ),
                );
              },
              style: ButtonStyles.removeButton_2,
              child: Text('Remove'),
            ),
          ],
        ),
      ],
    );
  }
}
