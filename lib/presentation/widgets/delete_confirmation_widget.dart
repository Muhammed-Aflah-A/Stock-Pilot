import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

// Confirmation dialog shown before deleting an item
class DeleteConfirmationWidget extends StatelessWidget {
  final String title;
  final String displayName;
  final Future<bool> Function()
  onDelete;

  const DeleteConfirmationWidget({
    super.key,
    required this.title,
    required this.displayName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // TITLE
      titlePadding: EdgeInsets.only(top: size.height * 0.03),
      title: Text(
        title,
        style: TextStyles.dialogueHeading(context),
        textAlign: TextAlign.center,
      ),
      // CONTENT MESSAGE
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.02,
      ),
      content: Text(
        'Are you sure you want to remove "$displayName"? '
        'This action cannot be undone.',
        style: TextStyles.primaryText(
          context,
        ).copyWith(color: ColourStyles.colorRed, fontSize: size.width * 0.035),
        textAlign: TextAlign.center,
      ),
      // ACTION BUTTONS
      actionsPadding: EdgeInsets.only(bottom: size.height * 0.02),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CANCEL BUTTON
            SizedBox(
              width: size.width * 0.3,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyles.smallDialogBackButton(context),
                child: Text('Cancel', style: TextStyles.primaryText(context)),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            // REMOVE BUTTON
            SizedBox(
              width: size.width * 0.3,
              child: ElevatedButton(
                onPressed: () async {
                  await _handleDelete(context);
                },
                style: ButtonStyles.dialogueRemoveButton(context),
                child: Text(
                  'Remove',
                  style: TextStyles.primaryText(
                    context,
                  ).copyWith(color: ColourStyles.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Handles delete logic and success message
  Future<void> _handleDelete(BuildContext context) async {
    final success = await onDelete();
    if (!context.mounted) return;
    if (success) {
      Navigator.pop(context);
      SnackbarUtil.showSnackBar(
        context,
        '$displayName removed successfully',
        false,
      );
    }
  }
}
