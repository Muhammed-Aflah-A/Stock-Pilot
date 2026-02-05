import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/presentation/widgets/delete_confirmation_widget.dart';

class RemoveproductButtonWidget extends StatelessWidget {
  final String label;
  final String dialogTitle;
  final String itemName;
  final Future<void> Function() onDeleteAction;
  const RemoveproductButtonWidget({
    super.key,
    required this.label,
    required this.dialogTitle,
    required this.itemName,
    required this.onDeleteAction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => DeleteConfirmationWidget(
            title: dialogTitle,
            displayName: itemName,
            onDelete: onDeleteAction,
          ),
        );
      },
      style: ButtonStyles.detailPageRemoveButton(context),
      child: Text(
        'Remove Product',
        style: TextStyles.primaryTextWhite,
        textAlign: TextAlign.center,
      ),
    );
  }
}
