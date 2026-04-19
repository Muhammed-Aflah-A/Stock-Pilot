import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';
import 'package:stock_pilot/core/navigation/app_routes.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/dashboard/viewmodel/dashboard_provider.dart';
import 'package:stock_pilot/presentation/product/viewmodel/product_provider.dart';

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
          if (isEditing) {
            showDialog(
              context: context,
              builder: (dialogCtx) => ActionConfirmationWidget(
                title: "Update Product",
                actionText: "Update",
                displayName: "Product",
                actionColor: ColourStyles.colorGreen,
                showSnackbar: false,
                onConfirm: () async {
                  final success = await productForm.saveProductData(dashboardProvider);
                  if (!context.mounted) return false;
                  if (success) {
                    SnackbarUtil.showSnackBar(
                      context,
                      "Product updated successfully",
                      false,
                    );
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(AppRoutes.productDetailsPage),
                    );
                  }
                  return false;
                },
              ),
            );
          } else {
            final success = await productForm.saveProductData(dashboardProvider);
            if (!context.mounted) return;
            if (success) {
              SnackbarUtil.showSnackBar(
                context,
                "Product added successfully",
                false,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.productListPage,
                (route) => false,
              );
            }
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

