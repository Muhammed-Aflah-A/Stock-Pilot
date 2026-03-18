import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/delete_confirmation_widget.dart';

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
        await showDialog(
          context: context,
          // Dialog widget asking user to confirm deletion
          builder: (dialogContext) => DeleteConfirmationWidget(
            title: dialogTitle,
            displayName: itemName,
            onDelete: onDeleteAction,
          ),
        );
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
