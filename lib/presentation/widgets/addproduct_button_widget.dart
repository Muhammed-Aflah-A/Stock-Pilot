import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

class AddproductButtonWidget extends StatelessWidget {
  final ProductModel? product;
  final int? productIndex;

  const AddproductButtonWidget({super.key, this.product, this.productIndex});

  @override
  Widget build(BuildContext context) {
    final productForm = context.watch<ProductProvider>();
    final isEditing = product != null;

    return ElevatedButton(
      onPressed: () async {
        if (productForm.secondFormKey.currentState!.validate()) {
          productForm.secondFormKey.currentState!.save();

          final newProduct = ProductModel(
            productImages: productForm.productImages
                .where((img) => img != null)
                .map((img) => img!.path)
                .toList(),
            productName: productForm.productName!,
            productDescription: productForm.productDescription!,
            brand: productForm.brand!,
            category: productForm.category!,
            purchaseRate: productForm.purchaseRate!,
            salesRate: productForm.salesRate!,
            itemCount: productForm.itemCount!,
            lowStockCount: productForm.lowStockCount!,
          );

          if (isEditing && productIndex != null) {
            await productForm.updateProduct(productIndex!, newProduct);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text("Product updated successfully")),
                  backgroundColor: ColourStyles.colorGreen,
                ),
              );
            }
          } else {
            await productForm.addproduct(newProduct);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text("Product added successfully")),
                  backgroundColor: ColourStyles.colorGreen,
                ),
              );
            }
          }
          productForm.firstFormKey.currentState?.reset();
          productForm.secondFormKey.currentState?.reset();
          productForm.resetForm();
          await productForm.loadProducts();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.productListPage,
              (route) => false,
            );
          }
        }
      },
      style: ButtonStyles.nextButton(context),
      child: Text(
        isEditing ? "Update Product" : "Add Product",
        style: TextStyles.buttonTextWhite(context),
      ),
    );
  }
}
