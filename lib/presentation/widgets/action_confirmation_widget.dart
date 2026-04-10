import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/dialog_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

class ActionConfirmationWidget extends StatelessWidget {
  final String title;
  final String actionText;
  final String displayName;
  final Color actionColor;
  final Future<bool> Function() onConfirm;
  final bool showSnackbar;

  const ActionConfirmationWidget({
    super.key,
    required this.title,
    required this.actionText,
    required this.displayName,
    required this.actionColor,
    required this.onConfirm,
    this.showSnackbar = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isRemove = actionText.toLowerCase() == "remove" || actionText.toLowerCase() == "delete";
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // TITLE
      titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
      title: Center(
        child: Text(
          title,
          style: TextStyles.dialogueHeading(context),
          textAlign: TextAlign.center,
        ),
      ),
      // CONTENT
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: SizedBox(
        width: DialogUtil.getDialogWidth(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to $actionText "$displayName"?',
              style: TextStyles.primaryText(
                context,
              ).copyWith(color: actionColor, fontSize: size.width * 0.035),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12), // Visual compensation forFormField height
          ],
        ),
      ),
      // ACTIONS
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            // CANCEL
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyles.smallDialogBackButton(context),
                child: Text('Cancel', style: TextStyles.primaryText(context)),
              ),
            ),
            SizedBox(width: DialogUtil.getDialogWidth(context) * 0.05),
            // CONFIRM
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final success = await onConfirm();
                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context);
                    if (showSnackbar) {
                      SnackbarUtil.showSnackBar(
                        context,
                        '$displayName $actionText successfully',
                        false,
                      );
                    }
                  }
                },
                style: isRemove
                    ? ButtonStyles.dialogueRemoveButton(context)
                    : ButtonStyles.dialogueAddButton(context),
                child: Text(
                  actionText,
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
}
