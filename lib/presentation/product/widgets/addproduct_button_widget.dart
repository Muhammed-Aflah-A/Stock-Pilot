import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
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
          final dashProvider = context.read<DashboardProvider>();
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
            await productForm.updateProduct(
              productIndex!,
              newProduct,
              dashProvider,
            );
            if (context.mounted) {
              SnackbarUtil.showSnackBar(
                context,
                "Product Updated successfully",
                false,
              );
            }
          } else {
            await productForm.addproduct(newProduct, dashProvider);
            if (context.mounted) {
              SnackbarUtil.showSnackBar(
                context,
                "Poduct added successfully",
                false,
              );
            }
          }
          productForm.firstFormKey.currentState?.reset();
          productForm.secondFormKey.currentState?.reset();
          productForm.resetForm();
          await productForm.loadProducts();
          if (context.mounted) {
            if (context.mounted) {
              if (isEditing) {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(AppRoutes.productDetailsPage),
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.productListPage,
                  (route) => false,
                );
              }
            }
          }
        }
      },
      style: ButtonStyles.nextButton(context),
      child: Text(
        isEditing ? "Update Product" : "Add Product",
        style: TextStyles.buttonTextWhite(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
