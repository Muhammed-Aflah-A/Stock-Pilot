import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

// A dialog shown when a permission (camera or gallery) is permanently denied by the user.
class DeniedDialogWidget extends StatelessWidget {
  final bool isCamera;

  const DeniedDialogWidget({super.key, required this.isCamera});

  @override
  Widget build(BuildContext context) {
    // Alert dialog UI that appears when permission is permanently denied
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Dialog title
      title: Text(
        "Permission Required",
        style: TextStyles.dialogueHeading(context),
        textAlign: TextAlign.center,
      ),
      // Dialog content explaining the issue and showing action buttons
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Informational message explaining that permission must be enabled manually from the system settings
          Text(
            "Permission is permanently denied. Please enable it from app settings.",
            style: TextStyles.primaryText(
              context,
            ).copyWith(color: ColourStyles.colorRed),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          // Cancel button
          /// Closes the dialog and shows a snackbar indicating
          /// that the permission action was cancelled.
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarUtil.showSnackBar(
                context,
                "${isCamera ? "Camera" : "Library"} permission is disabled in settings",
                true,
              );
            },
            style: ButtonStyles.dialogBackButton(context),
            // Button label
            child: Text("Cancel", style: TextStyles.buttonTextBlack(context)),
          ),
          SizedBox(height: 10),
          // Open Settings button
          /// Closes the dialog and opens the device app settings
          /// so the user can manually enable the required permission.
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            style: ButtonStyles.dialogNextButton(context),
            // Button label
            child: Text(
              "Open Settings",
              style: TextStyles.buttonTextWhite(context),
            ),
          ),
        ],
      ),
    );
  }
}
