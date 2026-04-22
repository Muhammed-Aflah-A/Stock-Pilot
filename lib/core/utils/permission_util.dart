import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stock_pilot/core/utils/image_permission_util.dart';
import 'package:stock_pilot/core/utils/snackbar_util.dart';
import 'package:stock_pilot/presentation/widgets/deneid_dialog_widget.dart';

class PermissionUtil {
  static Future<void> handleImagePermission({
    required BuildContext context,
    required dynamic provider,
    required bool isCamera,
    int? index,
  }) async {
    if (kIsWeb) {
      if (index != null) {
        isCamera
            ? await provider.openCamera(context, index)
            : await provider.openLibrary(context, index);
      } else {
        isCamera
            ? await provider.openCamera(context)
            : await provider.openLibrary(context);
      }
      if (context.mounted) Navigator.pop(context);
      return;
    }

    final status = isCamera
        ? await ImagePermissionUtil.cameraPermission()
        : await ImagePermissionUtil.libraryPermission();
    if (!context.mounted) return;
    if (status == PermissionStatus.granted) {
      if (index != null) {
        isCamera
            ? await provider.openCamera(context, index)
            : await provider.openLibrary(context, index);
      } else {
        isCamera
            ? await provider.openCamera(context)
            : await provider.openLibrary(context);
      }
      if (context.mounted) Navigator.pop(context);
    } else if (status == PermissionStatus.permanentlyDenied) {
      if (context.mounted) Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => DeniedDialogWidget(isCamera: isCamera),
      );
    } else {
      if (context.mounted) Navigator.pop(context);
      SnackbarUtil.showSnackBar(
        context,
        "${isCamera ? "Camera" : "Library"} permission denied",
        true,
      );
    }
  }
}

