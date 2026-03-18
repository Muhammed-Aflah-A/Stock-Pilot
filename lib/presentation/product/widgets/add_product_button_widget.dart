import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/data/models/product_model.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

// Button used for both adding and updating a product
class AddProductButtonWidget extends StatelessWidget {
  const AddProductButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productForm = context.read<ProductProvider>();
    final dashboardProvider = context.read<DashboardProvider>();
    final isEditing = productForm.isEditing;

    return ElevatedButton(
      onPressed: () async {
        final form = productForm.secondFormKey.currentState;
        if (form != null && form.validate()) {
          form.save();
          final newProduct = ProductModel(
            // Convert selected image files into image paths
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
          // UPDATE EXISTING PRODUCT
          if (isEditing) {
            await productForm.updateProduct(
              productForm.editingIndex!,
              newProduct,
              dashboardProvider,
            );
            // Show success message
            if (context.mounted) {
              SnackbarUtil.showSnackBar(
                context,
                "Product updated successfully",
                false,
              );
            }
          }
          // ADD NEW PRODUCT
          else {
            await productForm.addProduct(newProduct, dashboardProvider);
            // Show success message
            if (context.mounted) {
              SnackbarUtil.showSnackBar(
                context,
                "Product added successfully",
                false,
              );
            }
          }
          productForm.resetForm();
          productForm.clearEditing();
          if (!context.mounted) return;
          // If editing → go back to product details page
          if (isEditing) {
            Navigator.popUntil(
              context,
              ModalRoute.withName(AppRoutes.productDetailsPage),
            );
          }
          // If adding → go to product list page
          else {
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
