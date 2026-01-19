import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/theme/button_styles.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';
import 'package:stock_pilot/core/theme/text_styles.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';

class DeneidDialoqueWidget extends StatelessWidget {
  final bool isCamera;
  const DeneidDialoqueWidget({
    super.key,
    required this.isCamera,
  });
  double _scale(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth < 360) return size * 0.9;
    if (screenWidth < 600) return size * 1.0;
    if (screenWidth < 900) return size * 1.1;
    return size * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColourStyles.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_scale(context, 20)),
      ),
      title: Text(
        "Permission Required",
        style: TextStyles.dialogueHeading(context),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Permission is permanently denied. Please enable it from app settings.",
        style: TextStyles.primaryText(
          context,
        ).copyWith(color: ColourStyles.colorRed),
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  SnackbarUtil.showSnackBar(
                    context,
                    "${isCamera ? "Camera" : "Library"} permission denied",
                    true,
                  );
                },
                style: ButtonStyles.dialogBackButton(context),
                child: Text(
                  "Cancel",
                  style: TextStyles.buttonTextBlack(context),
                ),
              ),
              SizedBox(height: _scale(context, 10)),
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
              SizedBox(height: _scale(context, 10)),
            ],
          ),
        ),
      ],
    );
  }
}
