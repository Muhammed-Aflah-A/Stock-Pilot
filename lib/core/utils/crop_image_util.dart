import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stock_pilot/core/theme/colours_styles.dart';

class ImageCropUtil {
  static Future<File?> cropImage(File file) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ColourStyles.primaryColor_2,
          toolbarWidgetColor: ColourStyles.primaryColor,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    if (cropped == null) return null;
    return kIsWeb ? null : File(cropped.path);
  }

  static Future<String?> cropImageToPath(
    String path, {
    BuildContext? context,
  }) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ColourStyles.primaryColor_2,
          toolbarWidgetColor: ColourStyles.primaryColor,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
        if (kIsWeb && context != null)
          WebUiSettings(context: context, presentStyle: WebPresentStyle.page),
      ],
    );
    if (cropped == null) return null;

    if (kIsWeb) {
      // Convert cropped blob back to Base64 for persistence
      final bytes = await cropped.readAsBytes();
      return 'data:image/png;base64,${base64Encode(bytes)}';
    }

    return cropped.path;
  }
}
