import 'dart:io';
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
    return File(cropped.path);
  }
}

