import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

class DeniedDialogWidget extends StatelessWidget {
  final bool isCamera;

  const DeniedDialogWidget({super.key, required this.isCamera});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Permission Required",
        style: TextStyles.dialogueHeading(context),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Permission is permanently denied. Please enable it from app settings.",
            style: TextStyles.primaryText(
              context,
            ).copyWith(color: ColourStyles.colorRed),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
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
            child: Text("Cancel", style: TextStyles.buttonTextBlack(context)),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            style: ButtonStyles.dialogNextButton(context),
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
