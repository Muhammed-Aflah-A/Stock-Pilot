import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/widgets/action_confirmation_widget.dart';

// Reusable button used to remove a product.
class RemoveProductButtonWidget extends StatelessWidget {
  final String label;
  final String dialogTitle;
  final String itemName;
  final Future<bool> Function() onDeleteAction;

  const RemoveProductButtonWidget({
    super.key,
    required this.label,
    required this.dialogTitle,
    required this.itemName,
    required this.onDeleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool wasDeleted = false;
        await showDialog(
          context: context,
          // Dialog widget asking user to confirm deletion
          builder: (dialogContext) => ActionConfirmationWidget(
            title: dialogTitle,
            displayName: itemName,
            actionText: "Delete",
            actionColor: ColourStyles.colorRed,
            showSnackbar: false, // Page handles the pop message manually
            onConfirm: () async {
               wasDeleted = await onDeleteAction();
               return true; // Tells the dialog to pop itself
            },
          ),
        );
        // After dialog is popped, if deletion was successful, show snackbar and pop the details page
        if (wasDeleted && context.mounted) {
          SnackbarUtil.showSnackBar(context, '$itemName deleted successfully', false);
          Navigator.pop(context, "Product deleted successfully");
        }
      },
      style: ButtonStyles.detailPageRemoveButton(context),
      // Button label
      child: Text(
        label,
        style: TextStyles.primaryTextWhite(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
