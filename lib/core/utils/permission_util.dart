import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/utils/image_permission_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/widgets/deneid_dialog_widget.dart';

// Utility class responsible for handling image-related permissions
class PermissionUtil {
  // Handles permission flow for camera or gallery access.
  static Future<void> handleImagePermission({
    required BuildContext context,
    required dynamic provider,
    required bool isCamera,
    int? index,
  }) async {
    // Request permission based on the type (camera or library)
    final status = isCamera
        ? await ImagePermissionUtil.cameraPermission()
        : await ImagePermissionUtil.libraryPermission();
    if (!context.mounted) return;
    // Open camera or gallery depending on the request
    if (status == PermissionStatus.granted) {
      // If index is provided, passing the index to the provider method
      if (index != null) {
        isCamera
            ? await provider.openCamera(index)
            : await provider.openLibrary(index);
      } else {
        isCamera ? await provider.openCamera() : await provider.openLibrary();
      }
      // Close the bottom sheet or dialog that triggered permission
      if (context.mounted) Navigator.pop(context);
    }
    // If permission is permanently denied
    else if (status == PermissionStatus.permanentlyDenied) {
      // Close the previous dialog/sheet
      if (context.mounted) Navigator.pop(context);
      // Show a dialog prompting the user to enable permission in setting
      showDialog(
        context: context,
        builder: (context) => DeniedDialogWidget(isCamera: isCamera),
      );
    }
    // If permission is denied temporarily
    else {
      // Close the permission request UI
      if (context.mounted) Navigator.pop(context);
      // Show a snackbar informing the user that permission was denied
      SnackbarUtil.showSnackBar(
        context,
        "${isCamera ? "Camera" : "Library"} permission denied",
        true,
      );
    }
  }
}
