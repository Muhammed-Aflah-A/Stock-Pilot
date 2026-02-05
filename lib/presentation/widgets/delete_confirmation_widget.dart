import 'package:flutter/material.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

class DeleteConfirmationWidget extends StatelessWidget {
  final String title;
  final String displayName;
  final Future<void> Function() onDelete;

  const DeleteConfirmationWidget({
    super.key,
    required this.title,
    required this.displayName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.only(top: currentHeight * 0.03),
      title: Text(
        title,
        style: TextStyles.dialogueHeading(context),
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: currentWidth * 0.06,
        vertical: currentHeight * 0.02,
      ),
      content: Text(
        'Are you sure you want to remove "$displayName"? This action cannot be undone.',
        style: TextStyles.primaryText(context).copyWith(
          color: ColourStyles.colorRed,
          fontSize: currentWidth * 0.035,
        ),
        textAlign: TextAlign.center,
      ),
      actionsPadding: EdgeInsets.only(bottom: currentHeight * 0.02),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: currentWidth * 0.3,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyles.smallDialogBackButton(context),
                child: Text('Cancel', style: TextStyles.primaryText(context)),
              ),
            ),
            SizedBox(width: currentWidth * 0.03),
            SizedBox(
              width: currentWidth * 0.3,
              child: ElevatedButton(
                onPressed: () async {
                  await onDelete();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  SnackbarUtil.showSnackBar(
                    context,
                    '$displayName removed successfully',
                    false,
                  );
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
}
